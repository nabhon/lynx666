import '../../domain/entities/entities.dart';

/// Profile repository interface
abstract class IProfileRepository {
  /// Get profile by user ID
  Future<Profile?> getProfile(String userId);

  /// Get current user's profile
  Future<Profile?> getCurrentProfile();

  /// Create a new profile
  Future<Profile> createProfile(Profile profile);

  /// Update an existing profile
  Future<Profile> updateProfile(Profile profile);

  /// Soft delete a profile
  Future<void> deleteProfile(String userId);

  /// Check if username is available
  Future<bool> isUsernameAvailable(String username);

  /// Update user's balance
  Future<Profile> updateBalance(String userId, double newBalance);

  /// Mark onboarding as complete
  Future<Profile> completeOnboarding({
    required String userId,
    required String username,
    required String avatarKey,
  });
}
