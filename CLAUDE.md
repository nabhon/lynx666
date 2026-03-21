
- **Riverpod code generation:** Providers use `@riverpod` annotation → auto-generates `.g.dart` files. Always run `build_runner` after modifying provider code.
- **Repository pattern:** Abstract interfaces (`I*Repository`) in `data/repositories/`, implementations alongside them. Wired via Riverpod providers.
- **Supabase extensions:** `SupabaseClientExtensions` on `SupabaseClient` for convenience query methods.
- **Soft deletes:** Profiles use `deleted_at` field — queries filter `deleted_at IS NULL`.
- **Enum extensions:** `ProfileStatus`, `BetStatus`, `DrawStatus` enums with `fromString`/`toDbValue` extension methods.
- **AsyncValue pattern:** UI consumes providers via `ref.watch()` and renders with `.when(data:, loading:, error:)`.

## Routing

GoRouter in `lib/router.dart`:
- `/loading` — initial route, checks auth session + onboarding status
- `/login` — email/password auth
- `/onboarding` — avatar + username setup (first-time)
- `/` — home screen
- `/leaderboard`, `/place-bet`, `/bet-history` — feature screens

## Supabase Tables

Core: `profiles`, `lottery_draws`, `bets`, `prize_distributions`, `friends`, `game_configs`
Views: `leaderboard_view`, `user_stats_view`, `friends_leaderboard_view`, `friend_requests_view`

## Environment

Requires `.env` file with Supabase credentials (not committed). See `lib/core/config/supabase_config.dart` for expected variables.

## Documentation

Detailed guides in `docs/`:
- `DATA_LAYER_INTEGRATION_GUIDE.md` — entity/model/repository usage
- `PRESENTATION_LAYER_GUIDE.md` — consuming providers in UI
- `lynx666_structure.md` (root) — full structure and database schema