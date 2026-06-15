import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FAPSHI_PAYOUT_URL = "https://live.fapshi.com/payout";

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function adminClient() {
  return createClient(supabaseUrl, supabaseServiceKey);
}

function userClient(jwt: string) {
  return createClient(supabaseUrl, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  });
}

/** Returns the bearer token from the Authorization header, or null. */
function extractJwt(req: Request): string | null {
  const auth = req.headers.get("Authorization");
  if (!auth?.startsWith("Bearer ")) return null;
  return auth.slice(7);
}

/** Verify the caller is an admin via service_role key or a trusted cron secret. */
function isAdmin(req: Request): boolean {
  const cronSecret = req.headers.get("x-cron-secret");
  if (cronSecret) {
    // validated below in auto-release; here we just flag that it came via cron header
    return true;
  }
  const authKey = req.headers.get("x-supabase-admin-key");
  return authKey === supabaseServiceKey;
}

/**
 * Execute a payout via Fapshi and return { ok, transId, error }.
 * Statuses are NEVER updated unless this returns ok = true.
 */
async function executeFapshiPayout(params: {
  amount: number;
  phone: string;
  sellerName: string;
  externalId: string;
  listingId: string;
  transactionId: string;
}): Promise<{ ok: boolean; transId?: string; error?: string }> {
  let cleanedPhone = params.phone.replace(/\D/g, "");
  if (cleanedPhone.startsWith("237")) cleanedPhone = cleanedPhone.slice(3);

  const requestPayload = {
    amount: params.amount,
    phone: cleanedPhone,
    name: params.sellerName,
    externalId: params.externalId,
    message: `BookBridge escrow payout for listing ${params.listingId}`,
  };

  let res: Response;
  let responsePayload: any = null;
  let statusCode = 0;

  const supabase = adminClient();

  // Retrieve Fapshi payout credentials from database secrets
  const { data: userRow } = await supabase
    .from("app_secrets")
    .select("value")
    .eq("key", "fapshi_payout_api_user")
    .single();
  const { data: keyRow } = await supabase
    .from("app_secrets")
    .select("value")
    .eq("key", "fapshi_payout_api_key")
    .single();

  const fapshiPayoutUser = userRow?.value;
  const fapshiPayoutKey = keyRow?.value;

  if (!fapshiPayoutUser || !fapshiPayoutKey) {
    return { ok: false, error: "Fapshi payout credentials not configured in app_secrets" };
  }

  try {
    res = await fetch(FAPSHI_PAYOUT_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        apiuser: fapshiPayoutUser,
        apikey: fapshiPayoutKey,
      },
      body: JSON.stringify(requestPayload),
    });
    statusCode = res.status;
    responsePayload = await res.json().catch(() => ({}));
  } catch (err) {
    await supabase.from("fapshi_audit_logs").insert({
      transaction_id: params.transactionId,
      endpoint: FAPSHI_PAYOUT_URL,
      request_payload: requestPayload,
      response_payload: { error: String(err) },
      status_code: 500,
    });
    return { ok: false, error: `Network error: ${String(err)}` };
  }

  await supabase.from("fapshi_audit_logs").insert({
    transaction_id: params.transactionId,
    endpoint: FAPSHI_PAYOUT_URL,
    request_payload: requestPayload,
    response_payload: responsePayload,
    status_code: statusCode,
  });

  if (res.ok && responsePayload?.statusCode === 200) {
    return { ok: true, transId: responsePayload.transId };
  }
  return {
    ok: false,
    error: `Fapshi error ${res.status}: ${JSON.stringify(responsePayload)}`,
  };
}

/**
 * Release a single escrow:
 *  1. Fetch transaction + seller profile.
 *  2. Execute Fapshi payout.
 *  3. ONLY on success → update escrow + transaction statuses.
 * Returns { ok, error? }.
 */
async function releaseEscrow(
  transactionId: string,
  supabase = adminClient()
): Promise<{ ok: boolean; error?: string }> {
  // Fetch transaction
  const { data: tx, error: txErr } = await supabase
    .from("transactions")
    .select("id, listing_id, seller_id, amount, commission_amount, payment_reference")
    .eq("id", transactionId)
    .single();

  if (txErr || !tx) {
    return { ok: false, error: `Transaction not found: ${txErr?.message}` };
  }

  // Fetch seller profile
  const { data: profile } = await supabase
    .from("profiles")
    .select("whatsapp_number, full_name")
    .eq("id", tx.seller_id)
    .single();

  if (!profile?.whatsapp_number) {
    return { ok: false, error: "Seller has no payout number configured." };
  }

  const payoutAmount = tx.amount - (tx.commission_amount ?? 0);
  const externalId = `escrow_payout_${tx.payment_reference}`;

  // ── PAYOUT FIRST ────────────────────────────────────────────────────────
  const payout = await executeFapshiPayout({
    amount: payoutAmount,
    phone: profile.whatsapp_number,
    sellerName: profile.full_name ?? "BookBridge Seller",
    externalId,
    listingId: tx.listing_id,
    transactionId: tx.id,
  });

  if (!payout.ok) {
    return { ok: false, error: payout.error };
  }
  // ── ONLY UPDATE DB AFTER CONFIRMED PAYOUT ────────────────────────────────

  const now = new Date().toISOString();

  const { error: escrowErr } = await supabase
    .from("escrow_transactions")
    .update({ status: "released", updated_at: now })
    .eq("transaction_id", transactionId)
    .eq("status", "held");

  if (escrowErr) {
    console.error("escrow update failed after payout:", escrowErr);
    // Payout already sent — log but don't surface as failure
  }

  const { error: txUpdateErr } = await supabase
    .from("transactions")
    .update({
      status: "successful",
      payout_status: "successful",
      payout_reference: payout.transId,
    })
    .eq("id", transactionId);

  if (txUpdateErr) {
    console.error("transaction update failed after payout:", txUpdateErr);
  }

  return { ok: true };
}

// ---------------------------------------------------------------------------
// Route handlers
// ---------------------------------------------------------------------------

async function handleRelease(req: Request): Promise<Response> {
  const jwt = extractJwt(req);
  if (!jwt) return resp(401, { error: "Unauthorized" });

  const { transaction_id } = await req.json();
  if (!transaction_id) return resp(400, { error: "transaction_id required" });

  // Verify caller is the buyer
  const client = userClient(jwt);
  const { data: { user } } = await client.auth.getUser();
  if (!user) return resp(401, { error: "Invalid token" });

  const { data: tx } = await adminClient()
    .from("transactions")
    .select("buyer_id, status")
    .eq("id", transaction_id)
    .single();

  if (!tx) return resp(404, { error: "Transaction not found" });
  if (tx.buyer_id !== user.id) return resp(403, { error: "Forbidden" });
  if (tx.status !== "held") return resp(409, { error: `Transaction is '${tx.status}', not 'held'` });

  const result = await releaseEscrow(transaction_id);
  return result.ok
    ? resp(200, { ok: true })
    : resp(500, { error: result.error });
}

async function handleDispute(req: Request): Promise<Response> {
  const jwt = extractJwt(req);
  if (!jwt) return resp(401, { error: "Unauthorized" });

  const { transaction_id, dispute_reason } = await req.json();
  if (!transaction_id || !dispute_reason) {
    return resp(400, { error: "transaction_id and dispute_reason required" });
  }

  const client = userClient(jwt);
  const { data: { user } } = await client.auth.getUser();
  if (!user) return resp(401, { error: "Invalid token" });

  const supabase = adminClient();

  const { data: tx } = await supabase
    .from("transactions")
    .select("buyer_id, status")
    .eq("id", transaction_id)
    .single();

  if (!tx) return resp(404, { error: "Transaction not found" });
  if (tx.buyer_id !== user.id) return resp(403, { error: "Forbidden" });
  if (tx.status !== "held") return resp(409, { error: `Transaction is '${tx.status}', not 'held'` });

  const now = new Date().toISOString();

  await supabase
    .from("escrow_transactions")
    .update({ status: "disputed", dispute_reason, updated_at: now })
    .eq("transaction_id", transaction_id);

  await supabase
    .from("transactions")
    .update({ status: "disputed" })
    .eq("id", transaction_id);

  return resp(200, { ok: true });
}

async function handleAutoReleaseExpired(req: Request): Promise<Response> {
  // Validate cron secret
  const supabase = adminClient();
  const cronSecret = req.headers.get("x-cron-secret");
  const { data: secretRow } = await supabase
    .from("app_secrets")
    .select("value")
    .eq("key", "broadcast_secret")
    .single();

  if (!cronSecret || cronSecret !== secretRow?.value) {
    return resp(401, { error: "Unauthorized" });
  }

  // Find all held escrows whose release_deadline has passed
  const { data: expired, error } = await supabase
    .from("escrow_transactions")
    .select("transaction_id")
    .eq("status", "held")
    .lte("release_deadline", new Date().toISOString());

  if (error) return resp(500, { error: error.message });

  const results: Array<{ transaction_id: string; ok: boolean; error?: string }> = [];

  for (const row of expired ?? []) {
    const result = await releaseEscrow(row.transaction_id, supabase);
    results.push({ transaction_id: row.transaction_id, ...result });
    console.log(`auto-release ${row.transaction_id}: ${result.ok ? "OK" : result.error}`);
  }

  return resp(200, { released: results.length, results });
}

async function handleResolveDispute(req: Request): Promise<Response> {
  // Admin only — validate service_role key
  const adminKey = req.headers.get("x-supabase-admin-key");
  if (adminKey !== supabaseServiceKey) {
    return resp(401, { error: "Admin authorization required" });
  }

  const { transaction_id, action } = await req.json();
  if (!transaction_id || !["release", "refund"].includes(action)) {
    return resp(400, { error: "transaction_id and action ('release'|'refund') required" });
  }

  const supabase = adminClient();
  const now = new Date().toISOString();

  if (action === "release") {
    const result = await releaseEscrow(transaction_id, supabase);
    return result.ok
      ? resp(200, { ok: true, action: "released" })
      : resp(500, { error: result.error });
  }

  // action === "refund"
  await supabase
    .from("escrow_transactions")
    .update({ status: "refunded", updated_at: now })
    .eq("transaction_id", transaction_id);

  await supabase
    .from("transactions")
    .update({ status: "failed" })
    .eq("id", transaction_id);

  return resp(200, { ok: true, action: "refunded" });
}

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

function resp(status: number, body: unknown): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

Deno.serve(async (req: Request) => {
  try {
    const { action } = await req.clone().json().catch(() => ({ action: null }));

    switch (action) {
      case "release":
        return await handleRelease(req);
      case "dispute":
        return await handleDispute(req);
      case "auto-release-expired":
        return await handleAutoReleaseExpired(req);
      case "resolve-dispute":
        return await handleResolveDispute(req);
      default:
        return resp(400, {
          error: "Unknown action. Valid: release | dispute | auto-release-expired | resolve-dispute",
        });
    }
  } catch (err) {
    console.error("process-escrow unhandled error:", err);
    return resp(500, { error: String(err) });
  }
});
