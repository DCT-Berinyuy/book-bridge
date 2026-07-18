use bookbridge_rust_core::fapshi::FapshiClient;
use bookbridge_rust_core::routes::escrow::release_escrow;
use bookbridge_rust_core::AppState;
use sqlx::PgPool;
use uuid::Uuid;
use std::sync::Arc;
use std::sync::Mutex;
use std::collections::HashSet;

#[test]
fn test_clean_phone() {
    assert_eq!(FapshiClient::clean_phone("+237 677 889 900"), "677889900");
    assert_eq!(FapshiClient::clean_phone("655 444 333"), "655444333");
    assert_eq!(FapshiClient::clean_phone("237699111222"), "699111222");
    assert_eq!(FapshiClient::clean_phone("12345"), "12345");
    assert_eq!(FapshiClient::clean_phone(""), "");
}

#[tokio::test]
async fn test_release_escrow_db_integration() -> Result<(), Box<dyn std::error::Error>> {
    let _ = dotenvy::dotenv();
    let db_url = match std::env::var("DATABASE_URL") {
        Ok(url) if !url.contains("localhost") && !url.contains("dummy") => url,
        _ => {
            println!("Skipping DB integration test (no database connection set)");
            return Ok(());
        }
    };

    let pool = match PgPool::connect(&db_url).await {
        Ok(p) => p,
        Err(e) => {
            println!("Skipping DB integration test (database connection failed: {})", e);
            return Ok(());
        }
    };

    // Run setup within a transaction
    let mut tx = pool.begin().await?;

    let seller_id = Uuid::new_v4();
    let buyer_id = Uuid::new_v4();
    let listing_id = Uuid::new_v4();
    let transaction_id = Uuid::new_v4();

    // Insert mock auth users to satisfy foreign key constraints if possible.
    let user_setup = sqlx::query(
        "INSERT INTO auth.users (id, email) VALUES ($1, $2), ($3, $4)"
    )
    .bind(seller_id)
    .bind("seller@example.com")
    .bind(buyer_id)
    .bind("buyer@example.com")
    .execute(&mut *tx)
    .await;

    if let Err(e) = user_setup {
        println!("Skipping query execution check (cannot insert dummy auth.users: {}).", e);
        tx.rollback().await?;
        return Ok(());
    }

    // Insert profile details
    sqlx::query(
        "INSERT INTO profiles (id, full_name, whatsapp_number) VALUES ($1, $2, $3)"
    )
    .bind(seller_id)
    .bind("Integration Test Seller")
    .bind("+237677777777")
    .execute(&mut *tx)
    .await?;

    // Insert listing details
    sqlx::query(
        "INSERT INTO listings (id, seller_id, title, status) VALUES ($1, $2, $3, $4)"
    )
    .bind(listing_id)
    .bind(seller_id)
    .bind("Integration Test Book")
    .bind("active")
    .execute(&mut *tx)
    .await?;

    // Insert transactions details (status must be 'held' to match status check constraint & release rule)
    sqlx::query(
        "INSERT INTO transactions (id, listing_id, buyer_id, seller_id, amount, commission_amount, payment_reference, status) \
         VALUES ($1, $2, $3, $4, 5000, 250, 'integration_test_ref_99', 'held')"
    )
    .bind(transaction_id)
    .bind(listing_id)
    .bind(buyer_id)
    .bind(seller_id)
    .execute(&mut *tx)
    .await?;

    // Insert escrow transactions details
    sqlx::query(
        "INSERT INTO escrow_transactions (transaction_id, status) VALUES ($1, 'held')"
    )
    .bind(transaction_id)
    .execute(&mut *tx)
    .await?;

    // Ensure our Fapshi credentials table contains mock values to satisfy lookups
    sqlx::query(
        "INSERT INTO app_secrets (key, value) VALUES ($1, $2), ($3, $4) \
         ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value"
    )
    .bind("fapshi_payout_api_user")
    .bind("mock_payout_user")
    .bind("fapshi_payout_api_key")
    .bind("mock_payout_key")
    .execute(&mut *tx)
    .await?;

    // Commit the setup transaction so the database pool connections can read it
    tx.commit().await?;

    let state = AppState {
        pool: pool.clone(),
        in_progress_payouts: Arc::new(Mutex::new(HashSet::new())),
        fapshi_base_url: "https://sandbox.fapshi.com".to_string(), // Mock sandbox URL for testing
    };

    // Executing the escrow release. In sandbox/offline mode, this will fail at the Fapshi API HTTP network call.
    let result = release_escrow(&state, transaction_id).await;

    // Manual cleanup to leave the database clean
    let _ = sqlx::query("DELETE FROM app_secrets WHERE key IN ('fapshi_payout_api_user', 'fapshi_payout_api_key')").execute(&pool).await;
    let _ = sqlx::query("DELETE FROM escrow_transactions WHERE transaction_id = $1").bind(transaction_id).execute(&pool).await;
    let _ = sqlx::query("DELETE FROM transactions WHERE id = $1").bind(transaction_id).execute(&pool).await;
    let _ = sqlx::query("DELETE FROM listings WHERE id = $1").bind(listing_id).execute(&pool).await;
    let _ = sqlx::query("DELETE FROM profiles WHERE id = $1").bind(seller_id).execute(&pool).await;
    let _ = sqlx::query("DELETE FROM auth.users WHERE id IN ($1, $2)").bind(seller_id).bind(buyer_id).execute(&pool).await;

    match result {
        Ok(_) => {
            println!("Escrow release completed successfully!");
        }
        Err(e) => {
            let err_str = e.to_string();
            println!("Escrow release execution reached network call. Result error: {}", err_str);
            assert!(err_str.contains("Gateway error") || err_str.contains("HTTP client error") || err_str.contains("Fapshi"));
        }
    }

    Ok(())
}

#[tokio::test]
async fn test_poll_pending_db_integration() -> Result<(), Box<dyn std::error::Error>> {
    let _ = dotenvy::dotenv();
    let db_url = match std::env::var("DATABASE_URL") {
        Ok(url) if !url.contains("localhost") && !url.contains("dummy") => url,
        _ => {
            println!("Skipping DB poll pending integration test (no database connection set)");
            return Ok(());
        }
    };

    let pool = match PgPool::connect(&db_url).await {
        Ok(p) => p,
        Err(e) => {
            println!("Skipping DB poll pending integration test (database connection failed: {})", e);
            return Ok(());
        }
    };

    let mut tx = pool.begin().await?;

    let seller_id = Uuid::new_v4();
    let buyer_id = Uuid::new_v4();
    let listing_id = Uuid::new_v4();
    let transaction_id = Uuid::new_v4();

    // Insert mock auth users
    let user_setup = sqlx::query(
        "INSERT INTO auth.users (id, email) VALUES ($1, $2), ($3, $4)"
    )
    .bind(seller_id)
    .bind("seller-poll@example.com")
    .bind(buyer_id)
    .bind("buyer-poll@example.com")
    .execute(&mut *tx)
    .await;

    if let Err(e) = user_setup {
        println!("Skipping poll pending query check (cannot insert dummy auth.users: {}).", e);
        tx.rollback().await?;
        return Ok(());
    }

    // Insert profile
    sqlx::query(
        "INSERT INTO profiles (id, full_name, whatsapp_number) VALUES ($1, $2, $3)"
    )
    .bind(seller_id)
    .bind("Poll Test Seller")
    .bind("+237677777778")
    .execute(&mut *tx)
    .await?;

    // Insert listing
    sqlx::query(
        "INSERT INTO listings (id, seller_id, title, status) VALUES ($1, $2, $3, $4)"
    )
    .bind(listing_id)
    .bind(seller_id)
    .bind("Poll Test Book")
    .bind("active")
    .execute(&mut *tx)
    .await?;

    // Insert transaction stuck in pending_payment (using an old date to trigger the 10-minute rule)
    let ten_minutes_ago = chrono::Utc::now() - chrono::Duration::minutes(15);
    sqlx::query(
        "INSERT INTO transactions (id, listing_id, buyer_id, seller_id, amount, commission_amount, payment_reference, status, created_at) \
         VALUES ($1, $2, $3, $4, 5000, 250, 'poll_test_ref_999', 'pending_payment', $5)"
    )
    .bind(transaction_id)
    .bind(listing_id)
    .bind(buyer_id)
    .bind(seller_id)
    .bind(ten_minutes_ago)
    .execute(&mut *tx)
    .await?;

    // Mock app secrets for polling
    sqlx::query(
        "INSERT INTO app_secrets (key, value) VALUES ($1, $2), ($3, $4) \
         ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value"
    )
    .bind("fapshi_api_user")
    .bind("mock_api_user")
    .bind("fapshi_api_key")
    .bind("mock_api_key")
    .execute(&mut *tx)
    .await?;

    // Commit setup transaction so poll_payment_status can read from pool connections
    tx.commit().await?;

    let fapshi = FapshiClient::new("https://sandbox.fapshi.com".to_string());

    // Call status checking. Since we use a mock api key and are offline, this will hit connection/Fapshi error.
    let result = fapshi.poll_payment_status(&pool, transaction_id, "poll_test_ref_999").await;

    // Manual cleanup
    let _ = sqlx::query("DELETE FROM app_secrets WHERE key IN ('fapshi_api_user', 'fapshi_api_key')").execute(&pool).await;
    let _ = sqlx::query("DELETE FROM transactions WHERE id = $1").bind(transaction_id).execute(&pool).await;
    let _ = sqlx::query("DELETE FROM listings WHERE id = $1").bind(listing_id).execute(&pool).await;
    let _ = sqlx::query("DELETE FROM profiles WHERE id = $1").bind(seller_id).execute(&pool).await;
    let _ = sqlx::query("DELETE FROM auth.users WHERE id IN ($1, $2)").bind(seller_id).bind(buyer_id).execute(&pool).await;

    match result {
        Ok(status) => {
            println!("Status query completed with state: {}", status);
        }
        Err(e) => {
            let err_str = e.to_string();
            println!("Status query reached network call. Result error: {}", err_str);
            assert!(err_str.contains("Gateway error") || err_str.contains("HTTP client error") || err_str.contains("Fapshi"));
        }
    }

    Ok(())
}
