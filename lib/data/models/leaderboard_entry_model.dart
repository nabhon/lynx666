import '../../domain/entities/leaderboard_entry.dart';

/// Data model for LeaderboardEntry entity
class LeaderboardEntryModel extends LeaderboardEntry {
  const LeaderboardEntryModel({
    required super.rank,
    required super.id,
    required super.username,
    super.avatarKey,
    required super.balance,
    super.totalWins,
    super.lifetimeWinnings,
  });

  /// Create a LeaderboardEntryModel from a JSON map (Supabase response)
  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: json['rank'] as int,
      id: json['id'] as String,
      username: json['username'] as String,
      avatarKey: json['avatar_key'] as String?,
      balance: _parseDouble(json['balance']),
      totalWins: json['total_wins'] as int? ?? 0,
      lifetimeWinnings: _parseDouble(json['lifetime_winnings']),
    );
  }

  /// Convert LeaderboardEntryModel to JSON map for Supabase
  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'id': id,
      'username': username,
      'avatar_key': avatarKey,
      'balance': balance,
      'total_wins': totalWins,
      'lifetime_winnings': lifetimeWinnings,
    };
  }

  /// Create a LeaderboardEntryModel from a Supabase map (leaderboard_view)
  factory LeaderboardEntryModel.fromSupabase(Map<String, dynamic> data) {
    return LeaderboardEntryModel.fromJson(data);
  }

  /// Convert LeaderboardEntryModel to Supabase insert/update map
  Map<String, dynamic> toSupabase() {
    return {
      'rank': rank,
      'id': id,
      'username': username,
      'avatar_key': avatarKey,
      'balance': balance,
      'total_wins': totalWins,
      'lifetime_winnings': lifetimeWinnings,
    };
  }

  /// Create a copy of this LeaderboardEntryModel with updated fields
  LeaderboardEntryModel copyWith({
    int? rank,
    String? id,
    String? username,
    String? avatarKey,
    double? balance,
    int? totalWins,
    double? lifetimeWinnings,
  }) {
    return LeaderboardEntryModel(
      rank: rank ?? this.rank,
      id: id ?? this.id,
      username: username ?? this.username,
      avatarKey: avatarKey ?? this.avatarKey,
      balance: balance ?? this.balance,
      totalWins: totalWins ?? this.totalWins,
      lifetimeWinnings: lifetimeWinnings ?? this.lifetimeWinnings,
    );
  }

  /// Convert domain entity to model
  factory LeaderboardEntryModel.fromEntity(LeaderboardEntry entity) {
    return LeaderboardEntryModel(
      rank: entity.rank,
      id: entity.id,
      username: entity.username,
      avatarKey: entity.avatarKey,
      balance: entity.balance,
      totalWins: entity.totalWins,
      lifetimeWinnings: entity.lifetimeWinnings,
    );
  }

  /// Convert model to domain entity
  LeaderboardEntry toEntity() {
    return LeaderboardEntry(
      rank: rank,
      id: id,
      username: username,
      avatarKey: avatarKey,
      balance: balance,
      totalWins: totalWins,
      lifetimeWinnings: lifetimeWinnings,
    );
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
  String toString() =>
      'LeaderboardEntryModel(rank: $rank, username: $username, balance: $balance)';
}

/// Data model for UserStats entity
class UserStatsModel extends UserStats {
  const UserStatsModel({
    required super.id,
    required super.username,
    required super.balance,
    super.totalBets,
    super.winningBets,
    super.losingBets,
    super.totalSpent,
    super.totalWon,
    super.netProfit,
  });

  /// Create a UserStatsModel from a JSON map (Supabase response)
  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      id: json['id'] as String,
      username: json['username'] as String,
      balance: _parseDouble(json['balance']),
      totalBets: json['total_bets'] as int? ?? 0,
      winningBets: json['winning_bets'] as int? ?? 0,
      losingBets: json['losing_bets'] as int? ?? 0,
      totalSpent: _parseDouble(json['total_spent']),
      totalWon: _parseDouble(json['total_won']),
      netProfit: _parseDouble(json['net_profit']),
    );
  }

  /// Convert UserStatsModel to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'balance': balance,
      'total_bets': totalBets,
      'winning_bets': winningBets,
      'losing_bets': losingBets,
      'total_spent': totalSpent,
      'total_won': totalWon,
      'net_profit': netProfit,
    };
  }

  /// Create a UserStatsModel from a Supabase map (user_stats_view)
  factory UserStatsModel.fromSupabase(Map<String, dynamic> data) {
    return UserStatsModel.fromJson(data);
  }

  /// Create a copy of this UserStatsModel with updated fields
  UserStatsModel copyWith({
    String? id,
    String? username,
    double? balance,
    int? totalBets,
    int? winningBets,
    int? losingBets,
    double? totalSpent,
    double? totalWon,
    double? netProfit,
  }) {
    return UserStatsModel(
      id: id ?? this.id,
      username: username ?? this.username,
      balance: balance ?? this.balance,
      totalBets: totalBets ?? this.totalBets,
      winningBets: winningBets ?? this.winningBets,
      losingBets: losingBets ?? this.losingBets,
      totalSpent: totalSpent ?? this.totalSpent,
      totalWon: totalWon ?? this.totalWon,
      netProfit: netProfit ?? this.netProfit,
    );
  }

  /// Convert domain entity to model
  factory UserStatsModel.fromEntity(UserStats entity) {
    return UserStatsModel(
      id: entity.id,
      username: entity.username,
      balance: entity.balance,
      totalBets: entity.totalBets,
      winningBets: entity.winningBets,
      losingBets: entity.losingBets,
      totalSpent: entity.totalSpent,
      totalWon: entity.totalWon,
      netProfit: entity.netProfit,
    );
  }

  /// Convert model to domain entity
  UserStats toEntity() {
    return UserStats(
      id: id,
      username: username,
      balance: balance,
      totalBets: totalBets,
      winningBets: winningBets,
      losingBets: losingBets,
      totalSpent: totalSpent,
      totalWon: totalWon,
      netProfit: netProfit,
    );
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
  String toString() =>
      'UserStatsModel(username: $username, balance: $balance, netProfit: $netProfit)';
}
