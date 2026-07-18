use crate::error::AppError;
use sqlx::PgPool;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

pub struct FapshiClient {
    http: reqwest::Client,
    base_url: String,
}

#[derive(Serialize, Clone)]
pub struct PayoutPayload {
    pub amount: f64,
    pub phone: String,
    pub name: String,
    #[serde(rename = "externalId")]
    pub external_id: String,
    pub message: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct PayoutResponse {
    #[serde(rename = "statusCode")]
    pub status_code: u16,
    #[serde(rename = "transId")]
    pub trans_id: Option<String>,
    pub message: Option<String>,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct PollResponse {
    pub status: Option<String>,
    pub state: Option<String>,
    #[serde(rename = "statusCode")]
    pub status_code: Option<u16>,
    pub message: Option<String>,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct FapshiSearchItem {
    #[serde(rename = "transId")]
    pub trans_id: String,
    pub status: String,
    #[serde(rename = "externalId")]
    pub external_id: Option<String>,
}

impl FapshiClient {
    pub fn new(base_url: String) -> Self {
        Self {
            http: reqwest::Client::new(),
            base_url,
        }
    }

    /// Fetches a key from the `app_secrets` table.
    async fn get_secret(pool: &PgPool, key: &str) -> Result<String, AppError> {
        let row: (String,) = sqlx::query_as("SELECT value FROM app_secrets WHERE key = $1")
            .bind(key)
            .fetch_one(pool)
            .await?;
        Ok(row.0)
    }

    /// Clean phone number: remove non-digits and strip leading "237".
    pub fn clean_phone(phone: &str) -> String {
        let mut cleaned: String = phone.chars().filter(|c| c.is_ascii_digit()).collect();
        if cleaned.starts_with("237") && cleaned.len() > 3 {
            cleaned = cleaned[3..].to_string();
        }
        cleaned
    }

    /// Get payout endpoint.
    fn payout_url(&self) -> String {
        if self.base_url.contains("live.fapshi.com") || self.base_url.contains("api.fapshi.com") {
            "https://live.fapshi.com/payout".to_string()
        } else {
            format!("{}/payout", self.base_url)
        }
    }

    /// Get status endpoint.
    fn status_url(&self, reference: &str) -> String {
        if self.base_url.contains("live.fapshi.com") || self.base_url.contains("api.fapshi.com") {
            format!("https://api.fapshi.com/payment-status/{}", reference)
        } else {
            format!("{}/payment-status/{}", self.base_url, reference)
        }
    }

    /// Checks if a payout has already been processed successfully on Fapshi by searching by externalId.
    pub async fn check_existing_payout(
        &self,
        pool: &PgPool,
        external_id: &str,
    ) -> Result<Option<String>, AppError> {
        let api_user = Self::get_secret(pool, "fapshi_payout_api_user").await?;
        let api_key = Self::get_secret(pool, "fapshi_payout_api_key").await?;

        let endpoint = if self.base_url.contains("live.fapshi.com") || self.base_url.contains("api.fapshi.com") {
            "https://live.fapshi.com/search".to_string()
        } else {
            format!("{}/search", self.base_url)
        };

        let response = self.http.get(&endpoint)
            .header("apiuser", &api_user)
            .header("apikey", &api_key)
            .query(&[("externalId", external_id)])
            .send()
            .await;

        match response {
            Ok(res) => {
                let status = res.status().as_u16();
                if status == 200 {
                    let items: Vec<FapshiSearchItem> = res.json().await?;
                    for item in items {
                        if let Some(ref ext_id) = item.external_id {
                            if ext_id == external_id {
                                let status_upper = item.status.to_uppercase();
                                if status_upper == "SUCCESSFUL" || status_upper == "SUCCESS" {
                                    return Ok(Some(item.trans_id));
                                }
                            }
                        }
                    }
                    Ok(None)
                } else {
                    let body_text = res.text().await.unwrap_or_else(|_| "No body".to_string());
                    Err(AppError::Fapshi(format!("Fapshi search returned status {}: {}", status, body_text)))
                }
            }
            Err(e) => {
                Err(AppError::Reqwest(e))
            }
        }
    }

    /// Performs payout via Fapshi and logs to fapshi_audit_logs.
    #[allow(clippy::too_many_arguments)]
    pub async fn execute_payout(
        &self,
        pool: &PgPool,
        tx_id: Uuid,
        amount: f64,
        phone: &str,
        seller_name: &str,
        external_id: &str,
        listing_id: Uuid,
    ) -> Result<String, AppError> {
        let api_user = Self::get_secret(pool, "fapshi_payout_api_user").await?;
        let api_key = Self::get_secret(pool, "fapshi_payout_api_key").await?;

        let cleaned_phone = Self::clean_phone(phone);
        let request_payload = PayoutPayload {
            amount,
            phone: cleaned_phone,
            name: seller_name.to_string(),
            external_id: external_id.to_string(),
            message: format!("BookBridge escrow payout for listing {}", listing_id),
        };

        let endpoint = self.payout_url();
        let req_val = serde_json::to_value(&request_payload)?;

        let response = self.http.post(&endpoint)
            .header("Content-Type", "application/json")
            .header("apiuser", &api_user)
            .header("apikey", &api_key)
            .json(&request_payload)
            .send()
            .await;

        let (status_code, resp_val, result) = match response {
            Ok(res) => {
                let status = res.status().as_u16();
                let body_res: Result<PayoutResponse, _> = res.json().await;
                match body_res {
                    Ok(body) => {
                        let val = serde_json::to_value(&body)?;
                        if status == 200 && body.status_code == 200 {
                            if let Some(trans_id) = body.trans_id {
                                (status, val, Ok(trans_id))
                            } else {
                                (status, val, Err(AppError::Fapshi("Payout succeeded but transId was missing".to_string())))
                            }
                        } else {
                            let msg = body.message.unwrap_or_else(|| "Unknown Fapshi payout error".to_string());
                            (status, val, Err(AppError::Fapshi(format!("Fapshi payout error ({}): {}", body.status_code, msg))))
                        }
                    }
                    Err(e) => {
                        let err_msg = format!("JSON decode error: {}", e);
                        (status, serde_json::json!({ "error": err_msg }), Err(AppError::Reqwest(e)))
                    }
                }
            }
            Err(e) => {
                let err_msg = format!("Network error: {}", e);
                (500, serde_json::json!({ "error": err_msg }), Err(AppError::Reqwest(e)))
            }
        };

        // Write to fapshi_audit_logs (gracefully catch errors to prevent double-payouts on db connection drops)
        if let Err(e) = sqlx::query(
            "INSERT INTO fapshi_audit_logs (transaction_id, endpoint, request_payload, response_payload, status_code) VALUES ($1, $2, $3, $4, $5)"
        )
        .bind(tx_id)
        .bind(&endpoint)
        .bind(req_val)
        .bind(resp_val)
        .bind(status_code as i32)
        .execute(pool)
        .await {
            tracing::error!("Failed to write to fapshi_audit_logs during payout: {:?}", e);
        }

        result
    }

    /// Queries Fapshi status for polling stuck transactions.
    pub async fn poll_payment_status(
        &self,
        pool: &PgPool,
        tx_id: Uuid,
        reference: &str,
    ) -> Result<String, AppError> {
        let api_user = Self::get_secret(pool, "fapshi_api_user").await?;
        let api_key = Self::get_secret(pool, "fapshi_api_key").await?;

        let endpoint = self.status_url(reference);

        let response = self.http.get(&endpoint)
            .header("apiuser", &api_user)
            .header("apikey", &api_key)
            .send()
            .await;

        let (status_code, resp_val, result) = match response {
            Ok(res) => {
                let status = res.status().as_u16();
                let body_res: Result<PollResponse, _> = res.json().await;
                match body_res {
                    Ok(body) => {
                        let val = serde_json::to_value(&body)?;
                        if status == 200 {
                            let fapshi_status = body.status.or(body.state).unwrap_or_default();
                            (status, val, Ok(fapshi_status))
                        } else {
                            let msg = body.message.unwrap_or_else(|| "Unknown status check error".to_string());
                            (status, val, Err(AppError::Fapshi(format!("Fapshi poll error ({}): {}", status, msg))))
                        }
                    }
                    Err(e) => {
                        let err_msg = format!("JSON decode error: {}", e);
                        (status, serde_json::json!({ "error": err_msg }), Err(AppError::Reqwest(e)))
                    }
                }
            }
            Err(e) => {
                let err_msg = format!("Network error: {}", e);
                (500, serde_json::json!({ "error": err_msg }), Err(AppError::Reqwest(e)))
            }
        };

        // Write to fapshi_audit_logs for audit trail (gracefully log errors)
        if let Err(e) = sqlx::query(
            "INSERT INTO fapshi_audit_logs (transaction_id, endpoint, request_payload, response_payload, status_code) VALUES ($1, $2, $3, $4, $5)"
        )
        .bind(tx_id)
        .bind(&endpoint)
        .bind(serde_json::Value::Null)
        .bind(resp_val)
        .bind(status_code as i32)
        .execute(pool)
        .await {
            tracing::error!("Failed to write to fapshi_audit_logs during polling: {:?}", e);
        }

        result
    }
}
