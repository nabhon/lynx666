import '../../domain/entities/entities.dart';

/// Lottery repository interface
abstract class ILotteryRepository {
  /// Get latest completed lottery draw
  Future<LotteryDraw?> getLatestCompletedDraw();

  /// Get next pending lottery draw
  Future<LotteryDraw?> getNextDraw();

  /// Get lottery draw by ID
  Future<LotteryDraw?> getDrawById(String drawId);

  /// Get lottery draw by draw number
  Future<LotteryDraw?> getDrawByNumber(int drawNumber);

  /// Get all draws (paginated)
  Future<List<LotteryDraw>> getDraws({
    int page = 1,
    int limit = 20,
    DrawStatus? status,
  });

  /// Get draws scheduled after a date
  Future<List<LotteryDraw>> getDrawsAfter(DateTime dateTime);

  /// Get draws scheduled before a date
  Future<List<LotteryDraw>> getDrawsBefore(DateTime dateTime);
}
