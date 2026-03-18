import '../../domain/entities/friend.dart';
import '../../domain/entities/enums.dart';
import 'enum_extensions.dart';

/// Data model for Friend entity
class FriendModel extends Friend {
  const FriendModel({
    required super.id,
    required super.userId,
    required super.friendId,
    required super.username,
    super.avatarKey,
    super.balance,
    super.status,
    super.totalWins,
    super.lifetimeWinnings,
    required super.friendsSince,
  });

  /// Create a FriendModel from a JSON map (Supabase response)
  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      friendId: json['friend_id'] as String,
      username: json['username'] as String,
      avatarKey: json['avatar_key'] as String?,
      balance: _parseDouble(json['balance']),
      status: json['friend_status'] != null
          ? ProfileStatusX.fromValue(json['friend_status'] as String)
          : ProfileStatus.active,
      totalWins: json['total_wins'] as int? ?? 0,
      lifetimeWinnings: _parseDouble(json['lifetime_winnings']),
      friendsSince: _parseDateTime(json['friends_since']),
    );
  }

  /// Convert FriendModel to JSON map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'friend_id': friendId,
      'username': username,
      'avatar_key': avatarKey,
      'balance': balance,
      'friend_status': status.value,
      'total_wins': totalWins,
      'lifetime_winnings': lifetimeWinnings,
      'friends_since': friendsSince.toIso8601String(),
    };
  }

  /// Create a FriendModel from a Supabase map (friend_list_view)
  factory FriendModel.fromSupabase(Map<String, dynamic> data) {
    return FriendModel.fromJson(data);
  }

  /// Convert FriendModel to Supabase insert/update map
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'user_id': userId,
      'friend_id': friendId,
      'username': username,
      'avatar_key': avatarKey,
      'balance': balance,
      'status': status.value,
      'total_wins': totalWins,
      'lifetime_winnings': lifetimeWinnings,
    };
  }

  /// Create a copy of this FriendModel with updated fields
  FriendModel copyWith({
    String? id,
    String? userId,
    String? friendId,
    String? username,
    String? avatarKey,
    double? balance,
    ProfileStatus? status,
    int? totalWins,
    double? lifetimeWinnings,
    DateTime? friendsSince,
  }) {
    return FriendModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      username: username ?? this.username,
      avatarKey: avatarKey ?? this.avatarKey,
      balance: balance ?? this.balance,
      status: status ?? this.status,
      totalWins: totalWins ?? this.totalWins,
      lifetimeWinnings: lifetimeWinnings ?? this.lifetimeWinnings,
      friendsSince: friendsSince ?? this.friendsSince,
    );
  }

  /// Convert domain entity to model
  factory FriendModel.fromEntity(Friend entity) {
    return FriendModel(
      id: entity.id,
      userId: entity.userId,
      friendId: entity.friendId,
      username: entity.username,
      avatarKey: entity.avatarKey,
      balance: entity.balance,
      status: entity.status,
      totalWins: entity.totalWins,
      lifetimeWinnings: entity.lifetimeWinnings,
      friendsSince: entity.friendsSince,
    );
  }

  /// Convert model to domain entity
  Friend toEntity() {
    return Friend(
      id: id,
      userId: userId,
      friendId: friendId,
      username: username,
      avatarKey: avatarKey,
      balance: balance,
      status: status,
      totalWins: totalWins,
      lifetimeWinnings: lifetimeWinnings,
      friendsSince: friendsSince,
    );
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

  /// Helper: Parse double value
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  String toString() => 'FriendModel(friendId: $friendId, username: $username)';
}

/// Data model for FriendRequest entity
class FriendRequestModel extends FriendRequest {
  const FriendRequestModel({
    required super.requestId,
    required super.senderId,
    required super.receiverId,
    required super.senderUsername,
    super.senderAvatarKey,
    required super.requestDate,
  });

  /// Create a FriendRequestModel from a JSON map (Supabase response)
  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      requestId: json['request_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      senderUsername: json['sender_username'] as String,
      senderAvatarKey: json['sender_avatar_key'] as String?,
      requestDate: _parseDateTime(json['request_date']),
    );
  }

  /// Convert FriendRequestModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'sender_username': senderUsername,
      'sender_avatar_key': senderAvatarKey,
      'request_date': requestDate.toIso8601String(),
    };
  }

  /// Create a FriendRequestModel from a Supabase map (friend_requests_view)
  factory FriendRequestModel.fromSupabase(Map<String, dynamic> data) {
    return FriendRequestModel.fromJson(data);
  }

  /// Create a copy of this FriendRequestModel with updated fields
  FriendRequestModel copyWith({
    String? requestId,
    String? senderId,
    String? receiverId,
    String? senderUsername,
    String? senderAvatarKey,
    DateTime? requestDate,
  }) {
    return FriendRequestModel(
      requestId: requestId ?? this.requestId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderUsername: senderUsername ?? this.senderUsername,
      senderAvatarKey: senderAvatarKey ?? this.senderAvatarKey,
      requestDate: requestDate ?? this.requestDate,
    );
  }

  /// Convert domain entity to model
  factory FriendRequestModel.fromEntity(FriendRequest entity) {
    return FriendRequestModel(
      requestId: entity.requestId,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      senderUsername: entity.senderUsername,
      senderAvatarKey: entity.senderAvatarKey,
      requestDate: entity.requestDate,
    );
  }

  /// Convert model to domain entity
  FriendRequest toEntity() {
    return FriendRequest(
      requestId: requestId,
      senderId: senderId,
      receiverId: receiverId,
      senderUsername: senderUsername,
      senderAvatarKey: senderAvatarKey,
      requestDate: requestDate,
    );
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

  @override
  String toString() => 'FriendRequestModel(from: $senderUsername)';
}
