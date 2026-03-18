import '../../domain/entities/profile.dart';
import '../../domain/entities/enums.dart';
import 'enum_extensions.dart';

/// Data model for Profile entity
/// 
/// This model handles JSON serialization/deserialization and Supabase mapping.
/// It extends the domain entity and adds data-layer specific methods.
class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.email,
    super.username,
    super.avatarKey,
    super.balance,
    super.status,
    super.isOnboardingComplete,
    required super.createdAt,
    super.updatedAt,
    super.deletedAt,
  });

  /// Create a ProfileModel from a JSON map (Supabase response)
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      avatarKey: json['avatar_key'] as String?,
      balance: _parseBalance(json['balance']),
      status: json['status'] != null
          ? ProfileStatusX.fromValue(json['status'] as String)
          : ProfileStatus.active,
      isOnboardingComplete: json['is_onboarding_complete'] as bool? ?? false,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseNullableDateTime(json['updated_at']),
      deletedAt: _parseNullableDateTime(json['deleted_at']),
    );
  }

  /// Convert ProfileModel to JSON map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_key': avatarKey,
      'balance': balance,
      'status': status.value,
      'is_onboarding_complete': isOnboardingComplete,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Create a ProfileModel from a Supabase map (same as fromJson, kept for clarity)
  factory ProfileModel.fromSupabase(Map<String, dynamic> data) {
    return ProfileModel.fromJson(data);
  }

  /// Convert ProfileModel to Supabase insert/update map
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_key': avatarKey,
      'balance': balance,
      'status': status.value,
      'is_onboarding_complete': isOnboardingComplete,
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Create a copy of this ProfileModel with updated fields
  ProfileModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarKey,
    double? balance,
    ProfileStatus? status,
    bool? isOnboardingComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarKey: avatarKey ?? this.avatarKey,
      balance: balance ?? this.balance,
      status: status ?? this.status,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Convert domain entity to model
  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      email: profile.email,
      username: profile.username,
      avatarKey: profile.avatarKey,
      balance: profile.balance,
      status: profile.status,
      isOnboardingComplete: profile.isOnboardingComplete,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
      deletedAt: profile.deletedAt,
    );
  }

  /// Convert model to domain entity
  Profile toEntity() {
    return Profile(
      id: id,
      email: email,
      username: username,
      avatarKey: avatarKey,
      balance: balance,
      status: status,
      isOnboardingComplete: isOnboardingComplete,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  /// Helper: Parse balance value (handles num, int, double, String)
  static double _parseBalance(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Helper: Parse DateTime from various formats
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      throw FormatException('DateTime value cannot be null');
    }
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.parse(value);
    }
    throw FormatException('Invalid DateTime format: $value');
  }

  /// Helper: Parse nullable DateTime
  static DateTime? _parseNullableDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  @override
  String toString() => 'ProfileModel(id: $id, username: $username, email: $email)';
}
