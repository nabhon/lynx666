import 'enums.dart';

/// Prize distribution entity (same as WinLog but with additional context)
class PrizeDistribution {
  final String id;
  final String lotteryDrawId;
  final String betId;
  final String userId;
  final WinCriteria winCriteria;
  final List<int> matchedNumbers;
  final double prizeAmount;
  final DateTime createdAt;

  const PrizeDistribution({
    required this.id,
    required this.lotteryDrawId,
    required this.betId,
    required this.userId,
    required this.winCriteria,
    required this.matchedNumbers,
    required this.prizeAmount,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrizeDistribution &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PrizeDistribution(id: $id, userId: $userId, prize: $prizeAmount)';
}
