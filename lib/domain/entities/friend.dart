import 'enums.dart';

/// Friend entity representing a friendship relationship
class Friend {
  final String id;
  final String userId;
  final String friendId;
  final String username;
  final String? avatarKey;
  final double balance;
  final ProfileStatus status;
  final int totalWins;
  final double lifetimeWinnings;
  final DateTime friendsSince;

  const Friend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.username,
    this.avatarKey,
    this.balance = 0.0,
    this.status = ProfileStatus.active,
    this.totalWins = 0,
    this.lifetimeWinnings = 0.0,
    required this.friendsSince,
  });

  /// Get avatar URL (if avatarKey exists)
  String? get avatarUrl => avatarKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Friend &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Friend(friendId: $friendId, username: $username, balance: $balance)';
}

/// Friend request entity
class FriendRequest {
  final String requestId;
  final String senderId;
  final String receiverId;
  final String senderUsername;
  final String? senderAvatarKey;
  final DateTime requestDate;

  const FriendRequest({
    required this.requestId,
    required this.senderId,
    required this.receiverId,
    required this.senderUsername,
    this.senderAvatarKey,
    required this.requestDate,
  });

  String? get senderAvatarUrl => senderAvatarKey;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendRequest &&
          runtimeType == other.runtimeType &&
          requestId == other.requestId;

  @override
  int get hashCode => requestId.hashCode;

  @override
  String toString() =>
      'FriendRequest(from: $senderUsername, date: $requestDate)';
}
