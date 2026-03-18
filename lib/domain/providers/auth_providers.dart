import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'repository_providers.dart';

part 'auth_providers.g.dart';

/// Auth state notifier provider
@riverpod
class AuthState extends _$AuthState {
  @override
  Future<User?> build() async {
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      ref.invalidateSelf();
    });

    // Return current user
    return Supabase.instance.client.auth.currentUser;
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
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).value != null;
});

/// Provider to get current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.id;
});
