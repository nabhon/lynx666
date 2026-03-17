import 'package:go_router/go_router.dart';

import 'presentation/screens/loading/loading_screen.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/leaderboard/leaderboard_screen.dart';
import 'presentation/screens/place_bet/place_bet_screen.dart';
import 'presentation/screens/bet_history/bet_history_screen.dart';

final router = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'leaderboard',
          name: 'leaderboard',
          builder: (context, state) => const LeaderboardScreen(),
        ),
        GoRoute(
          path: 'place-bet',
          name: 'place_bet',
          builder: (context, state) => const PlaceBetScreen(),
        ),
        GoRoute(
          path: 'bet-history',
          name: 'bet_history',
          builder: (context, state) => const BetHistoryScreen(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // TODO: Implement auth check
    // final isAuthenticated = checkAuth();
    // final isOnboardingComplete = checkOnboarding();
    //
    // if (!isAuthenticated) return '/login';
    // if (!isOnboardingComplete) return '/onboarding';
    //
    // return null;
    return null;
  },
);
