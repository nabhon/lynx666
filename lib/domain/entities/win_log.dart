import 'enums.dart';

/// Win log entity representing a prize distribution/win record
class WinLog {
  final String id;
  final String lotteryDrawId;
  final String betId;
  final String userId;
  final WinCriteria winCriteria;
  final List<int> matchedNumbers;
  final double prizeAmount;
  final DateTime createdAt;

  const WinLog({
    required this.id,
    required this.lotteryDrawId,
    required this.betId,
    required this.userId,
    required this.winCriteria,
    required this.matchedNumbers,
    required this.prizeAmount,
    required this.createdAt,
  });

  /// Get win criteria display name
  String get criteriaDisplayName {
    switch (winCriteria) {
      case WinCriteria.match6:
        return 'Match 6';
      case WinCriteria.match5:
        return 'Match 5';
      case WinCriteria.match4:
        return 'Match 4';
      case WinCriteria.match3Front:
        return 'Match 3 Front';
      case WinCriteria.match3Back:
        return 'Match 3 Back';
      case WinCriteria.match2Front:
        return 'Match 2 Front';
      case WinCriteria.match2Back:
        return 'Match 2 Back';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WinLog &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'WinLog(id: $id, criteria: $winCriteria, prize: $prizeAmount)';
}
