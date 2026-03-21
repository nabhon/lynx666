import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'presentation/screens/loading/loading_screen.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/leaderboard/leaderboard_screen.dart';
import 'presentation/screens/place_bet/place_bet_screen.dart';
import 'presentation/screens/bet_history/bet_history_screen.dart';
import 'presentation/screens/register/register_screen.dart';

/// Middleware to check authentication status on app boot.
/// Returns the route to navigate to based on auth status.
/// 
/// Usage: Call this in your loading screen to determine initial route.
String checkAuthAndRedirect() {
  final session = Supabase.instance.client.auth.currentSession;
  final isAuthenticated = session != null;
  
  if (!isAuthenticated) {
    return '/login';
  }
  
  // User is authenticated, check onboarding status
  return '/home';
}

/// Middleware to check auth and onboarding status after login.
/// Returns the appropriate route based on user's onboarding status.
/// 
/// Usage: Call this after successful login to determine where to navigate.
Future<String> getRouteAfterLogin() async {
  final session = Supabase.instance.client.auth.currentSession;
  final isAuthenticated = session != null;
  
  if (!isAuthenticated) {
    return '/login';
  }
  
  // User is authenticated, fetch profile to check onboarding status
  final userId = session.user.id;
  try {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('is_onboarding_complete')
        .eq('id', userId)
        .maybeSingle();
    
    final isOnboardingComplete = response?['is_onboarding_complete'] as bool? ?? false;
    
    if (!isOnboardingComplete) {
      return '/onboarding';
    }
    
    return '/home';
  } catch (e) {
    // If there's an error fetching profile, default to home
    return '/home';
  }
}

/// Middleware to protect routes that require authentication.
/// Checks if user is authenticated when navigating to protected routes.
/// 
/// Returns:
/// - null if user is authenticated (allow navigation)
/// - '/login' if user is not authenticated (redirect to login)
String? authGuard(BuildContext context, GoRouterState state) {
  final session = Supabase.instance.client.auth.currentSession;
  final isAuthenticated = session != null;
  
  // List of public routes that don't require auth
  final publicRoutes = ['/login', '/register', '/loading'];
  final isPublicRoute = publicRoutes.any((route) => 
    state.matchedLocation.startsWith(route)
  );
  
  // Allow public routes
  if (isPublicRoute) {
    return null;
  }
  
  // For all other routes (including /home and /onboarding), require authentication
  if (!isAuthenticated) {
    return '/login';
  }
  
  return null;
}

final router = GoRouter(
  // Start with the loading screen, then redirect based on auth status
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      name: 'loading',
      pageBuilder: (context, state) => CupertinoPage(
        key: state.pageKey,
        child: const LoadingScreen(),
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => CupertinoPage(
        key: state.pageKey,
        child: const LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => CupertinoPage(
        key: state.pageKey,
        child: const UsernameSetupScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) => CupertinoPage(
        key: state.pageKey,
        child: const HomeScreen(),
      ),
      routes: [
        GoRoute(
        path: '/leaderboard',
        name: 'leaderboard',
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const LeaderboardScreen(),
        ),
        ),
        GoRoute(
          path: '/place-bet',
          name: 'place_bet',
          pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: const PlaceBetScreen(),
          ),
        ),
        GoRoute(
          path: '/bet-history',
          name: 'bet_history',
          pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: const BetHistoryScreen(),
          ),
        ),
      ]
    ),
  ],
  redirect: (context, state) {
    // Apply auth guard to protect routes
    return authGuard(context, state);
  },
);
