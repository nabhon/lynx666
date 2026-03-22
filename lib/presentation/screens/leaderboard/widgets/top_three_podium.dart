import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/coin_formatter.dart';
import '../../../../domain/entities/leaderboard_entry.dart';
import '../../../../data/datasources/supabase_client.dart';

class TopThreePodium extends StatelessWidget {
  final List<LeaderboardEntry> topThree;
  final String? currentUserId;

  const TopThreePodium({
    super.key,
    required this.topThree,
    this.currentUserId,
  });

  String? _getAvatarUrl(String? avatarKey) {
    if (avatarKey == null || avatarKey.isEmpty) return null;
    return SupabaseInit.client.storage.from('profile_avatar').getPublicUrl(avatarKey);
  }

  @override
  Widget build(BuildContext context) {
    if (topThree.isEmpty) return const SizedBox.shrink();

    final first = topThree.length > 0 ? topThree[0] : null;
    final second = topThree.length > 1 ? topThree[1] : null;
    final third = topThree.length > 2 ? topThree[2] : null;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (second != null) _buildPodiumItem(second, 2, 140),
          const SizedBox(width: 8),
          if (first != null) _buildPodiumItem(first, 1, 180),
          const SizedBox(width: 8),
          if (third != null) _buildPodiumItem(third, 3, 120),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(LeaderboardEntry entry, int rank, double height) {
    Color crownColor;
    IconData crownIcon;
    
    if (rank == 1) {
      crownColor = const Color(0xFFFFD700); // Gold
      crownIcon = Icons.workspace_premium;
    } else if (rank == 2) {
      crownColor = const Color(0xFFC0C0C0); // Silver
      crownIcon = Icons.workspace_premium;
    } else {
      crownColor = const Color(0xFFCD7F32); // Bronze
      crownIcon = Icons.workspace_premium;
    }

    final isCurrentUser = currentUserId != null && entry.id == currentUserId;

    return Expanded(
      child: Column(
        children: [
          // Crown/Trophy
          Icon(crownIcon, color: crownColor, size: rank == 1 ? 40 : 32),
          const SizedBox(height: 8),
          
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentUser ? AppColors.accent : crownColor,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: rank == 1 ? 40 : 32,
              backgroundColor: AppColors.primary,
              child: _buildAvatar(entry, rank),
            ),
          ),
          const SizedBox(height: 8),
          
          // Username
          Text(
            entry.username,
            style: TextStyle(
              fontSize: rank == 1 ? 14 : 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          
          // Balance
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: crownColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${formatCoin(entry.balance)} coin',
              style: TextStyle(
                fontSize: rank == 1 ? 14 : 12,
                fontWeight: FontWeight.bold,
                color: crownColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Podium
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  crownColor.withOpacity(0.3),
                  crownColor.withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: rank == 1 ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: crownColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(LeaderboardEntry entry, int rank) {
    final avatarUrl = _getAvatarUrl(entry.avatarKey);
    final size = rank == 1 ? 80.0 : 64.0;
    
    if (avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          avatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildDefaultAvatar(entry, rank),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildDefaultAvatar(entry, rank);
          },
        ),
      );
    }
    return _buildDefaultAvatar(entry, rank);
  }

  Widget _buildDefaultAvatar(LeaderboardEntry entry, int rank) {
    return Text(
      entry.username[0].toUpperCase(),
      style: TextStyle(
        fontSize: rank == 1 ? 24 : 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

}
