# Lynx666 - Flutter Lottery Application

## Central Implementation Plan

---

## 1. Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend Framework** | Flutter (Dart) |
| **Backend** | Supabase (PostgreSQL + Auth + Realtime) |
| **State Management** | Riverpod |
| **Routing** | GoRouter |
| **Fonts** | Google Fonts (Kanit) |
| **Authentication** | Email/Password via Supabase Auth |

---

## 2. Color Scheme

```dart
// Primary Colors
primary: Color(0xFFFFB627)      // Main brand color - buttons, headers, active states
secondary: Color(0xFFFFD584)    // Supporting color - backgrounds, cards, highlights
accent: Color(0xFFFF9505)       // Call-to-action, emphasis, notifications

// Extended Palette (derived)
background: Color(0xFFFFF8F0)   // Light warm background
surface: Color(0xFFFFFFFF)      // Card surfaces
error: Color(0xFFE53935)        // Error states
success: Color(0xFF4CAF50)      // Success states
text: Color(0xFF1A1A1A)         // Primary text
textSecondary: Color(0xFF757575) // Secondary text
```

---

## 3. Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # Routing
  go_router: ^13.1.0
  
  # Backend & Auth
  supabase_flutter: ^2.3.0
  
  # UI & Fonts
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  
  # Utilities
  intl: ^0.19.0              # Date/time formatting
  cached_network_image: ^3.3.1  # Image caching
  image_picker: ^1.0.7         # Avatar upload
  
  # Environment
  flutter_dotenv: ^5.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  riverpod_generator: ^2.3.9
  build_runner: ^2.4.8
  custom_lint: ^0.5.8
  riverpod_lint: ^2.3.7
```

---

## 4. Repository Architecture (Clean Architecture)

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_routes.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── date_formatter.dart
│   │   └── validators.dart
│   └── widgets/
│       ├── loading_spinner.dart
│       ├── error_widget.dart
│       └── custom_button.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── lottery_model.dart
│   │   ├── bet_model.dart
│   │   └── win_log_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── lottery_repository.dart
│   │   ├── bet_repository.dart
│   │   └── user_repository.dart
│   └── datasources/
│       ├── supabase_auth_datasource.dart
│       ├── supabase_lottery_datasource.dart
│       └── supabase_bet_datasource.dart
│
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── lottery.dart
│   │   ├── bet.dart
│   │   └── win_log.dart
│   └── providers/
│       ├── auth_providers.dart
│       ├── lottery_providers.dart
│       ├── bet_providers.dart
│       └── user_providers.dart
│
├── presentation/
│   ├── providers/
│   │   ├── ui_state_provider.dart
│   │   └── navigation_provider.dart
│   ├── screens/
│   │   ├── loading/
│   │   │   └── loading_screen.dart
│   │   ├── login/
│   │   │   └── login_screen.dart
│   │   ├── onboarding/
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── avatar_picker.dart
│   │   │   │   └── username_form.dart
│   │   │   └── providers/
│   │   │       └── onboarding_providers.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── profile_header.dart
│   │   │   │   ├── lottery_number_display.dart
│   │   │   │   ├── countdown_timer.dart
│   │   │   │   └── win_log_list.dart
│   │   │   └── providers/
│   │   │       └── home_providers.dart
│   │   ├── leaderboard/
│   │   │   ├── leaderboard_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── leaderboard_item.dart
│   │   │   └── providers/
│   │   │       └── leaderboard_providers.dart
│   │   ├── bet_history/
│   │   │   ├── bet_history_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── bet_history_tile.dart
│   │   │   └── providers/
│   │   │       └── bet_history_providers.dart
│   │   └── place_bet/
│   │       ├── place_bet_screen.dart
│   │       └── providers/
│   │           └── place_bet_providers.dart
│   └── widgets/
│       ├── profile_avatar.dart
│       ├── lottery_ball.dart
│       └── win_log_tile.dart
│
├── main.dart
└── router.dart
```

---

## 5. Supabase Database Schema

```sql
-- Enum types
CREATE TYPE profile_status AS ENUM ('ACTIVE', 'INACTIVE', 'BANNED');
CREATE TYPE bet_status AS ENUM ('PENDING', 'WON', 'LOST');
CREATE TYPE draw_status AS ENUM ('PENDING', 'COMPLETED', 'CANCELLED');
CREATE TYPE win_criteria AS ENUM (
  'MATCH_6',              -- Match all 6 numbers
  'MATCH_3_FRONT',        -- Match first 3 numbers
  'MATCH_3_BACK',         -- Match last 3 numbers
  'MATCH_2_FRONT',        -- Match first 2 numbers
  'MATCH_2_BACK',         -- Match last 2 numbers
  'MATCH_5',              -- Match 5 numbers (bonus)
  'MATCH_4'               -- Match 4 numbers (bonus)
);

-- Users table (extends Supabase Auth)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT NOT NULL,
  username TEXT UNIQUE,
  avatar_key TEXT,
  balance NUMERIC(30, 2) DEFAULT 0,  -- Supports up to 999 trillion+
  status profile_status DEFAULT 'ACTIVE',
  is_onboarding_complete BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  deleted_at TIMESTAMP WITH TIME ZONE
);

-- Index for soft delete queries
CREATE INDEX idx_profiles_active ON profiles(id) WHERE deleted_at IS NULL AND status = 'ACTIVE';

-- Game configuration (draw frequency, prize multipliers)
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
  draw_number SERIAL NOT NULL,  -- Auto-incrementing integer
  winning_numbers INTEGER[6],
  scheduled_time TIMESTAMP WITH TIME ZONE NOT NULL,
  draw_time TIMESTAMP WITH TIME ZONE,  -- NULL until draw is completed
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
  potential_win_amount NUMERIC(30, 2),  -- Calculated at bet time
  actual_win_amount NUMERIC(30, 2),     -- Set after draw
  win_criteria win_criteria,            -- Set if won
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  settled_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_bets_user ON bets(user_id);
CREATE INDEX idx_bets_draw ON bets(lottery_draw_id);
CREATE INDEX idx_bets_status ON bets(status);
CREATE INDEX idx_bets_user_status ON bets(user_id, status);

-- Bet history view (combines bet + draw info)
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

-- Prize distribution log (audit trail for all payouts)
CREATE TABLE prize_distributions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  lottery_draw_id UUID REFERENCES lottery_draws(id) ON DELETE CASCADE,
  bet_id UUID REFERENCES bets(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  win_criteria win_criteria NOT NULL,
  matched_numbers INTEGER[],  -- Which numbers matched
  prize_amount NUMERIC(30, 2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_prize_dist_user ON prize_distributions(user_id);
CREATE INDEX idx_prize_dist_draw ON prize_distributions(lottery_draw_id);

-- Leaderboard view (active users only)
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

-- Friends (mutual friendship system)
CREATE TABLE friends (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  friend_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  status TEXT DEFAULT 'pending', -- pending, accepted, blocked
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, friend_id),
  CHECK (user_id != friend_id)  -- Can't friend yourself
);

CREATE INDEX idx_friends_user ON friends(user_id);
CREATE INDEX idx_friends_friend ON friends(friend_id);
CREATE INDEX idx_friends_status ON friends(status);

-- Friend list view (shows accepted friends with their info)
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

-- Friends leaderboard view (ranked among friends only)
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

-- Friend requests view (pending requests for a user)
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

-- Function: Calculate next draw time based on config
CREATE OR REPLACE FUNCTION get_next_draw_time(now_time TIMESTAMP WITH TIME ZONE)
RETURNS TIMESTAMP WITH TIME ZONE AS $$
DECLARE
  interval_hours INTEGER;
BEGIN
  SELECT (config_value->>'hours')::INTEGER INTO interval_hours
  FROM game_configs
  WHERE config_key = 'draw_interval';

  -- Round up to next interval
  RETURN DATE_TRUNC('hour', now_time) +
         (INTERVAL '1 hour' * interval_hours *
          CEIL(EXTRACT(EPOCH FROM now_time) / (interval_hours * 3600)));
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

-- Function: Process draw and distribute prizes
CREATE OR REPLACE FUNCTION process_lottery_draw(draw_id UUID)
RETURNS VOID AS $$
DECLARE
  draw_record RECORD;
  bet_record RECORD;
  prize_amount NUMERIC;
  matched_count INTEGER;
  win_crit win_criteria;
BEGIN
  -- Get draw info
  SELECT * INTO draw_record FROM lottery_draws WHERE id = draw_id;
  
  IF draw_record.status != 'PENDING' THEN
    RAISE EXCEPTION 'Draw already processed';
  END IF;
  
  -- Process each pending bet
  FOR bet_record IN 
    SELECT * FROM bets WHERE lottery_draw_id = draw_id AND status = 'PENDING'
  LOOP
    -- Calculate matches (implement matching logic)
    matched_count := array_length(
      ARRAY(SELECT unnest(bet_record.selected_numbers) 
            INTERSECT 
            SELECT unnest(draw_record.winning_numbers)), 1);
    
    -- Determine win criteria (simplified - implement full logic)
    IF matched_count = 6 THEN
      win_crit := 'MATCH_6';
    ELSIF matched_count = 5 THEN
      win_crit := 'MATCH_5';
    -- Add more criteria checks...
    ELSE
      -- Lost
      UPDATE bets SET status = 'LOST', settled_at = NOW() WHERE id = bet_record.id;
      CONTINUE;
    END IF;
    
    -- Calculate prize
    prize_amount := bet_record.bet_amount * get_prize_multiplier(win_crit);
    
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
    INSERT INTO prize_distributions (lottery_draw_id, bet_id, user_id, win_criteria, prize_amount)
    VALUES (draw_id, bet_record.id, bet_record.user_id, win_crit, prize_amount);
    
    -- Update draw totals
    UPDATE lottery_draws 
    SET total_prize_pool = total_prize_pool + prize_amount
    WHERE id = draw_id;
  END LOOP;
  
  -- Mark draw as completed
  UPDATE lottery_draws 
  SET status = 'COMPLETED', 
      completed_at = NOW(),
      draw_time = NOW()
  WHERE id = draw_id;
END;
$$ LANGUAGE plpgsql;
```

---

## 6. App Flow

```
┌─────────────────┐
│  Loading Screen │ ← Initialize Supabase, check auth state
└────────┬────────┘
         │
    ┌────▼────┐
    │  Login  │ ← Google OAuth via Supabase
    │  Screen │
    └────┬────┘
         │
    ┌────▼─────────────────────┐
    │   Onboarding Screen      │ ← NEW: First-time users only
    │  (Avatar + Username)     │   Upload avatar, set username
    └────┬─────────────────────┘
         │
    ┌────▼─────────────────────┐
    │      Home Screen         │
    │  ┌────────────────────┐  │
    │  │ Profile (Top Right)│  │
    │  ├────────────────────┤  │
    │  │  6-Digit Lottery   │  │
    │  │  Number Display    │  │
    │  ├────────────────────┤  │
    │  │  Countdown Timer   │  │
    │  │  (Next Draw)       │  │
    │  ├────────────────────┤  │
    │  │  Win Log List      │  │
    │  │  (Recent Wins)     │  │
    │  └────────────────────┘  │
    └──────────┬───────────────┘
         │              │
    ┌────▼────┐   ┌─────▼──────────┐
    │  Place  │   │  Bet History   │
    │   Bet   │   │   (All Bets)   │
    └─────────┘   └────────────────┘
         │
    ┌────▼─────────────────────┐
    │    Leaderboard Screen    │
    │  (Top Users by Balance)  │
    └──────────────────────────┘
```

---

## 7. Key Features Implementation

### 7.1 Loading Screen
- Initialize Supabase client
- Check authentication state
- Load user profile if authenticated
- Check if onboarding is complete
- Navigate to Onboarding, Login, or Home based on state

### 7.2 Login Screen
- Email/Password login form
- Register button for new users
- Email/Password registration form
- Create profile in `profiles` table on registration (is_onboarding_complete = false)
- Error handling for invalid credentials
- Navigate to Onboarding on successful auth

### 7.3 Onboarding Screen (NEW)
**For First-Time Users Only**

**Avatar Upload:**
- Image picker (camera/gallery)
- Preview selected image
- Crop/scale functionality
- Upload to Supabase Storage (`avatars/{user_id}.jpg`)
- Store `avatar_key` in profile

**Username Setup:**
- Text input field
- Real-time validation (3-20 chars, alphanumeric)
- Check username availability
- Auto-suggest if taken
- Save to profile on complete

**Flow:**
1. User picks avatar image
2. User enters username
3. Validate both inputs
4. Upload avatar to storage
5. Update profile (username, avatar_key, is_onboarding_complete = true)
6. Navigate to Home

### 7.4 Home Screen
**Profile Header (Top Right)**
- User avatar with frame (if equipped)
- User name with nameplate (if equipped)
- Balance display
- Tap to access profile/settings

**Lottery Number Display**
- Large 6-digit number display
- Animated reveal
- From latest completed draw

**Countdown Timer**
- Real-time countdown to next draw
- Updates every second
- Shows days, hours, minutes, seconds

**Win Log List**
- User's recent wins
- Shows: bet amount, selected numbers, criteria, win amount
- Scrollable list
- Color-coded by win amount

### 7.5 Leaderboard Screen
- Ranked list of users by balance
- Shows: rank, avatar, name, balance, total wins
- Toggle: Global | Friends
- Refresh on pull
- Highlight current user's position

### 7.6 Bet History Screen
- List of all user's bets (PENDING, WON, LOST)
- Filter tabs: All | Pending | Won | Lost
- Each bet tile shows:
  - Draw number & date
  - Selected numbers vs Winning numbers
  - Bet amount
  - Status badge (color-coded)
  - Win/Loss amount
- Pull to refresh
- Tap to see bet details

---

## 8. Riverpod State Management Structure

```dart
// Auth State
@riverpod
class AuthState extends _$AuthState {
  @override
  Future<User?> build() => ref.watch(authRepositoryProvider).currentUser;
  
  Future<void> signInWithEmailPassword(String email, String password) async {
    // Sign in with Supabase Auth
  }
  
  Future<void> signUpWithEmailPassword(String email, String password) async {
    // Sign up with Supabase Auth
  }
  
  Future<void> signOut() async { /* ... */ }
}

// Onboarding State
@riverpod
class OnboardingStatus extends _$OnboardingStatus {
  @override
  Future<bool> build() async {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return true;
    final profile = await ref.watch(userRepositoryProvider).getProfile(user.uid);
    return profile?.isOnboardingComplete ?? false;
  }
}

@riverpod
class AvatarUpload extends _$AvatarUpload {
  @override
  Future<String?> build() => null;
  
  Future<String> uploadAvatar(File image) async {
    // Upload to Supabase Storage
    // Return avatar_key
  }
}

// Lottery State
@riverpod
class LatestLottery extends _$LatestLottery {
  @override
  Future<Lottery?> build() => 
    ref.watch(lotteryRepositoryProvider).getLatestDraw();
}

@riverpod
class NextLotteryCountdown extends _$NextLotteryCountdown {
  @override
  Duration build() { /* Updates every second */ }
}

// User State
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<Profile?> build() => 
    ref.watch(userRepositoryProvider).getProfile(ref.watch(authStateProvider).value?.uid);
}

@riverpod
class UserWinLogs extends _$UserWinLogs {
  @override
  Future<List<WinLog>> build() => 
    ref.watch(betRepositoryProvider).getUserWinLogs(userId);
}

// Bet History State
@riverpod
class UserBetHistory extends _$UserBetHistory {
  @override
  Future<List<Bet>> build([BetStatus? filter]) => 
    ref.watch(betRepositoryProvider).getUserBets(userId, filter: filter);
}

// Leaderboard State
@riverpod
class Leaderboard extends _$Leaderboard {
  @override
  Future<List<LeaderboardEntry>> build() => 
    ref.watch(userRepositoryProvider).getLeaderboard();
}
```

---

## 9. GoRouter Configuration

```dart
final router = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => LoadingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => HomeScreen(),
      routes: [
        GoRoute(
          path: 'leaderboard',
          name: 'leaderboard',
          builder: (context, state) => LeaderboardScreen(),
        ),
        GoRoute(
          path: 'place-bet',
          name: 'place_bet',
          builder: (context, state) => PlaceBetScreen(),
        ),
        GoRoute(
          path: 'bet-history',
          name: 'bet_history',
          builder: (context, state) => BetHistoryScreen(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final isAuthenticated = checkAuth();
    final isOnboardingComplete = checkOnboarding();
    
    if (!isAuthenticated) return '/login';
    if (!isOnboardingComplete) return '/onboarding';
    
    return null;
  },
);
```

---

## 10. Supabase Storage Setup

```sql
-- Create storage bucket for avatars
-- In Supabase Dashboard > Storage > Create bucket

-- Bucket name: avatars
-- Public: false (private, accessed via RLS)
-- File size limit: 5MB
-- Allowed MIME types: image/jpeg, image/png, image/webp

-- Row Level Security (RLS) Policies
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can update own avatar"
ON storage.objects FOR UPDATE
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete own avatar"
ON storage.objects FOR DELETE
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Avatars are publicly viewable"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');
```

---

## 11. Development Phases

### Phase 1: Setup (Week 1)
- [ ] Initialize Flutter project
- [ ] Configure Supabase project
- [ ] Set up database schema
- [ ] Add all dependencies
- [ ] Enable Email/Password auth in Supabase
- [ ] Set up theme and color scheme
- [ ] Create Supabase Storage bucket for avatars

### Phase 2: Core Features (Week 2-3)
- [ ] Implement loading screen
- [ ] Implement login screen (email/password login + register)
- [ ] Implement onboarding screen (avatar upload + username)
- [ ] Set up Riverpod providers
- [ ] Configure GoRouter with onboarding check
- [ ] Create data models and repositories

### Phase 3: Home Screen (Week 4)
- [ ] Profile header component
- [ ] Lottery number display
- [ ] Countdown timer
- [ ] Win log list
- [ ] Real-time updates

### Phase 4: Leaderboard (Week 5)
- [ ] Leaderboard UI
- [ ] Leaderboard data fetching
- [ ] Ranking logic
- [ ] User highlighting

### Phase 5: Bet History (Week 6)
- [ ] Bet history screen UI
- [ ] Filter by status (All/Pending/Won/Lost)
- [ ] Bet details view
- [ ] Pagination/infinite scroll

### Phase 6: Friends System (Week 7)
- [ ] Friend request UI
- [ ] Accept/reject friend requests
- [ ] Friend list screen
- [ ] Friends leaderboard toggle

### Phase 7: Polish & Testing (Week 8)
- [ ] Animations and transitions
- [ ] Error handling
- [ ] Loading states
- [ ] Unit tests
- [ ] Widget tests
- [ ] Performance optimization

---

## 12. Future Features (Not Implemented Yet)

### Cosmetics System (Frames & Nameplates)
- **Profile Frames** - Decorative borders around avatar
- **Nameplates** - Custom name display styles
- **Rarity Tiers**: Common, Rare, Epic, Legendary
- **Unlock Methods**: 
  - Purchase with balance
  - Achievement rewards
  - Gacha/roll system
- **Storage**: 
  - Cosmetics catalog in Flutter (instant load)
  - User ownership & equipped status in Supabase
  - Display on leaderboard, profile, bet history

### Gacha/Roll System
- Spend balance to roll for random cosmetics
- Weighted rarity chances
- Duplicate protection or conversion system

---

## 13. Environment Configuration

```env
# .env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

---

## 14. Next Steps

1. **Set up Supabase project** - Create tables, enable Email/Password auth, create storage bucket
2. **Initialize Flutter project** - `flutter create lynx666`
3. **Implement Phase 1** - Basic setup and configuration
4. **Iterate through phases** - Build features incrementally

---

*Last Updated: 2026-03-17*
