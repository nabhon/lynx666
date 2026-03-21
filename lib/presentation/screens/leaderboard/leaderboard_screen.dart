import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/providers/user_providers.dart';
import '../../../domain/providers/auth_providers.dart';
import 'widgets/top_three_podium.dart';
import 'widgets/leaderboard_item.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider());
    final currentUser = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: leaderboardAsync.when(
        data: (allEntries) {
          if (allEntries.isEmpty) {
            return const Center(child: Text('No leaderboard data'));
          }

          final topThree = allEntries.take(3).toList();
          final remaining = allEntries.skip(3).take(7).toList(); // 4-10
          
          // Find current user
          final currentUserEntry = allEntries.firstWhere(
            (e) => currentUser != null && e.id == currentUser.id,
            orElse: () => allEntries.first,
          );
          final isInTop10 = currentUserEntry.rank <= 10;

          return RefreshIndicator(
            onRefresh: () => ref.refresh(leaderboardProvider().future),
            child: ListView(
              children: [
                // Top 3 Podium
                TopThreePodium(
                  topThree: topThree,
                  currentUserId: currentUser?.id,
                ),
                const SizedBox(height: 16),
                
                // Current user rank (if not in top 10)
                if (!isInTop10 && currentUser != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Rank',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LeaderboardItem(
                          entry: currentUserEntry,
                          isCurrentUser: true,
                        ),
                        const SizedBox(height: 8),
                        const Divider(thickness: 2),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                
                // Remaining users (4-10)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: remaining.map((entry) {
                      final isCurrentUser = currentUser != null && 
                          entry.id == currentUser.id;
                      return LeaderboardItem(
                        entry: entry,
                        isCurrentUser: isCurrentUser,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(leaderboardProvider()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
