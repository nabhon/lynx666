/// Data Models
/// 
/// Models are responsible for data serialization/deserialization and 
/// mapping between Supabase data and domain entities.
/// 
/// Each model:
/// - Extends its corresponding domain entity
/// - Provides fromJson/toJson for JSON serialization
/// - Provides fromSupabase/toSupabase for database operations
/// - Provides fromEntity/toEntity for conversion with domain layer
/// - Provides copyWith for immutable updates

export 'enum_extensions.dart';
export 'profile_model.dart';
export 'lottery_draw_model.dart';
export 'bet_model.dart';
export 'win_log_model.dart';
export 'prize_distribution_model.dart';
export 'friend_model.dart';
export 'game_config_model.dart';
export 'leaderboard_entry_model.dart';
