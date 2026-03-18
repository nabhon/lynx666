import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import 'irepositories.dart';

/// Lottery repository implementation
class LotteryRepository implements ILotteryRepository {
  final SupabaseClient _supabase;

  LotteryRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  @override
  Future<LotteryDraw?> getLatestCompletedDraw() async {
    try {
      final response = await _supabase
          .from('lottery_draws')
          .select()
          .eq('status', DrawStatus.completed.value)
          .order('draw_number', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      final model = LotteryDrawModel.fromSupabase(response);
      return model.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LotteryDraw?> getNextDraw() async {
    try {
      final now = DateTime.now().toIso8601String();
      final response = await _supabase
          .from('lottery_draws')
          .select()
          .eq('status', DrawStatus.pending.value)
          .gte('scheduled_time', now)
          .order('scheduled_time', ascending: true)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      final model = LotteryDrawModel.fromSupabase(response);
      return model.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LotteryDraw?> getDrawById(String drawId) async {
    try {
      final response = await _supabase
          .from('lottery_draws')
          .select()
          .eq('id', drawId)
          .single();

      if (response == null) return null;

      final model = LotteryDrawModel.fromSupabase(response);
      return model.toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null;
      rethrow;
    }
  }

  @override
  Future<LotteryDraw?> getDrawByNumber(int drawNumber) async {
    try {
      final response = await _supabase
          .from('lottery_draws')
          .select()
          .eq('draw_number', drawNumber)
          .maybeSingle();

      if (response == null) return null;

      final model = LotteryDrawModel.fromSupabase(response);
      return model.toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null;
      rethrow;
    }
  }

  @override
  Future<List<LotteryDraw>> getDraws({
    int page = 1,
    int limit = 20,
    DrawStatus? status,
  }) async {
    var query = _supabase
        .from('lottery_draws')
        .select()
        .order('draw_number', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    if (status != null) {
      query = query.eq('status', status.value);
    }

    final response = await query;
    return (response as List)
        .map((e) => LotteryDrawModel.fromSupabase(e).toEntity())
        .toList();
  }

  @override
  Future<List<LotteryDraw>> getDrawsAfter(DateTime dateTime) async {
    final response = await _supabase
        .from('lottery_draws')
        .select()
        .gte('scheduled_time', dateTime.toIso8601String())
        .order('scheduled_time', ascending: true);

    return (response as List)
        .map((e) => LotteryDrawModel.fromSupabase(e).toEntity())
        .toList();
  }

  @override
  Future<List<LotteryDraw>> getDrawsBefore(DateTime dateTime) async {
    final response = await _supabase
        .from('lottery_draws')
        .select()
        .lte('scheduled_time', dateTime.toIso8601String())
        .order('scheduled_time', ascending: false);

    return (response as List)
        .map((e) => LotteryDrawModel.fromSupabase(e).toEntity())
        .toList();
  }
}
