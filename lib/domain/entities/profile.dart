import 'enums.dart';

/// User profile entity representing a user in the system
class Profile {
  final String id;
  final String email;
  final String? username;
  final String? avatarKey;
  final double balance;
  final ProfileStatus status;
  final bool isOnboardingComplete;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const Profile({
    required this.id,
    required this.email,
    this.username,
    this.avatarKey,
    this.balance = 0.0,
    this.status = ProfileStatus.active,
    this.isOnboardingComplete = false,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  /// Check if profile is soft-deleted
  bool get isDeleted => deletedAt != null;

  /// Check if profile is active and not deleted
  bool get isActive => status == ProfileStatus.active && !isDeleted;

  /// Get avatar URL (if avatarKey exists)
  String? get avatarUrl => avatarKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Profile(id: $id, username: $username, email: $email, balance: $balance)';
}
