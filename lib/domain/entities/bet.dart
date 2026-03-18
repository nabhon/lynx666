import 'enums.dart';

/// Bet entity representing a user's lottery bet
class Bet {
  final String id;
  final String userId;
  final String lotteryDrawId;
  final List<int> selectedNumbers;
  final double betAmount;
  final BetStatus status;
  final double? potentialWinAmount;
  final double? actualWinAmount;
  final WinCriteria? winCriteria;
  final DateTime createdAt;
  final DateTime? settledAt;

  const Bet({
    required this.id,
    required this.userId,
    required this.lotteryDrawId,
    required this.selectedNumbers,
    required this.betAmount,
    this.status = BetStatus.pending,
    this.potentialWinAmount,
    this.actualWinAmount,
    this.winCriteria,
    required this.createdAt,
    this.settledAt,
  });

  /// Check if bet is pending
  bool get isPending => status == BetStatus.pending;

  /// Check if bet won
  bool get isWon => status == BetStatus.won;

  /// Check if bet lost
  bool get isLost => status == BetStatus.lost;

  /// Check if bet is settled (won or lost)
  bool get isSettled => status == BetStatus.won || status == BetStatus.lost;

  /// Get net profit/loss for this bet
  double get netResult => (actualWinAmount ?? 0.0) - betAmount;

  /// Check if this bet is a winner with actual amount
  bool get hasWon => isWon && (actualWinAmount ?? 0.0) > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bet &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Bet(id: $id, selectedNumbers: $selectedNumbers, status: $status, amount: $betAmount)';
}
