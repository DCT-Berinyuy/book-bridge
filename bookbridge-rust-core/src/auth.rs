use axum::{
    body::Body,
    extract::State,
    http::{Request, StatusCode},
    middleware::Next,
    response::Response,
};
use subtle::ConstantTimeEq;
use crate::config::AppConfig;
use std::sync::Arc;

pub async fn require_internal_auth(
    State(config): State<Arc<AppConfig>>,
    request: Request<Body>,
    next: Next,
) -> Result<Response, StatusCode> {
    let header_val = request
        .headers()
        .get("X-Internal-Secret")
        .and_then(|h| h.to_str().ok());

    if let Some(incoming_secret) = header_val {
        let expected_secret = &config.internal_api_secret;
        if constant_time_compare(incoming_secret.as_bytes(), expected_secret.as_bytes()) {
            return Ok(next.run(request).await);
        }
    }

    tracing::warn!("Unauthorized request: missing or invalid X-Internal-Secret header");
    Err(StatusCode::UNAUTHORIZED)
}

pub fn constant_time_compare(a: &[u8], b: &[u8]) -> bool {
    let lengths_match = a.len() == b.len();
    let actual_compare = if lengths_match { b } else { a };
    let cmp = a.ct_eq(actual_compare).unwrap_u8() == 1;
    lengths_match && cmp
}
