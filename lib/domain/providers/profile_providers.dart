import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/supabase_client.dart';
import '../../domain/entities/entities.dart';
import 'repository_providers.dart';
import 'auth_providers.dart';

part 'profile_providers.g.dart';

/// User profile provider - fetches current user's profile
@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<Profile?> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return null;

    final repository = ref.watch(profileRepositoryProvider);
    return await repository.getProfile(userId);
  }

  /// Refresh profile data
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Update username
  Future<void> updateUsername(String newUsername) async {
    final profile = state.value;
    if (profile == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      final updatedProfile = profile.copyWith(
        username: newUsername,
        updatedAt: DateTime.now(),
      );
      return await repository.updateProfile(updatedProfile);
    });
  }

  /// Update avatar
  Future<void> updateAvatar(String avatarKey) async {
    final profile = state.value;
    if (profile == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      final updatedProfile = profile.copyWith(
        avatarKey: avatarKey,
        updatedAt: DateTime.now(),
      );
      return await repository.updateProfile(updatedProfile);
    });
  }

  /// Complete onboarding
  Future<void> completeOnboarding({
    required String username,
    required String avatarKey,
  }) async {
    // Get user ID directly from Supabase auth
    final userId = SupabaseInit.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(profileRepositoryProvider);
      return await repository.completeOnboarding(
        userId: userId,
        username: username,
        avatarKey: avatarKey,
      );
    });
  }

  /// Check if onboarding is complete
  bool get isOnboardingComplete => state.value?.isOnboardingComplete ?? false;

  /// Upload avatar image to Supabase storage
  Future<String> uploadAvatar(Uint8List imageBytes) async {
    // Get user ID directly from Supabase auth
    final userId = SupabaseInit.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    // Generate unique filename
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final avatarKey = 'avatars/$userId/$timestamp.png';

    // Upload to Supabase storage
    final bucket = SupabaseInit.client.storage.from('profile_avatar');
    await bucket.uploadBinary(
      avatarKey,
      imageBytes,
      fileOptions: FileOptions(contentType: 'image/png'),
    );

    return avatarKey;
  }
}

/// Onboarding status provider
@riverpod
class OnboardingStatus extends _$OnboardingStatus {
  @override
  Future<bool> build() async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return Future.value(true);

    final repository = ref.watch(profileRepositoryProvider);
    final profile = await repository.getProfile(userId);
    return profile?.isOnboardingComplete ?? false;
  }

  /// Refresh onboarding status
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Profile balance provider (derived from UserProfile)
@riverpod
class ProfileBalance extends _$ProfileBalance {
  @override
  double build() {
    final profile = ref.watch(userProfileProvider);
    return profile.value?.balance ?? 0.0;
  }
}

/// Avatar URL provider - transforms avatarKey to public URL (cached)
@riverpod
class AvatarUrl extends _$AvatarUrl {
  @override
  String? build() {
    final profile = ref.watch(userProfileProvider);
    final avatarKey = profile.value?.avatarKey;

    if (avatarKey == null || avatarKey.isEmpty) return null;

    // Cache the URL as long as the key doesn't change
    return SupabaseInit.client.storage
        .from('profile_avatar')
        .getPublicUrl(avatarKey);
  }
}
