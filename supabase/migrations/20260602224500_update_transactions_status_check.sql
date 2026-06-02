-- Drop existing status check constraint
ALTER TABLE public.transactions DROP CONSTRAINT IF EXISTS transactions_status_check;

-- Add updated status check constraint supporting 'held' and 'disputed'
ALTER TABLE public.transactions ADD CONSTRAINT transactions_status_check
  CHECK (status IN ('pending', 'successful', 'failed', 'held', 'disputed'));
