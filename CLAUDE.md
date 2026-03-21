# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Lynx666 (lynx_lottery) is a Flutter mobile lottery/betting game app backed by Supabase (PostgreSQL). Users place bets on lottery draws, track balance, view leaderboards, and see win history.

**Stack:** Flutter 3.11.1+, Dart, Supabase, Riverpod (code-generated), GoRouter, Google Fonts (Kanit)

## Build & Development Commands

```bash
# Install dependencies
flutter pub get

# Code generation (Riverpod providers) — run after changing @riverpod annotations
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch    # continuous watch mode

# Run the app
flutter run

# Analyze / lint
flutter analyze

# Run tests
flutter test
flutter test test/widget_test.dart    # single test file
```

## Architecture

Clean Architecture with three layers — dependencies flow inward only:

```
presentation/ → domain/ → data/
```

- **data/** — Supabase client, models (JSON serialization via `fromMap`/`toMap`), repository implementations
- **domain/** — Entities (immutable with `copyWith`), repository interfaces (`I*` prefix), Riverpod providers (code-generated `.g.dart` files)
- **presentation/** — Screens organized by feature, each with `widgets/` and `providers/` subdirectories
- **core/** — Theme (`AppTheme` with Kanit font), constants (colors, routes, strings), config (`SupabaseConfig` from `.env`), shared widgets

## Key Patterns

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
