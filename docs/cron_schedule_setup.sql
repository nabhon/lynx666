-- ============================================================
-- Lynx666 - Cron Schedule for Lottery Draw Processing
-- ============================================================
-- This creates a cron job that triggers the Edge Function every 5 minutes
-- Run this in Supabase Dashboard > SQL Editor
-- ============================================================

-- Enable pg_cron extension (if not already enabled)
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- ============================================================
-- OPTION 1: Using pg_cron (Pro plan required)
-- ============================================================

-- Create cron job to run every 5 minutes
-- This calls your Edge Function at: https://kmndlsccudwqxtqnerlc.supabase.co/functions/v1/process-draw
SELECT cron.schedule(
  'process-lottery-draw',                    -- Job name (use this to unschedule later)
  '*/5 * * * *',                             -- Every 5 minutes
  $$
  SELECT net.http_post(
    url := '',
    headers := '{"Authorization": "Bearer YOUR_SERVICE_ROLE_KEY", "apikey": "YOUR_SERVICE_ROLE_KEY", "Content-Type": "application/json"}'::jsonb,
    body := '{}'::jsonb
  )
  $$
);

-- ✅ Verify the cron job was created
SELECT * FROM cron.job;

-- 📊 Check job execution logs
SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 10;

-- ❌ To unschedule (stop) the job later:
-- SELECT cron.unschedule('process-lottery-draw');


-- ============================================================
-- OPTION 2: Using Edge Function Schedules (Recommended - Free Tier)
-- ============================================================
-- This is the preferred method and works on ALL Supabase plans
-- 
-- Steps to set up via Dashboard:
-- 
-- 1. Go to Supabase Dashboard > Edge Functions
-- 2. Click on "process-draw" function
-- 3. Go to "Schedules" tab
-- 4. Click "Create Schedule"
-- 5. Enter:
--    - Name: process-lottery-draw
--    - Schedule: */5 * * * *  (every 5 minutes)
--                 OR
--                 0 */2 * * *  (every 2 hours - production)
--    - Timezone: UTC (or your preferred timezone)
-- 6. Click "Create"
--
-- Cron expressions:
--   */5 * * * *   = Every 5 minutes (testing)
--   0 */2 * * *   = Every 2 hours (production)
--   0 0 * * *     = Every day at midnight
--   0 0 * * 1     = Every Monday at midnight
-- ============================================================


-- ============================================================
-- OPTION 3: Using Supabase CLI
-- ============================================================
-- 
-- Deploy the Edge Function:
--   supabase functions deploy process-draw
-- 
-- Set up schedule via CLI:
--   supabase functions schedule process-draw --schedule "*/5 * * * *"
-- 
-- Test manually:
--   supabase functions invoke process-draw
-- 
-- View logs:
--   supabase functions logs process-draw
-- ============================================================


-- ============================================================
-- CRON EXPRESSION REFERENCE
-- ============================================================
-- 
-- Format: minute hour day-of-month month day-of-week
-- 
-- Examples:
--   */5 * * * *     = Every 5 minutes
--   */10 * * * *    = Every 10 minutes
--   0 * * * *       = Every hour at :00
--   0 */2 * * *     = Every 2 hours (00:00, 02:00, 04:00, ...)
--   0 */4 * * *     = Every 4 hours
--   0 0 * * *       = Daily at midnight
--   0 0 * * 1       = Every Monday at midnight
--   0 0 1 * *       = First day of every month
-- 
-- Your current setup: */5 * * * *
-- ┌───────────── minute (0-59, */5 = every 5 minutes)
-- │ ┌───────────── hour (0-23)
-- │ │ ┌───────────── day of month (1-31)
-- │ │ │ ┌───────────── month (1-12)
-- │ │ │ │ ┌───────────── day of week (0-6, Sunday=0)
-- │ │ │ │ │
-- * * * * *
-- ============================================================


-- ============================================================
-- SECURITY NOTES
-- ============================================================
-- 
-- 1. Replace YOUR_SERVICE_ROLE_KEY with your actual service role key
--    - Find it in: Supabase Dashboard > Project Settings > API
--    - DO NOT use the publishable/anon key for server-side operations
-- 
-- 2. The Edge Function uses SERVICE_ROLE_KEY internally,
--    so the cron job doesn't need to pass authorization.
--    You can simplify to:
-- 
--    SELECT cron.schedule(
--      'process-lottery-draw',
--      '*/5 * * * *',
--      $$
--      SELECT net.http_post(
--        url := 'https://kmndlsccudwqxtqnerlc.supabase.co/functions/v1/process-draw',
--        headers := '{"Content-Type": "application/json"}'::jsonb,
--        body := '{}'::jsonb
--      )
--      $$
--    );
-- 
-- 3. For production, consider using Edge Function Schedules (Option 2)
--    which handles authentication automatically.
-- ============================================================


-- ============================================================
-- TESTING & MONITORING
-- ============================================================
-- 
-- Check if cron extension is enabled:
--   SELECT * FROM pg_extension WHERE extname = 'pg_cron';
-- 
-- View all cron jobs:
--   SELECT * FROM cron.job;
-- 
-- View active jobs only:
--   SELECT jobid, schedule, command, active FROM cron.job WHERE active = true;
-- 
-- Count total jobs:
--   SELECT COUNT(*) as total_cron_jobs FROM cron.job;
-- 
-- Check recent execution history:
--   SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 10;
-- 
-- Test the Edge Function manually:
--   SELECT net.http_post(
--     url := 'https://kmndlsccudwqxtqnerlc.supabase.co/functions/v1/process-draw',
--     headers := '{"Content-Type": "application/json"}'::jsonb,
--     body := '{}'::jsonb
--   );
-- ============================================================
