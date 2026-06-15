-- ============================================================
-- Fintech Architecture Fixes
-- Migration: 20260611180000_fintech_architecture_fixes.sql
-- ============================================================

-- 1. Extend Auto-Release from 48h to 5 days
-- First, drop the generated column that depends on add_48_hours
ALTER TABLE public.escrow_transactions DROP COLUMN IF EXISTS release_deadline;

-- Drop the old helper function
DROP FUNCTION IF EXISTS public.add_48_hours(TIMESTAMPTZ);

-- Create new helper function for 5 days
CREATE OR REPLACE FUNCTION public.add_5_days(t TIMESTAMPTZ)
RETURNS TIMESTAMPTZ
LANGUAGE SQL IMMUTABLE AS $$
  SELECT t + INTERVAL '5 days';
$$;

-- Re-add release_deadline column with 5 days calculation
ALTER TABLE public.escrow_transactions
ADD COLUMN release_deadline TIMESTAMP WITH TIME ZONE
GENERATED ALWAYS AS (public.add_5_days(created_at)) STORED;

-- 2. Update status check constraint on transactions table
ALTER TABLE public.transactions DROP CONSTRAINT IF EXISTS transactions_status_check;
ALTER TABLE public.transactions ADD CONSTRAINT transactions_status_check
  CHECK (status IN ('pending', 'pending_payment', 'successful', 'failed', 'held', 'disputed'));

-- 3. Create fapshi_audit_logs table
CREATE TABLE IF NOT EXISTS public.fapshi_audit_logs (
  id               UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  transaction_id   UUID REFERENCES public.transactions(id) ON DELETE SET NULL,
  endpoint         TEXT NOT NULL,
  request_payload  JSONB,
  response_payload JSONB,
  status_code      INTEGER,
  created_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS for the audit logs
ALTER TABLE public.fapshi_audit_logs ENABLE ROW LEVEL SECURITY;

-- 4. Store Project URL as Vault Secret
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM vault.decrypted_secrets WHERE name = 'app.supabase_url') THEN
    PERFORM vault.create_secret('https://jacnsvcwmhoicuuzmrmr.supabase.co', 'app.supabase_url', 'Supabase Project URL');
  END IF;
END $$;

-- 5. Re-schedule auto-release-escrows-job (using net.http_post & vault secret)
SELECT cron.unschedule('auto-release-escrows-job') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'auto-release-escrows-job'
);

SELECT cron.schedule(
  'auto-release-escrows-job',
  '0 * * * *',
  $$
  SELECT net.http_post(
    url     := (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'app.supabase_url' LIMIT 1) || '/functions/v1/process-escrow',
    headers := jsonb_build_object(
      'Content-Type',   'application/json',
      'x-cron-secret',  (SELECT value FROM public.app_secrets WHERE key = 'broadcast_secret' LIMIT 1)
    ),
    body    := '{"action":"auto-release-expired"}'::jsonb
  );
  $$
);

-- 6. Schedule new fapshi-polling-job (every 5 minutes)
SELECT cron.unschedule('fapshi-polling-job') WHERE EXISTS (
  SELECT 1 FROM cron.job WHERE jobname = 'fapshi-polling-job'
);

SELECT cron.schedule(
  'fapshi-polling-job',
  '*/5 * * * *',
  $$
  SELECT net.http_post(
    url     := (SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'app.supabase_url' LIMIT 1) || '/functions/v1/fapshi-polling',
    headers := jsonb_build_object(
      'Content-Type',   'application/json',
      'x-cron-secret',  (SELECT value FROM public.app_secrets WHERE key = 'broadcast_secret' LIMIT 1)
    ),
    body    := '{}'::jsonb
  );
  $$
);
