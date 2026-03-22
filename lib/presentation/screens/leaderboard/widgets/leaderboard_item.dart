import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/coin_formatter.dart';
import '../../../../domain/entities/leaderboard_entry.dart';
import '../../../../data/datasources/supabase_client.dart';

class LeaderboardItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const LeaderboardItem({
    super.key,
    required this.entry,
    this.isCurrentUser = false,
  });

  String? _getAvatarUrl(String? avatarKey) {
    if (avatarKey == null || avatarKey.isEmpty) return null;
    return SupabaseInit.client.storage.from('profile_avatar').getPublicUrl(avatarKey);
  }

  Widget _buildAvatar() {
    final avatarUrl = _getAvatarUrl(entry.avatarKey);
    
    if (avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          avatarUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildDefaultAvatar();
          },
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCurrentUser ? const Color(0xFFFFE5CC) : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCurrentUser 
            ? const BorderSide(color: AppColors.accent, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank
            _buildRank(),
            const SizedBox(width: 16),
            
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: _buildAvatar(),
            ),
            const SizedBox(width: 16),
            
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.totalWins} wins',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Balance
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${formatCoin(entry.balance)} coin',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRank() {
    Color rankColor;
    Widget rankWidget;

    if (entry.rank == 1) {
      rankColor = const Color(0xFFFFD700); // Gold
      rankWidget = const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 32);
    } else if (entry.rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
      rankWidget = const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0), size: 28);
    } else if (entry.rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
      rankWidget = const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 24);
    } else {
      rankColor = AppColors.textSecondary;
      rankWidget = Text(
        '#${entry.rank}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: rankColor,
        ),
      );
    }

    return SizedBox(
      width: 40,
      child: Center(child: rankWidget),
    );
  }

  Widget _buildDefaultAvatar() {
    return Text(
      entry.username[0].toUpperCase(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
