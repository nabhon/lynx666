import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'repository_providers.dart';

part 'auth_providers.g.dart';

/// Auth state notifier provider
@riverpod
class AuthState extends _$AuthState {
  StreamSubscription? _authSubscription;

  @override
  Future<User?> build() async {
    debugPrint('AuthState.build() called');
    debugPrint('AuthState.build() currentUser: ${Supabase.instance.client.auth.currentUser?.email}');
    
    // Listen to auth state changes and invalidate when changed
    // Only invalidate if the user actually changes (not on initial emit)
    User? previousUser = Supabase.instance.client.auth.currentUser;
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      debugPrint('AuthState: onAuthStateChange event - ${data.event}');
      final currentUser = Supabase.instance.client.auth.currentUser;
      debugPrint('AuthState: previousUser: ${previousUser?.email}, currentUser: ${currentUser?.email}');
      // Only invalidate if user changed
      if (currentUser?.id != previousUser?.id) {
        previousUser = currentUser;
        debugPrint('AuthState: invalidating self');
        ref.invalidateSelf();
      }
    });

    // Return current user
    final user = Supabase.instance.client.auth.currentUser;
    debugPrint('AuthState.build() returning: ${user?.email}');
    return user;
  }

  /// Sign in with email and password
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.signInWithEmailPassword(
        email: email,
        password: password,
      );
    });
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.signUpWithEmailPassword(
        email: email,
        password: password,
      );
    });
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();
      return null;
    });
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.resetPassword(email: email);
      return state.value;
    });
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state.value != null;

  /// Get current user ID
  String? get currentUserId => state.value?.id;
}

/// Provider to check if user is authenticated (sync)
@riverpod
class IsAuthenticated extends _$IsAuthenticated {
  @override
  bool build() {
    return ref.watch(authStateProvider).value != null;
  }
}

/// Provider to get current user ID
@riverpod
class CurrentUserId extends _$CurrentUserId {
  @override
  String? build() {
    return ref.watch(authStateProvider).value?.id;
  }
}
