use axum::{extract::State, http::HeaderMap, response::IntoResponse, Json};
use serde::{Deserialize, Serialize};
use crate::error::AppError;
use crate::auth::constant_time_compare;
use crate::routes::escrow::handle_purchase_success_db;
use crate::AppState;
use sqlx::{PgPool, Row};
use uuid::Uuid;
use chrono::Utc;

#[derive(Deserialize, Serialize, Debug)]
pub struct FapshiWebhookPayload {
    pub status: Option<String>,
    pub state: Option<String>,
    #[serde(rename = "transId")]
    pub trans_id: Option<String>,
    #[serde(rename = "transactionId")]
    pub transaction_id: Option<String>,
    pub id: Option<String>,
    pub amount: Option<serde_json::Value>,
    #[serde(rename = "externalId")]
    pub external_id: Option<String>,
    #[serde(rename = "externalReference")]
    pub external_reference: Option<String>,
    pub custom: Option<String>,
}

async fn verify_webhook_auth(pool: &PgPool, headers: &HeaderMap) -> Result<(), AppError> {
    // A. Check x-wh-secret header (dashboard verification key)
    if let Some(wh_secret_header) = headers.get("x-wh-secret").and_then(|h| h.to_str().ok()) {
        let secret_row: Option<(String,)> = sqlx::query_as("SELECT value FROM app_secrets WHERE key = 'fapshi_webhook_secret'")
            .fetch_optional(pool)
            .await?;
        
        if let Some(row) = secret_row {
            if constant_time_compare(wh_secret_header.as_bytes(), row.0.as_bytes()) {
                return Ok(());
            }
        }
    }

    // B. Check apiuser and apikey fallback headers (legacy compatibility)
    let provided_api_user = headers.get("apiuser").and_then(|h| h.to_str().ok());
    let provided_api_key = headers.get("apikey").and_then(|h| h.to_str().ok());

    if let (Some(incoming_user), Some(incoming_key)) = (provided_api_user, provided_api_key) {
        let expected_user_row: Option<(String,)> = sqlx::query_as("SELECT value FROM app_secrets WHERE key = 'fapshi_payout_api_user'")
            .fetch_optional(pool)
            .await?;
        let expected_key_row: Option<(String,)> = sqlx::query_as("SELECT value FROM app_secrets WHERE key = 'fapshi_payout_api_key'")
            .fetch_optional(pool)
            .await?;

        if let (Some(exp_user), Some(exp_key)) = (expected_user_row, expected_key_row) {
            let user_matches = constant_time_compare(incoming_user.as_bytes(), exp_user.0.as_bytes());
            let key_matches = constant_time_compare(incoming_key.as_bytes(), exp_key.0.as_bytes());
            if user_matches && key_matches {
                return Ok(());
            }
        }
    }

    tracing::warn!("Unauthorized webhook request: invalid credentials or headers");
    Err(AppError::Unauthorized("Invalid authentication credentials".to_string()))
}

fn parse_purchase_ref(external_ref: &str) -> Result<(Uuid, Uuid), AppError> {
    let separator = if external_ref.contains(':') { ':' } else { '_' };
    let parts: Vec<&str> = external_ref.split(separator).collect();
    if parts.len() < 3 {
        return Err(AppError::BadRequest("Malformed external_reference for purchase".to_string()));
    }
    let listing_id = Uuid::parse_str(parts[1])
        .map_err(|_| AppError::BadRequest("Invalid listing_id UUID".to_string()))?;
    let buyer_id = Uuid::parse_str(parts[2])
        .map_err(|_| AppError::BadRequest("Invalid buyer_id UUID".to_string()))?;
    Ok((listing_id, buyer_id))
}

fn parse_boost_ref(external_ref: &str) -> Result<(Uuid, i32), AppError> {
    let separator = if external_ref.contains(':') { ':' } else { '_' };
    let parts: Vec<&str> = external_ref.split(separator).collect();
    if parts.len() < 2 {
        return Err(AppError::BadRequest("Malformed external_reference for boost".to_string()));
    }
    let listing_id = Uuid::parse_str(parts[1])
        .map_err(|_| AppError::BadRequest("Invalid listing_id UUID".to_string()))?;
    let duration = if parts.len() >= 3 {
        parts[2].parse::<i32>().unwrap_or(7)
    } else {
        7
    };
    Ok((listing_id, duration))
}

fn parse_donation_ref(external_ref: &str) -> Result<Option<Uuid>, AppError> {
    let separator = if external_ref.contains(':') { ':' } else { '_' };
    let parts: Vec<&str> = external_ref.split(separator).collect();
    if parts.len() < 2 {
        return Err(AppError::BadRequest("Malformed external_reference for donation".to_string()));
    }
    let user_id_str = parts[1];
    if user_id_str == "anonymous" {
        Ok(None)
    } else {
        let uid = Uuid::parse_str(user_id_str)
            .map_err(|_| AppError::BadRequest("Invalid user_id UUID".to_string()))?;
        Ok(Some(uid))
    }
}

async fn handle_boost_success(
    pool: &PgPool,
    reference: &str,
    amount: f64,
    external_ref: &str,
) -> Result<(), AppError> {
    let (listing_id, duration) = parse_boost_ref(external_ref)?;

    let listing_row = sqlx::query("SELECT seller_id FROM listings WHERE id = $1")
        .bind(listing_id)
        .fetch_optional(pool)
        .await?;

    let listing = match listing_row {
        Some(row) => row,
        None => return Err(AppError::BadRequest(format!("Listing {} not found for boost", listing_id))),
    };
    let user_id: Uuid = listing.get("seller_id");

    let now = Utc::now();
    let rows_affected = sqlx::query(
        "INSERT INTO boost_payments ( \
            payment_reference, listing_id, user_id, amount, duration_days, status, created_at \
         ) \
         VALUES ($1, $2, $3, $4, $5, 'successful', $6) \
         ON CONFLICT (payment_reference) DO NOTHING"
    )
    .bind(reference)
    .bind(listing_id)
    .bind(user_id)
    .bind(amount)
    .bind(duration)
    .bind(now)
    .execute(pool)
    .await?
    .rows_affected();

    if rows_affected == 0 {
        tracing::info!("Boost payment with reference {} already recorded. Skipping listing boost update.", reference);
        return Ok(());
    }

    let expires_at = now + chrono::Duration::days(duration as i64);
    sqlx::query(
        "UPDATE listings SET is_boosted = true, boost_expires_at = $1 WHERE id = $2"
    )
    .bind(expires_at)
    .bind(listing_id)
    .execute(pool)
    .await?;

    Ok(())
}

async fn handle_donation_success(
    pool: &PgPool,
    reference: &str,
    amount: f64,
    external_ref: &str,
) -> Result<(), AppError> {
    let user_id = parse_donation_ref(external_ref)?;
    let now = Utc::now();

    sqlx::query(
        "INSERT INTO donations (payment_reference, user_id, amount, status, created_at) \
         VALUES ($1, $2, $3, 'successful', $4) \
         ON CONFLICT (payment_reference) DO NOTHING"
    )
    .bind(reference)
    .bind(user_id)
    .bind(amount)
    .bind(now)
    .execute(pool)
    .await?;

    Ok(())
}

async fn handle_purchase_success(
    state: &AppState,
    reference: &str,
    amount: f64,
    external_ref: &str,
) -> Result<(), AppError> {
    let (listing_id, buyer_id) = parse_purchase_ref(external_ref)?;

    let listing_row = sqlx::query("SELECT seller_id FROM listings WHERE id = $1")
        .bind(listing_id)
        .fetch_optional(&state.pool)
        .await?;

    let listing = match listing_row {
        Some(row) => row,
        None => return Err(AppError::BadRequest(format!("Listing {} not found for purchase", listing_id))),
    };
    let seller_id: Uuid = listing.get("seller_id");

    let payout_amount = (amount * 0.95).floor();
    let commission_amount = amount - payout_amount;

    let now = Utc::now();

    // Atomically upsert the transaction using ON CONFLICT DO UPDATE.
    // If the transaction status is already 'held' or 'successful' (completed), the DO UPDATE will fail the WHERE clause
    // and return 0 rows.
    let tx_row = sqlx::query(
        "INSERT INTO transactions ( \
            payment_reference, listing_id, buyer_id, seller_id, amount, status, \
            payout_status, payout_reference, commission_amount, created_at \
         ) \
         VALUES ($1, $2, $3, $4, $5, 'held', 'pending', NULL, $6, $7) \
         ON CONFLICT (payment_reference) \
         DO UPDATE SET \
             status = 'held', \
             updated_at = $7 \
         WHERE transactions.status = 'pending_payment' \
         RETURNING id"
    )
    .bind(reference)
    .bind(listing_id)
    .bind(buyer_id)
    .bind(seller_id)
    .bind(amount)
    .bind(commission_amount)
    .bind(now)
    .fetch_optional(&state.pool)
    .await?;

    let tx_id = match tx_row {
        Some(row) => {
            let id: Uuid = row.get("id");
            id
        }
        None => {
            tracing::info!("Transaction with reference {} already claimed or processed. Skipping success logic.", reference);
            return Ok(());
        }
    };

    let mut transaction = state.pool.begin().await?;
    
    if let Err(e) = handle_purchase_success_db(
        &mut transaction,
        listing_id,
        buyer_id,
        seller_id,
        tx_id,
        now,
    ).await {
        tracing::error!("Error writing webhook purchase success updates: {:?}", e);
        transaction.rollback().await?;
        return Err(e);
    }

    transaction.commit().await?;

    Ok(())
}

async fn handle_purchase_pending(
    pool: &PgPool,
    reference: &str,
    amount: f64,
    external_ref: &str,
) -> Result<(), AppError> {
    let (listing_id, buyer_id) = parse_purchase_ref(external_ref)?;

    let listing_row = sqlx::query("SELECT seller_id FROM listings WHERE id = $1")
        .bind(listing_id)
        .fetch_optional(pool)
        .await?;

    let listing = match listing_row {
        Some(row) => row,
        None => return Err(AppError::BadRequest(format!("Listing {} not found", listing_id))),
    };
    let seller_id: Uuid = listing.get("seller_id");

    let payout_amount = (amount * 0.95).floor();
    let commission_amount = amount - payout_amount;

    let now = Utc::now();
    sqlx::query(
        "INSERT INTO transactions ( \
            payment_reference, listing_id, buyer_id, seller_id, amount, status, \
            payout_status, payout_reference, commission_amount, created_at \
         ) \
         VALUES ($1, $2, $3, $4, $5, 'pending_payment', 'pending', NULL, $6, $7) \
         ON CONFLICT (payment_reference) \
         DO UPDATE SET status = 'pending_payment', updated_at = $7 \
         WHERE transactions.status = 'pending_payment'"
    )
    .bind(reference)
    .bind(listing_id)
    .bind(buyer_id)
    .bind(seller_id)
    .bind(amount)
    .bind(commission_amount)
    .bind(now)
    .execute(pool)
    .await?;

    Ok(())
}

pub async fn fapshi_webhook_handler(
    State(state): State<AppState>,
    headers: HeaderMap,
    Json(body): Json<serde_json::Value>,
) -> Result<impl IntoResponse, AppError> {
    verify_webhook_auth(&state.pool, &headers).await?;

    let payload_val = if let Some(arr) = body.as_array() {
        if arr.is_empty() {
            return Err(AppError::BadRequest("Empty payload array".to_string()));
        }
        &arr[0]
    } else if body.is_object() {
        &body
    } else {
        return Err(AppError::BadRequest("Invalid webhook payload format".to_string()));
    };

    let payload: FapshiWebhookPayload = serde_json::from_value(payload_val.clone())
        .map_err(|e| AppError::BadRequest(format!("Failed to parse webhook payload: {}", e)))?;

    let status = payload.status.or(payload.state).ok_or_else(|| AppError::BadRequest("Missing status/state field".to_string()))?;
    let reference = payload.trans_id.or(payload.transaction_id).or(payload.id).ok_or_else(|| AppError::BadRequest("Missing transId/id reference field".to_string()))?;
    let amount_val = payload.amount.ok_or_else(|| AppError::BadRequest("Missing amount field".to_string()))?;
    let external_reference = payload.external_id.or(payload.external_reference).or(payload.custom).unwrap_or_default();

    let amount = match amount_val {
        serde_json::Value::Number(num) => num.as_f64().unwrap_or(0.0),
        serde_json::Value::String(s) => s.parse::<f64>().unwrap_or(0.0),
        _ => return Err(AppError::BadRequest("Invalid amount type".to_string())),
    };

    let status_upper = status.to_uppercase();

    tracing::info!("Processing incoming Fapshi webhook for ref: {}, status: {}, external: {}", reference, status_upper, external_reference);

    if status_upper == "SUCCESSFUL" || status_upper == "SUCCESS" {
        if external_reference.starts_with("boost:") || external_reference.starts_with("boost_") {
            handle_boost_success(&state.pool, &reference, amount, &external_reference).await?;
        } else if external_reference.starts_with("donation:") || external_reference.starts_with("donation_") {
            handle_donation_success(&state.pool, &reference, amount, &external_reference).await?;
        } else if external_reference.starts_with("purchase:") || external_reference.starts_with("purchase_") {
            handle_purchase_success(&state, &reference, amount, &external_reference).await?;
        } else {
            tracing::warn!("Unknown externalReference: {}", external_reference);
        }
    } else if (status_upper == "CREATED" || status_upper == "PENDING" || status_upper == "PENDING_PAYMENT")
        && (external_reference.starts_with("purchase:") || external_reference.starts_with("purchase_"))
    {
        handle_purchase_pending(&state.pool, &reference, amount, &external_reference).await?;
    } else if (status_upper == "FAILED" || status_upper == "EXPIRED")
        && (external_reference.starts_with("purchase:") || external_reference.starts_with("purchase_"))
    {
        tracing::info!("Marking transaction failed: Ref={}", reference);
        sqlx::query("UPDATE transactions SET status = 'failed' WHERE payment_reference = $1")
            .bind(&reference)
            .execute(&state.pool)
            .await?;
    }

    Ok((axum::http::StatusCode::OK, Json(serde_json::json!({ "success": true }))))
}
