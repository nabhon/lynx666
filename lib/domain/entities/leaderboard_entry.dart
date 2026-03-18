/// Leaderboard entry entity representing a user's position on the leaderboard
class LeaderboardEntry {
  final int rank;
  final String id;
  final String username;
  final String? avatarKey;
  final double balance;
  final int totalWins;
  final double lifetimeWinnings;

  const LeaderboardEntry({
    required this.rank,
    required this.id,
    required this.username,
    this.avatarKey,
    required this.balance,
    this.totalWins = 0,
    this.lifetimeWinnings = 0.0,
  });

  /// Get avatar URL (if avatarKey exists)
  String? get avatarUrl => avatarKey;

  /// Check if this is the current user
  bool isCurrentUser(String currentUserId) => id == currentUserId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'LeaderboardEntry(rank: $rank, username: $username, balance: $balance)';
}

/// User statistics entity
class UserStats {
  final String id;
  final String username;
  final double balance;
  final int totalBets;
  final int winningBets;
  final int losingBets;
  final double totalSpent;
  final double totalWon;
  final double netProfit;

  const UserStats({
    required this.id,
    required this.username,
    required this.balance,
    this.totalBets = 0,
    this.winningBets = 0,
    this.losingBets = 0,
    this.totalSpent = 0.0,
    this.totalWon = 0.0,
    this.netProfit = 0.0,
  });

  /// Get win rate as percentage
  double get winRate =>
      totalBets > 0 ? (winningBets / totalBets) * 100 : 0.0;

  /// Get ROI as percentage
  double get roi =>
      totalSpent > 0 ? (netProfit / totalSpent) * 100 : 0.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStats &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'UserStats(username: $username, balance: $balance, netProfit: $netProfit)';
}
