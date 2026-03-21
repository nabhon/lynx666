import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/providers/providers.dart';
import '../../../domain/entities/entities.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Timer _timer;
  Duration? _previousCountdown;

  @override
  void initState() {
    super.initState();
    // Update countdown every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        ref.invalidate(lotteryCountdownProvider);
        _checkCountdownReachedZero();
      }
    });
  }

  /// Check if countdown just reached zero and refresh all related data
  void _checkCountdownReachedZero() {
    final countdown = ref.read(lotteryCountdownProvider);
    
    // Check if countdown just reached zero (was positive, now is zero)
    if (countdown == Duration.zero && (_previousCountdown ?? Duration.zero) > Duration.zero) {
      // Refresh lottery draw providers
      ref.invalidate(latestLotteryDrawProvider);
      ref.invalidate(nextLotteryDrawProvider);
      
      // Refresh user data providers (balance, bet history, pending bets)
      ref.invalidate(userProfileProvider);
      ref.invalidate(userBetHistoryProvider);
      ref.invalidate(userPendingBetsProvider);
      ref.invalidate(profileBalanceProvider);
    }
    
    _previousCountdown = countdown;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final latestDraw = ref.watch(latestLotteryDrawProvider);
    final countdown = ref.watch(lotteryCountdownProvider);
    final pendingBets = ref.watch(userPendingBetsProvider);
    final betHistory = ref.watch(userBetHistoryProvider());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(latestLotteryDrawProvider.future);
            await ref.refresh(nextLotteryDrawProvider.future);
            await ref.refresh(userProfileProvider.future);
            await ref.refresh(userBetHistoryProvider().future);
            await ref.refresh(userPendingBetsProvider.future);
            ref.invalidate(profileBalanceProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(profile),

                  const SizedBox(height: 24),

                  // Current Draw Section (Latest Completed Draw)
                  _buildCurrentDraw(latestDraw),

                  const SizedBox(height: 16),

                  // Countdown Timer Section
                  _buildCountdownTimer(countdown),

                  const SizedBox(height: 32),

                  // Your Number Section
                  _buildYourNumberSection(pendingBets),

                  const SizedBox(height: 32),

                  // Bet History Section
                  _buildBetHistorySection(betHistory),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Header with balance and profile
  Widget _buildHeader(AsyncValue<Profile?> profile) {
    return profile.when(
      data: (data) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Balance (Top Left)
          _buildBalanceCard(data?.balance ?? 0.0),
          // Profile Section (Top Right) - Leaderboard + Profile Image
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Leaderboard Button
              GestureDetector(
                onTap: () => context.goNamed('leaderboard'),
                child: Container(
                  width: 40,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB627), Color(0xFFFF9505)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Profile Image
              _buildProfileImage(data),
            ],
          ),
        ],
      ),
      loading: () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBalanceCard(0.0),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                height: 56,
                child: Icon(Icons.emoji_events, color: Colors.white),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(Icons.person, color: Color(0xFFFFB627)),
              ),
            ],
          ),
        ],
      ),
      error: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBalanceCard(0.0),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                height: 56,
                child: Icon(Icons.emoji_events, color: Colors.white),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(Icons.person, color: Color(0xFFFFB627)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9505), Color(0xFFFFB627)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ยอดคงเหลือ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${_formatNumber(balance)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(Profile? profile) {
    const double size = 50.0;
    final avatarUrl = ref.watch(avatarUrlProvider);

    if (avatarUrl != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFB627), width: 2),
          image: DecorationImage(
            image: NetworkImage(avatarUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Default avatar
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFB627), width: 2),
        color: const Color(0xFFFAFAFA),
      ),
      child: const Icon(
        Icons.person,
        color: Color(0xFFFFB627),
        size: 28,
      ),
    );
  }

  /// Current Draw Section with 6-digit winning numbers
  Widget _buildCurrentDraw(AsyncValue<LotteryDraw?> latestDraw) {
    return latestDraw.when(
      data: (draw) {
        // Get winning numbers from completed draw
        final winningNumbers = draw?.winningNumbers ?? [];
        final digits = winningNumbers.isNotEmpty
            ? winningNumbers.map((n) => n.toString()).toList()
            : List.filled(6, '0');

        return Column(
          children: [
            const Text(
              'เลขล่าสุด',
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFAFAFA),
                    const Color(0xFFF0F0F0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFFB627),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDigitBox(digits.length > 0 ? digits[0] : '0'),
                        _buildDigitBox(digits.length > 1 ? digits[1] : '0'),
                        _buildDigitBox(digits.length > 2 ? digits[2] : '0'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDigitBox(digits.length > 3 ? digits[3] : '0'),
                        _buildDigitBox(digits.length > 4 ? digits[4] : '0'),
                        _buildDigitBox(digits.length > 5 ? digits[5] : '0'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => _buildCurrentDrawLoading(),
      error: (_, __) => _buildCurrentDrawLoading(),
    );
  }

  Widget _buildDigitBox(String digit) {
    return Container(
      width: 40,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB627), Color(0xFFFF9505)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          digit,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentDrawLoading() {
    return Column(
      children: [
        const Text(
          'งวดปัจจุบัน',
          style: TextStyle(
            color: Color(0xFF757575),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 40,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 40,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Countdown Timer Section
  Widget _buildCountdownTimer(Duration countdown) {
    final formatter = DateFormat('HH:mm:ss');
    final formattedTime = formatter.format(
      DateTime(0, 1, 1, countdown.inHours,
          (countdown.inMinutes % 60), (countdown.inSeconds % 60)),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.access_time,
            color: Color(0xFFFFB627),
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            'เลขถัดไปใน ',
            style: TextStyle(
              color: Color(0xFF757575),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            formattedTime,
            style: const TextStyle(
              color: Color(0xFFFFB627),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  /// Your Number Section
  Widget _buildYourNumberSection(AsyncValue<List<Bet>> pendingBets) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลขของคุณ',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        pendingBets.when(
          data: (bets) {
            if (bets.isEmpty) {
              return _buildNoBetCard();
            }
            return _buildBetNumbersCard(bets);
          },
          loading: () => _buildBetNumbersLoading(),
          error: (_, __) => _buildBetNumbersLoading(),
        ),
      ],
    );
  }

  Widget _buildNoBetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.casino_outlined,
            color: Color(0xFFBDBDBD),
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'ยังไม่มีเลขของคุณ',
            style: TextStyle(
              color: Color(0xFF757575),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.goNamed('place_bet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB627),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'เลือกเลย !',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBetNumbersCard(List<Bet> bets) {
    // Get all selected numbers from pending bets
    final allNumbers = bets.expand((bet) => bet.selectedNumbers).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFAFAFA),
            const Color(0xFFF0F0F0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB627), width: 1.5),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: allNumbers.map((number) {
          return _buildDigitBox(number.toString());
        }).toList(),
      ),
    );
  }

  Widget _buildBetNumbersLoading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  /// Bet History Section
  Widget _buildBetHistorySection(AsyncValue<List<Bet>> betHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ประวัติการแทง',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.goNamed('bet_history'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'ดูทั้งหมด',
                style: TextStyle(
                  color: Color(0xFFFFB627),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        betHistory.when(
          data: (bets) {
            // Filter out pending bets and take last 5
            final settledBets = bets
                .where((bet) => bet.status != BetStatus.pending)
                .take(5)
                .toList();

            if (settledBets.isEmpty) {
              return _buildEmptyHistory();
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: settledBets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _buildBetHistoryItem(settledBets[index]);
              },
            );
          },
          loading: () => _buildBetHistoryLoading(),
          error: (_, __) => _buildBetHistoryLoading(),
        ),
      ],
    );
  }

  Widget _buildBetHistoryItem(Bet bet) {
    final isWin = bet.status == BetStatus.won;
    final isLost = bet.status == BetStatus.lost;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWin
              ? const Color(0xFFFFB627)
              : isLost
                  ? const Color(0xFFDC2626)
                  : const Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isWin
                  ? const Color(0xFFFFB627).withValues(alpha: 0.2)
                  : isLost
                      ? const Color(0xFFDC2626).withValues(alpha: 0.2)
                      : const Color(0xFFE0E0E0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWin ? Icons.check : isLost ? Icons.close : Icons.pending,
              color: isWin
                  ? const Color(0xFFFFB627)
                  : isLost
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF9E9E9E),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Numbers
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (var number in bet.selectedNumbers)
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          number.toString(),
                          style: const TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'งวด: ${_formatDate(bet.createdAt)}',
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Amount and Result
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '฿${_formatNumber(bet.betAmount)}',
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isWin && bet.actualWinAmount != null)
                Text(
                  '+฿${_formatNumber(bet.actualWinAmount!)}',
                  style: const TextStyle(
                    color: Color(0xFFFFB627),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else if (isLost)
                const Text(
                  'เสีย',
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: const Center(
        child: Text(
          'ยังไม่มีประวัติการแทง',
          style: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildBetHistoryLoading() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
        );
      },
    );
  }

  String _formatNumber(double value) {
    final formatter = NumberFormat('#,##0', 'th_TH');
    return formatter.format(value);
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yy', 'th_TH');
    return formatter.format(date);
  }
}
