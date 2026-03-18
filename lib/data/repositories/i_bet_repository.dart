import '../../domain/entities/entities.dart';

/// Bet repository interface
abstract class IBetRepository {
  /// Place a new bet
  Future<Bet> placeBet({
    required String userId,
    required String lotteryDrawId,
    required List<int> selectedNumbers,
    required double betAmount,
  });

  /// Get bet by ID
  Future<Bet?> getBetById(String betId);

  /// Get all bets for a user
  Future<List<Bet>> getUserBets({
    required String userId,
    BetStatus? status,
    int page = 1,
    int limit = 20,
  });

  /// Get bets for a specific lottery draw
  Future<List<Bet>> getDrawBets(String drawId);

  /// Get pending bets for a user
  Future<List<Bet>> getUserPendingBets(String userId);

  /// Get won bets for a user
  Future<List<Bet>> getUserWonBets(String userId);

  /// Get lost bets for a user
  Future<List<Bet>> getUserLostBets(String userId);

  /// Update bet status
  Future<Bet> updateBetStatus(String betId, BetStatus status);

  /// Settle a bet (mark as won/lost with actual win amount)
  Future<Bet> settleBet({
    required String betId,
    required BetStatus status,
    double? actualWinAmount,
    WinCriteria? winCriteria,
  });

  /// Get bet count for user in a specific draw
  Future<int> getUserBetCountForDraw(String userId, String drawId);

  /// Calculate potential win for a bet
  Future<double> calculatePotentialWin({
    required double betAmount,
    required WinCriteria criteria,
  });
}
