import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import 'irepositories.dart';

/// Game configuration repository implementation
class GameConfigRepository implements IGameConfigRepository {
  final SupabaseClient _supabase;

  GameConfigRepository({required SupabaseClient supabase})
      : _supabase = supabase;

  @override
  Future<GameConfig?> getConfigByKey(String key) async {
    try {
      final response = await _supabase
          .from('game_configs')
          .select()
          .eq('config_key', key)
          .maybeSingle();

      if (response == null) return null;

      final model = GameConfigModel.fromSupabase(response);
      return model.toEntity();
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') return null;
      rethrow;
    }
  }

  @override
  Future<int> getDrawIntervalHours() async {
    final config = await getConfigByKey('draw_interval');
    return config?.drawIntervalHours ?? 2;
  }

  @override
  Future<Map<String, dynamic>> getPrizeMultipliers() async {
    final config = await getConfigByKey('prize_multipliers');
    return config?.prizeMultipliers ?? {};
  }

  @override
  Future<Map<String, dynamic>> getBetLimits() async {
    final config = await getConfigByKey('bet_limits');
    return config?.betLimits ?? {};
  }

  @override
  Future<double> getMinBetAmount() async {
    final config = await getConfigByKey('bet_limits');
    return config?.minBetAmount ?? 1.0;
  }

  @override
  Future<double> getMaxBetPercentage() async {
    final config = await getConfigByKey('bet_limits');
    return config?.maxBetPercentage ?? 0.5;
  }

  @override
  Future<List<GameConfig>> getAllConfigs() async {
    final response = await _supabase
        .from('game_configs')
        .select()
        .order('updated_at', ascending: false);

    return (response as List)
        .map((e) => GameConfigModel.fromSupabase(e).toEntity())
        .toList();
  }
}
