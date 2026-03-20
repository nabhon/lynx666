# Lynx666 Backend Setup Guide

## Automated Lottery Draw System

This guide explains how to set up the automated 2-hour lottery draw system.

---

## Overview

The system uses:
1. **Supabase Database** - Stores all data (profiles, draws, bets, prizes)
2. **Database Functions** - Process draws and distribute prizes
3. **Edge Function** - Triggers draw processing automatically
4. **Cron Schedule** - Runs every 2 hours

---

## Step 1: Run Database Migration

### Option A: Via Supabase Dashboard (Recommended)

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor** (left sidebar)
3. Click **New Query**
4. Copy the entire content of `supabase/migrations/001_initial_schema.sql`
5. Paste into the SQL Editor
6. Click **Run** (or press Ctrl+Enter)
7. Verify success - you should see "Success. No rows returned"

### Option B: Via Supabase CLI

```bash
# Install Supabase CLI if not already installed
npm install -g supabase

# Login to Supabase
supabase login

# Link to your project (get project ref from dashboard URL)
supabase link --project-ref YOUR_PROJECT_REF

# Push migrations
supabase db push
```

---

## Step 2: Deploy Edge Function

### Install Supabase CLI (if not installed)

```bash
npm install -g supabase
```

### Login and Link

```bash
# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref YOUR_PROJECT_REF
```

### Deploy the Function

```bash
# Deploy the process-draw function
supabase functions deploy process-draw
```

### Set Environment Variables

The function needs the service role key. Set it in Supabase Dashboard:

1. Go to **Project Settings** > **Edge Functions**
2. Click **Add new secret**
3. Key: `SUPABASE_SERVICE_ROLE_KEY`
4. Value: Get from **Project Settings** > **API** > `service_role` key (NOT anon key!)
5. Click **Save**

---

## Step 3: Set Up Cron Schedule

### Via Supabase Dashboard (Recommended)

1. Go to **Edge Functions** in Supabase Dashboard
2. Find `process-draw` in the list
3. Click on it
4. Go to **Schedules** tab
5. Click **Create Schedule**
6. Configure:
   - **Schedule**: `0 */2 * * *` (every 2 hours)
   - **Timezone**: UTC (or your preferred timezone)
7. Click **Create**

### Via CLI (Alternative)

```bash
supabase functions schedule process-draw --schedule "0 */2 * * *"
```

### Cron Expression Explained

```
0 */2 * * *
│  │  │ │ │
│  │  │ │ └── Day of week (0-7, Sunday=0 or 7)
│  │  │ └──── Month (1-12)
│  │  └────── Day of month (1-31)
│  └───────── Hour (0-23, */2 = every 2 hours)
└─────────── Minute (0-59, 0 = at start of hour)
```

This runs at: `00:00`, `02:00`, `04:00`, `06:00`, etc.

---

## Step 4: Verify Setup

### Check Database Tables

In Supabase Dashboard > **Table Editor**, verify these tables exist:
- [ ] profiles
- [ ] game_configs
- [ ] lottery_draws
- [ ] bets
- [ ] prize_distributions
- [ ] friends

### Check Game Configs

In Table Editor > `game_configs`, verify these rows exist:
- [ ] `draw_interval` = `{"hours": 2}`
- [ ] `prize_multipliers` = (JSON with all criteria)
- [ ] `bet_limits` = `{"min": 1, "max_percentage": 0.5}`

### Check Functions

In Supabase Dashboard > **SQL Editor**, run:

```sql
-- Test get_next_draw_time
SELECT get_next_draw_time(NOW());

-- Test get_prize_multiplier
SELECT get_prize_multiplier('MATCH_6'::win_criteria);
```

### Check Initial Draw

```sql
-- Should return 1 pending draw
SELECT * FROM lottery_draws WHERE status = 'PENDING';
```

### Test Edge Function Manually

```bash
# Test the function (should say "No pending draws" if none overdue)
supabase functions invoke process-draw
```

---

## Step 5: Create First Draw (If Not Auto-Created)

The migration should auto-create the first draw. Verify:

```sql
SELECT id, scheduled_time, status FROM lottery_draws ORDER BY created_at DESC LIMIT 1;
```

If empty, create manually:

```sql
-- Create first pending draw
INSERT INTO lottery_draws (scheduled_time, status)
VALUES (get_next_draw_time(NOW()), 'PENDING');
```

---

## How It Works

### Draw Flow

1. **User places bets** → Stored in `bets` table with status `PENDING`
2. **Every 2 hours**, cron triggers `process-draw` Edge Function
3. **Edge Function** calls `process_lottery_draw(draw_id)` database function
4. **Database function**:
   - Generates 6 random winning numbers (0-9)
   - Processes all pending bets for that draw
   - Determines winners using `determine_win_criteria()`
   - Calculates prizes using `get_prize_multiplier()`
   - Updates user balances
   - Logs prize distributions
   - Marks draw as `COMPLETED`
   - Creates next scheduled draw
5. **Users see results** in their bet history and updated balances

### Win Criteria Matching

```
MATCH_6        → All 6 numbers match (any order)
MATCH_5        → 5 numbers match (any order)
MATCH_4        → 4 numbers match (any order)
MATCH_3_FRONT  → First 3 numbers match IN EXACT POSITIONS
MATCH_3_BACK   → Last 3 numbers match IN EXACT POSITIONS
MATCH_2_FRONT  → First 2 numbers match IN EXACT POSITIONS
MATCH_2_BACK   → Last 2 numbers match IN EXACT POSITIONS
```

---

## Monitoring

### Check Draw History

```sql
SELECT
  draw_number,
  winning_numbers,
  scheduled_time,
  completed_at,
  status,
  total_bets_count,
  total_prize_pool
FROM lottery_draws
ORDER BY scheduled_time DESC
LIMIT 10;
```

### Check Recent Winners

```sql
SELECT
  ld.draw_number,
  p.username,
  b.selected_numbers,
  bd.win_criteria,
  bd.prize_amount,
  bd.created_at
FROM prize_distributions bd
JOIN lottery_draws ld ON bd.lottery_draw_id = ld.id
JOIN profiles p ON bd.user_id = p.id
ORDER BY bd.created_at DESC
LIMIT 20;
```

### Check Pending Bets

```sql
SELECT COUNT(*) FROM bets WHERE status = 'PENDING';
```

### Check Function Logs

In Supabase Dashboard > **Edge Functions** > `process-draw` > **Logs**

---

## Troubleshooting

### Edge Function Fails

**Error: "Function not found"**
```bash
# Redeploy
supabase functions deploy process-draw
```

**Error: "Missing SUPABASE_SERVICE_ROLE_KEY"**
- Go to Project Settings > Edge Functions
- Add the secret as described in Step 2

**Error: "Draw already processed"**
- This is normal if function runs twice for same draw
- Check logs to see which draw ID caused error

### No Draws Being Created

Check if `initialize_draw_schedule()` ran:
```sql
SELECT * FROM lottery_draws;
```

If empty, run manually:
```sql
SELECT initialize_draw_schedule();
```

### Bets Not Being Settled

Check if bets are linked to correct draw:
```sql
SELECT
  b.id,
  b.lottery_draw_id,
  ld.scheduled_time,
  ld.status
FROM bets b
JOIN lottery_draws ld ON b.lottery_draw_id = ld.id
WHERE b.status = 'PENDING';
```

---

## Manual Draw Processing (Emergency)

If automated system fails, process manually:

```sql
-- Get overdue pending draws
SELECT id, scheduled_time FROM lottery_draws
WHERE status = 'PENDING' AND scheduled_time <= NOW();

-- Process specific draw
SELECT process_lottery_draw('DRAW_UUID_HERE');

-- Or process all overdue draws (in SQL Editor or psql)
DO $$
DECLARE
  draw_record RECORD;
BEGIN
  FOR draw_record IN
    SELECT id FROM lottery_draws
    WHERE status = 'PENDING' AND scheduled_time <= NOW()
  LOOP
    PERFORM process_lottery_draw(draw_record.id);
  END LOOP;
END $$;
```

---

## Cost Estimation

### Supabase Free Tier
- **Edge Functions**: 500,000 invocations/month
- **Database**: 500MB storage, 50,000 row reads/month

### Your Usage (Every 2 Hours)
- **Function calls**: 12/day × 30 = 360/month ✅ Well within free tier
- **Database**: Depends on user base, but should be fine for small-medium scale

---

## Next Steps

1. ✅ Run migration (Step 1)
2. ✅ Deploy Edge Function (Step 2)
3. ✅ Set up cron schedule (Step 3)
4. ✅ Verify setup (Step 4)
5. 🎯 Test with a real bet in your Flutter app!

---

## Support

- **Supabase Docs**: https://supabase.com/docs
- **Edge Functions**: https://supabase.com/docs/guides/functions
- **Cron Schedules**: https://supabase.com/docs/guides/functions/schedules
