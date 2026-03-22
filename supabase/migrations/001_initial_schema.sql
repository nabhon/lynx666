-- Migration: 001_initial_schema.sql
-- Lynx666 Lottery - Complete Database Setup with Automation

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing objects if they exist (for clean migration)
DROP VIEW IF EXISTS friend_requests_view CASCADE;
DROP VIEW IF EXISTS friends_leaderboard_view CASCADE;
DROP VIEW IF EXISTS friend_list_view CASCADE;
DROP VIEW IF EXISTS user_stats_view CASCADE;
DROP VIEW IF EXISTS leaderboard_view CASCADE;
DROP VIEW IF EXISTS bet_history_view CASCADE;
DROP FUNCTION IF EXISTS process_lottery_draw(UUID) CASCADE;
DROP FUNCTION IF EXISTS get_prize_multiplier(win_criteria) CASCADE;
DROP FUNCTION IF EXISTS get_next_draw_time(TIMESTAMP WITH TIME ZONE) CASCADE;
DROP TABLE IF EXISTS friends CASCADE;
DROP TABLE IF EXISTS prize_distributions CASCADE;
DROP TABLE IF EXISTS bets CASCADE;
DROP TABLE IF EXISTS lottery_draws CASCADE;
DROP TABLE IF EXISTS game_configs CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;
DROP TYPE IF EXISTS win_criteria CASCADE;
DROP TYPE IF EXISTS draw_status CASCADE;
DROP TYPE IF EXISTS bet_status CASCADE;
DROP TYPE IF EXISTS profile_status CASCADE;

-- Enum types
CREATE TYPE profile_status AS ENUM ('ACTIVE', 'INACTIVE', 'BANNED');
CREATE TYPE bet_status AS ENUM ('PENDING', 'WON', 'LOST');
CREATE TYPE draw_status AS ENUM ('PENDING', 'COMPLETED', 'CANCELLED');
CREATE TYPE win_criteria AS ENUM (
  'MATCH_6',        -- Match all 6 numbers (Jackpot)
  'MATCH_5',        -- Match 5 numbers
  'MATCH_4',        -- Match 4 numbers
  'MATCH_3_FRONT',  -- Match first 3 numbers
  'MATCH_3_BACK',   -- Match last 3 numbers
  'MATCH_2_FRONT',  -- Match first 2 numbers
  'MATCH_2_BACK'    -- Match last 2 numbers
);

-- Users table (extends Supabase Auth)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT NOT NULL,
  username TEXT UNIQUE,
  avatar_key TEXT,
  balance NUMERIC(30, 2) DEFAULT 0,
  status profile_status DEFAULT 'ACTIVE',
  is_onboarding_complete BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_profiles_active ON profiles(id) WHERE deleted_at IS NULL AND status = 'ACTIVE';

-- Game configuration
CREATE TABLE game_configs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  config_key TEXT UNIQUE NOT NULL,
  config_value JSONB NOT NULL,
  description TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default configs
INSERT INTO game_configs (config_key, config_value, description) VALUES
  ('draw_interval', '{"hours": 2}'::jsonb, 'Draw every 2 hours'),
  ('prize_multipliers', '{
    "MATCH_6": 1000000,
    "MATCH_5": 100000,
    "MATCH_4": 10000,
    "MATCH_3_FRONT": 1000,
    "MATCH_3_BACK": 1000,
    "MATCH_2_FRONT": 100,
    "MATCH_2_BACK": 100
  }'::jsonb, 'Prize multipliers for each criteria'),
  ('bet_limits', '{"min": 1, "max_percentage": 0.5}'::jsonb, 'Min bet and max % of balance');

-- Lottery draws
CREATE TABLE lottery_draws (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  draw_number SERIAL NOT NULL,
  winning_numbers INTEGER[6],
  scheduled_time TIMESTAMP WITH TIME ZONE NOT NULL,
  draw_time TIMESTAMP WITH TIME ZONE,
  status draw_status DEFAULT 'PENDING',
  previous_draw_id UUID REFERENCES lottery_draws(id),
  next_draw_id UUID REFERENCES lottery_draws(id),
  total_bets_count INTEGER DEFAULT 0,
  total_prize_pool NUMERIC(30, 2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_lottery_draws_scheduled ON lottery_draws(scheduled_time);
CREATE INDEX idx_lottery_draws_status ON lottery_draws(status);

-- Bets
CREATE TABLE bets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  lottery_draw_id UUID REFERENCES lottery_draws(id) ON DELETE CASCADE,
  selected_numbers INTEGER[6] NOT NULL,
  bet_amount NUMERIC(30, 2) NOT NULL,
  status bet_status DEFAULT 'PENDING',
  potential_win_amount NUMERIC(30, 2),
  actual_win_amount NUMERIC(30, 2),
  win_criteria win_criteria,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  settled_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_bets_user ON bets(user_id);
CREATE INDEX idx_bets_draw ON bets(lottery_draw_id);
CREATE INDEX idx_bets_status ON bets(status);
CREATE INDEX idx_bets_user_status ON bets(user_id, status);

-- Prize distribution log
CREATE TABLE prize_distributions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  lottery_draw_id UUID REFERENCES lottery_draws(id) ON DELETE CASCADE,
  bet_id UUID REFERENCES bets(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  win_criteria win_criteria NOT NULL,
  matched_numbers INTEGER[],
  prize_amount NUMERIC(30, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_prize_dist_user ON prize_distributions(user_id);
CREATE INDEX idx_prize_dist_draw ON prize_distributions(lottery_draw_id);

-- Friends
CREATE TABLE friends (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  friend_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, friend_id),
  CHECK (user_id != friend_id)
);

CREATE INDEX idx_friends_user ON friends(user_id);
CREATE INDEX idx_friends_friend ON friends(friend_id);
CREATE INDEX idx_friends_status ON friends(status);

-- ============ VIEWS ============

-- Bet history view
CREATE VIEW bet_history_view AS
SELECT
  b.id,
  b.user_id,
  b.lottery_draw_id,
  ld.draw_number,
  ld.winning_numbers,
  ld.scheduled_time,
  ld.draw_time,
  ld.status as draw_status,
  b.selected_numbers,
  b.bet_amount,
  b.status as bet_status,
  b.potential_win_amount,
  b.actual_win_amount,
  b.win_criteria,
  b.created_at as bet_placed_at,
  b.settled_at
FROM bets b
LEFT JOIN lottery_draws ld ON b.lottery_draw_id = ld.id
ORDER BY b.created_at DESC;

-- Leaderboard view
CREATE VIEW leaderboard_view AS
SELECT
  p.id,
  p.username,
  p.avatar_key,
  p.balance,
  COUNT(DISTINCT pd.id) as total_wins,
  COALESCE(SUM(pd.prize_amount), 0) as lifetime_winnings,
  ROW_NUMBER() OVER (ORDER BY p.balance DESC) as rank
FROM profiles p
LEFT JOIN prize_distributions pd ON p.id = pd.user_id
WHERE p.deleted_at IS NULL
  AND p.status = 'ACTIVE'
GROUP BY p.id, p.username, p.avatar_key, p.balance
ORDER BY p.balance DESC;

-- User statistics view
CREATE VIEW user_stats_view AS
SELECT
  p.id,
  p.username,
  p.balance,
  COUNT(DISTINCT b.id) as total_bets,
  COUNT(DISTINCT CASE WHEN b.status = 'WON' THEN b.id END) as winning_bets,
  COUNT(DISTINCT CASE WHEN b.status = 'LOST' THEN b.id END) as losing_bets,
  COALESCE(SUM(b.bet_amount), 0) as total_spent,
  COALESCE(SUM(pd.prize_amount), 0) as total_won,
  COALESCE(SUM(pd.prize_amount), 0) - COALESCE(SUM(b.bet_amount), 0) as net_profit
FROM profiles p
LEFT JOIN bets b ON p.id = b.user_id
LEFT JOIN prize_distributions pd ON p.id = pd.user_id
WHERE p.deleted_at IS NULL AND p.status = 'ACTIVE'
GROUP BY p.id, p.username, p.balance;

-- Friend list view
CREATE VIEW friend_list_view AS
SELECT
  f.id as friendship_id,
  f.user_id,
  f.friend_id,
  p.username,
  p.avatar_key,
  p.balance,
  p.status as friend_status,
  f.created_at as friends_since,
  COUNT(DISTINCT pd.id) as total_wins,
  COALESCE(SUM(pd.prize_amount), 0) as lifetime_winnings
FROM friends f
JOIN profiles p ON f.friend_id = p.id
LEFT JOIN prize_distributions pd ON p.id = pd.user_id
WHERE f.status = 'accepted'
  AND p.deleted_at IS NULL
  AND p.status = 'ACTIVE'
GROUP BY f.id, f.user_id, f.friend_id, p.username, p.avatar_key,
         p.balance, p.status, f.created_at;

-- Friends leaderboard view
CREATE VIEW friends_leaderboard_view AS
SELECT
  f.user_id,
  f.friend_id,
  p.username,
  p.avatar_key,
  p.balance,
  COUNT(DISTINCT pd.id) as total_wins,
  COALESCE(SUM(pd.prize_amount), 0) as lifetime_winnings,
  ROW_NUMBER() OVER (ORDER BY p.balance DESC) as friend_rank
FROM friends f
JOIN profiles p ON f.friend_id = p.id
LEFT JOIN prize_distributions pd ON p.id = pd.user_id
WHERE f.status = 'accepted'
  AND p.deleted_at IS NULL
  AND p.status = 'ACTIVE'
GROUP BY f.user_id, f.friend_id, p.username, p.avatar_key, p.balance
ORDER BY p.balance DESC;

-- Friend requests view
CREATE VIEW friend_requests_view AS
SELECT
  f.id as request_id,
  f.user_id as sender_id,
  f.friend_id as receiver_id,
  p.username as sender_username,
  p.avatar_key as sender_avatar,
  f.created_at as request_date
FROM friends f
JOIN profiles p ON f.user_id = p.id
WHERE f.status = 'pending'
  AND p.deleted_at IS NULL
  AND p.status = 'ACTIVE';

-- ============ HELPER FUNCTIONS ============
-- Note: All local variables use 'v_' prefix to avoid ambiguity with column names

-- Function: Calculate next draw time based on config
CREATE OR REPLACE FUNCTION get_next_draw_time(now_time TIMESTAMP WITH TIME ZONE)
RETURNS TIMESTAMP WITH TIME ZONE AS $$
DECLARE
  interval_hours INTEGER;
  epoch_seconds NUMERIC;
  next_interval NUMERIC;
BEGIN
  SELECT (config_value->>'hours')::INTEGER INTO interval_hours
  FROM game_configs
  WHERE config_key = 'draw_interval';

  -- Calculate seconds since epoch
  epoch_seconds := EXTRACT(EPOCH FROM now_time);
  
  -- Round up to next interval boundary
  next_interval := CEIL(epoch_seconds / (interval_hours * 3600)) * (interval_hours * 3600);
  
  -- Convert back to timestamp
  RETURN TIMESTAMP WITH TIME ZONE 'epoch' + (next_interval * INTERVAL '1 second');
END;
$$ LANGUAGE plpgsql;

-- Function: Get prize multiplier for criteria
CREATE OR REPLACE FUNCTION get_prize_multiplier(criteria win_criteria)
RETURNS NUMERIC AS $$
DECLARE
  multiplier NUMERIC;
BEGIN
  SELECT (config_value->>criteria::TEXT)::NUMERIC INTO multiplier
  FROM game_configs
  WHERE config_key = 'prize_multipliers';

  RETURN COALESCE(multiplier, 0);
END;
$$ LANGUAGE plpgsql;

-- Function: Count matching numbers (exact position match)
CREATE OR REPLACE FUNCTION count_matches(
  selected INTEGER[],
  winning INTEGER[]
)
RETURNS INTEGER AS $$
DECLARE
  i INTEGER;
  matches INTEGER := 0;
BEGIN
  FOR i IN 1..array_length(selected, 1) LOOP
    IF selected[i] = winning[i] THEN
      matches := matches + 1;
    END IF;
  END LOOP;
  RETURN matches;
END;
$$ LANGUAGE plpgsql;

-- Function: Check front match (first N numbers in exact positions)
CREATE OR REPLACE FUNCTION check_front_match(
  selected INTEGER[],
  winning INTEGER[],
  match_count INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
  i INTEGER;
BEGIN
  FOR i IN 0..(match_count - 1) LOOP
    IF selected[i + 1] != winning[i + 1] THEN
      RETURN FALSE;
    END IF;
  END LOOP;
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function: Check back match (last N numbers in exact positions)
CREATE OR REPLACE FUNCTION check_back_match(
  selected INTEGER[],
  winning INTEGER[],
  match_count INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
  i INTEGER;
  arr_length INTEGER;
BEGIN
  arr_length := array_length(selected, 1);
  FOR i IN 0..(match_count - 1) LOOP
    IF selected[arr_length - match_count + i + 1] != winning[arr_length - match_count + i + 1] THEN
      RETURN FALSE;
    END IF;
  END LOOP;
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function: Determine win criteria from matches
CREATE OR REPLACE FUNCTION determine_win_criteria(
  selected INTEGER[],
  winning INTEGER[]
)
RETURNS win_criteria AS $$
DECLARE
  total_matches INTEGER;
BEGIN
  total_matches := count_matches(selected, winning);

  -- Check MATCH_6 (Jackpot)
  IF total_matches = 6 THEN
    RETURN 'MATCH_6';
  END IF;

  -- Check MATCH_5
  IF total_matches = 5 THEN
    RETURN 'MATCH_5';
  END IF;

  -- Check MATCH_4
  IF total_matches = 4 THEN
    RETURN 'MATCH_4';
  END IF;

  -- Check MATCH_3_FRONT (first 3 in exact positions)
  IF check_front_match(selected, winning, 3) THEN
    RETURN 'MATCH_3_FRONT';
  END IF;

  -- Check MATCH_3_BACK (last 3 in exact positions)
  IF check_back_match(selected, winning, 3) THEN
    RETURN 'MATCH_3_BACK';
  END IF;

  -- Check MATCH_2_FRONT
  IF check_front_match(selected, winning, 2) THEN
    RETURN 'MATCH_2_FRONT';
  END IF;

  -- Check MATCH_2_BACK
  IF check_back_match(selected, winning, 2) THEN
    RETURN 'MATCH_2_BACK';
  END IF;

  RETURN NULL; -- No win
END;
$$ LANGUAGE plpgsql;

-- ============ MAIN DRAW PROCESSING FUNCTION ============

-- Function: Process lottery draw and distribute prizes
CREATE OR REPLACE FUNCTION process_lottery_draw(draw_id UUID)
RETURNS JSON AS $$
DECLARE
  draw_record RECORD;
  bet_record RECORD;
  prize_amount NUMERIC;
  win_crit win_criteria;
  matched_numbers INTEGER[];
  v_total_processed INTEGER := 0;
  v_total_winners INTEGER := 0;
  v_total_prize_pool NUMERIC(30, 2) := 0;
  result JSON;
BEGIN
  -- Get draw info
  SELECT * INTO draw_record FROM lottery_draws WHERE id = draw_id;

  IF draw_record IS NULL THEN
    RAISE EXCEPTION 'Draw not found: %', draw_id;
  END IF;

  IF draw_record.status != 'PENDING' THEN
    RAISE EXCEPTION 'Draw already processed (status: %)', draw_record.status;
  END IF;

  -- Generate winning numbers if not already set (random 6 digits 0-9)
  IF draw_record.winning_numbers IS NULL THEN
    draw_record.winning_numbers := ARRAY[
      FLOOR(RANDOM() * 10)::INTEGER,
      FLOOR(RANDOM() * 10)::INTEGER,
      FLOOR(RANDOM() * 10)::INTEGER,
      FLOOR(RANDOM() * 10)::INTEGER,
      FLOOR(RANDOM() * 10)::INTEGER,
      FLOOR(RANDOM() * 10)::INTEGER
    ];

    UPDATE lottery_draws
    SET winning_numbers = draw_record.winning_numbers
    WHERE id = draw_id;
  END IF;

  -- Process each pending bet
  FOR bet_record IN
    SELECT * FROM bets
    WHERE lottery_draw_id = draw_id AND status = 'PENDING'
  LOOP
    v_total_processed := v_total_processed + 1;

    -- Determine win criteria
    win_crit := determine_win_criteria(
      bet_record.selected_numbers,
      draw_record.winning_numbers
    );

    IF win_crit IS NOT NULL THEN
      -- Winner!
      v_total_winners := v_total_winners + 1;

      -- Calculate prize
      prize_amount := bet_record.bet_amount * get_prize_multiplier(win_crit);
      v_total_prize_pool := v_total_prize_pool + prize_amount;

      -- Find matched numbers for audit
      SELECT ARRAY(
        SELECT UNNEST(bet_record.selected_numbers)
        INTERSECT
        SELECT UNNEST(draw_record.winning_numbers)
      ) INTO matched_numbers;

      -- Update bet
      UPDATE bets
      SET status = 'WON',
          actual_win_amount = prize_amount,
          win_criteria = win_crit,
          settled_at = NOW()
      WHERE id = bet_record.id;

      -- Update user balance
      UPDATE profiles
      SET balance = balance + prize_amount,
          updated_at = NOW()
      WHERE id = bet_record.user_id;

      -- Log prize distribution
      INSERT INTO prize_distributions (
        lottery_draw_id, bet_id, user_id,
        win_criteria, matched_numbers, prize_amount
      ) VALUES (
        draw_id, bet_record.id, bet_record.user_id,
        win_crit, matched_numbers, prize_amount
      );
    ELSE
      -- Lost
      UPDATE bets
      SET status = 'LOST',
          settled_at = NOW()
      WHERE id = bet_record.id;
    END IF;
  END LOOP;

  -- Update draw totals
  UPDATE lottery_draws
  SET status = 'COMPLETED',
      completed_at = NOW(),
      draw_time = NOW(),
      total_bets_count = v_total_processed,
      total_prize_pool = v_total_prize_pool
  WHERE id = draw_id;

  -- Create next scheduled draw
  DECLARE
    next_draw_time TIMESTAMP WITH TIME ZONE;
    v_next_draw_id UUID;
  BEGIN
    next_draw_time := get_next_draw_time(NOW());

    INSERT INTO lottery_draws (scheduled_time, status, previous_draw_id)
    VALUES (next_draw_time, 'PENDING', draw_id)
    RETURNING id INTO v_next_draw_id;

    -- Link current draw to next
    UPDATE lottery_draws
    SET next_draw_id = v_next_draw_id
    WHERE id = draw_id;
  END;

  -- Return result summary
  result := json_build_object(
    'draw_id', draw_id,
    'winning_numbers', draw_record.winning_numbers,
    'total_bets', v_total_processed,
    'total_winners', v_total_winners,
    'total_prize_pool', v_total_prize_pool
  );

  RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============ UTILITY FUNCTIONS ============

-- Function: Get current pending draw ID
CREATE OR REPLACE FUNCTION get_current_pending_draw_id()
RETURNS UUID AS $$
DECLARE
  v_draw_id UUID;
BEGIN
  SELECT id INTO v_draw_id
  FROM lottery_draws
  WHERE status = 'PENDING'
    AND scheduled_time <= NOW()
  ORDER BY scheduled_time ASC
  LIMIT 1;

  RETURN v_draw_id;
END;
$$ LANGUAGE plpgsql;

-- Function: Add balance to user (for Edge Function)
CREATE OR REPLACE FUNCTION add_balance(user_id UUID, amount NUMERIC)
RETURNS VOID AS $$
BEGIN
  UPDATE profiles
  SET balance = balance + amount,
      updated_at = NOW()
  WHERE id = user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Create initial draw schedule
CREATE OR REPLACE FUNCTION initialize_draw_schedule()
RETURNS VOID AS $$
DECLARE
  first_draw_time TIMESTAMP WITH TIME ZONE;
BEGIN
  -- Only create if no draws exist
  IF NOT EXISTS (SELECT 1 FROM lottery_draws) THEN
    first_draw_time := get_next_draw_time(NOW());

    INSERT INTO lottery_draws (scheduled_time, status)
    VALUES (first_draw_time, 'PENDING');

    RAISE NOTICE 'Initial draw scheduled for: %', first_draw_time;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Initialize the first draw on migration
SELECT initialize_draw_schedule();

-- ============ TRIGGER: Auto-create profile on user signup ============

-- Function to generate random 8-character username (letters + numbers)
CREATE OR REPLACE FUNCTION public.generate_random_username()
RETURNS TEXT 
LANGUAGE plpgsql 
SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  chars TEXT := 'abcdefghijklmnopqrstuvwxyz0123456789';
  result TEXT := '';
  i INTEGER := 0;
  is_unique BOOLEAN := FALSE;
BEGIN
  WHILE NOT is_unique LOOP
    result := '';
    FOR i IN 1..8 LOOP
      result := result || substring(chars from floor(random() * length(chars) + 1)::integer for 1);
    END LOOP;

    -- CRITICAL FIX: Added 'public.' schema prefix here
    SELECT NOT EXISTS (
      SELECT 1 FROM public.profiles WHERE username = result
    ) INTO is_unique;
  END LOOP;

  RETURN result;
END;
$$;

-- Trigger function to create profile on new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  v_username TEXT;
BEGIN
  -- Generate unique 8-character username using the qualified function
  v_username := public.generate_random_username();

  -- Insert new profile with default values
  -- (Assuming 'id' references auth.users(id) and is a UUID)
  INSERT INTO public.profiles (
    id,
    email,
    username,
    avatar_key,
    balance,
    status,
    is_onboarding_complete,
    created_at,
    updated_at
  ) VALUES (
    NEW.id,
    NEW.email,
    v_username,
    NULL,
    10000,
    'ACTIVE'::public.profile_status,
    FALSE,
    NOW(),
    NOW()
  );

  RETURN NEW;
END;
$$;

-- Trigger the function every time a user is created
-- Drop the trigger first just in case you are updating it
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============ ROW LEVEL SECURITY (RLS) ============

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_configs ENABLE ROW LEVEL SECURITY;
ALTER TABLE lottery_draws ENABLE ROW LEVEL SECURITY;
ALTER TABLE bets ENABLE ROW LEVEL SECURITY;
ALTER TABLE prize_distributions ENABLE ROW LEVEL SECURITY;
ALTER TABLE friends ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Public profiles are viewable"
  ON profiles FOR SELECT
  USING (
    deleted_at IS NULL
    AND status = 'ACTIVE'
    AND is_onboarding_complete = true
  );

-- Game configs (public read)
CREATE POLICY "Game configs are publicly readable"
  ON game_configs FOR SELECT
  USING (true);

-- Lottery draws (public read)
CREATE POLICY "Lottery draws are publicly readable"
  ON lottery_draws FOR SELECT
  USING (true);

-- Bets policies
CREATE POLICY "Users can view own bets"
  ON bets FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bets"
  ON bets FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Prize distributions policies
CREATE POLICY "Users can view own prize distributions"
  ON prize_distributions FOR SELECT
  USING (auth.uid() = user_id);

-- Friends policies
CREATE POLICY "Users can view own friends"
  ON friends FOR SELECT
  USING (auth.uid() = user_id OR auth.uid() = friend_id);

CREATE POLICY "Users can insert friend requests"
  ON friends FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own friend records"
  ON friends FOR UPDATE
  USING (auth.uid() = user_id);
