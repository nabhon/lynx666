import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/repositories.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepository(supabase: supabase);
});

/// Provider for ProfileRepository
final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProfileRepository(supabase: supabase);
});

/// Provider for LotteryRepository
final lotteryRepositoryProvider = Provider<ILotteryRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return LotteryRepository(supabase: supabase);
});

/// Provider for BetRepository
final betRepositoryProvider = Provider<IBetRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return BetRepository(supabase: supabase);
});

/// Provider for UserRepository
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return UserRepository(supabase: supabase);
});

/// Provider for FriendRepository
final friendRepositoryProvider = Provider<IFriendRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FriendRepository(supabase: supabase);
});

/// Provider for GameConfigRepository
final gameConfigRepositoryProvider = Provider<IGameConfigRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return GameConfigRepository(supabase: supabase);
});
