import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/coin_formatter.dart';
import '../../../../domain/entities/entities.dart';
import '../../../../domain/providers/lottery_providers.dart';

class BetHistoryTile extends ConsumerWidget {
  final Bet bet;

  const BetHistoryTile({super.key, required this.bet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberString = bet.selectedNumbers
        .take(6)
        .map((n) => n.toString())
        .join();

    // กำหนดสีตาม status
    Color numberColor;
    String statusText;

    if (bet.isWon) {
      numberColor = Colors.green[700]!;
      statusText = 'ถูกรางวัล!';
    } else if (bet.isLost) {
      numberColor = Colors.red[700]!;
      statusText = 'ไม่ถูกรางวัล';
    } else {
      numberColor = Colors.orange[700]!;
      statusText = 'รอผลรางวัล...';
    }

    final drawAsync = ref.watch(lotteryDrawByIdProvider(bet.lotteryDrawId));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // เลข + สถานะ (ชิดซ้าย ไม่มี spacing)
              Row(
                children: [
                  Text(
                    numberString,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: numberColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: numberColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // ยอดเงิน
              Text(
                'ยอดแทง: ${formatCoin(bet.betAmount)} coin',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A5A60),
                ),
              ),

              // แสดงยอดถูกรางวัล (ถ้ามี)
              if (bet.actualWinAmount != null && bet.isWon) ...[
                const SizedBox(height: 2),
                Text(
                  'ถูก: ${formatCoin(bet.actualWinAmount!)} coin',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],

              const SizedBox(height: 2),

              // งวดที่
              drawAsync.when(
                data: (draw) => Text(
                  draw != null ? 'งวดที่ #${draw.drawNumber}' : '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
                loading: () => Text(
                  '...',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),

        Divider(
          height: 1,
          thickness: 0.5,
          indent: 20,
          endIndent: 20,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}
