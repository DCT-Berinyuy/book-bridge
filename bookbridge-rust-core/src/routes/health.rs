use axum::{response::IntoResponse, Json};
use serde_json::json;

pub async fn health_handler() -> impl IntoResponse {
    Json(json!({ "status": "ok" }))
}
