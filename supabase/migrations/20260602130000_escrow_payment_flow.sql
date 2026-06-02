-- ============================================================
-- Priority 9: Escrow Payment Flow
-- Migration: 20260602130000_escrow_payment_flow.sql
-- ============================================================

-- 1. Immutable helper function required for GENERATED column on TIMESTAMPTZ
--    (PostgreSQL rejects non-immutable expressions in generated columns;
--     this wrapper is declared IMMUTABLE so the planner accepts it.)
CREATE OR REPLACE FUNCTION public.add_48_hours(t TIMESTAMPTZ)
RETURNS TIMESTAMPTZ
LANGUAGE SQL IMMUTABLE AS $$
  SELECT t + INTERVAL '48 hours';
$$;

-- 2. Create escrow_transactions table
CREATE TABLE IF NOT EXISTS public.escrow_transactions (
  id               UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  transaction_id   UUID NOT NULL REFERENCES public.transactions(id) ON DELETE CASCADE,
  status           TEXT NOT NULL DEFAULT 'held'
                   CHECK (status IN ('held', 'released', 'refunded', 'disputed')),
  dispute_reason   TEXT,
  created_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  release_deadline TIMESTAMP WITH TIME ZONE
                   GENERATED ALWAYS AS (public.add_48_hours(created_at)) STORED
);

-- 3. Performance indexes
CREATE INDEX IF NOT EXISTS idx_escrow_transaction_id  ON public.escrow_transactions (transaction_id);
CREATE INDEX IF NOT EXISTS idx_escrow_status          ON public.escrow_transactions (status);
CREATE INDEX IF NOT EXISTS idx_escrow_release_deadline ON public.escrow_transactions (release_deadline)
  WHERE status = 'held';

-- 4. updated_at auto-refresh trigger
CREATE OR REPLACE FUNCTION public.set_escrow_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_escrow_updated_at ON public.escrow_transactions;
CREATE TRIGGER trg_escrow_updated_at
  BEFORE UPDATE ON public.escrow_transactions
  FOR EACH ROW EXECUTE FUNCTION public.set_escrow_updated_at();

-- 5. Row-Level Security
ALTER TABLE public.escrow_transactions ENABLE ROW LEVEL SECURITY;

-- Buyers and sellers can view their own escrow records
DROP POLICY IF EXISTS "escrow_select_parties" ON public.escrow_transactions;
CREATE POLICY "escrow_select_parties"
  ON public.escrow_transactions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.transactions t
      WHERE t.id = escrow_transactions.transaction_id
        AND (t.buyer_id = auth.uid() OR t.seller_id = auth.uid())
    )
  );

-- Only the buyer can dispute or release (INSERT not needed — webhook inserts via service_role)
DROP POLICY IF EXISTS "escrow_update_buyer" ON public.escrow_transactions;
CREATE POLICY "escrow_update_buyer"
  ON public.escrow_transactions FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.transactions t
      WHERE t.id = escrow_transactions.transaction_id
        AND t.buyer_id = auth.uid()
    )
  );

-- 6. Enable pg_net (required for pg_cron HTTP calls)
CREATE EXTENSION IF NOT EXISTS pg_net SCHEMA extensions;

-- 7. Schedule hourly pg_cron job to trigger auto-release of expired escrows
--    The job uses the broadcast_secret from app_secrets for authorization.
--    Runs at minute 0 of every hour (0 * * * *).
SELECT cron.unschedule('auto-release-escrows-job') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'auto-release-escrows-job'
);

SELECT cron.schedule(
  'auto-release-escrows-job',
  '0 * * * *',
  $$
  SELECT public.http_post(
    url   := 'https://jacnsvcwmhoicuuzmrmr.supabase.co/functions/v1/process-escrow',
    headers := jsonb_build_object(
      'Content-Type',   'application/json',
      'x-cron-secret',  (SELECT value FROM public.app_secrets WHERE key = 'broadcast_secret' LIMIT 1)
    ),
    body  := '{"action":"auto-release-expired"}'::jsonb
  );
  $$
);
