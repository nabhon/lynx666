import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/providers/bet_providers.dart';
import '../../../domain/providers/lottery_providers.dart';
import '../../../domain/providers/profile_providers.dart';
import 'widgets/number_picker_digit.dart';

class PlaceBetScreen extends ConsumerStatefulWidget {
  const PlaceBetScreen({super.key});
 @override
  ConsumerState<PlaceBetScreen> createState() => _PlaceBetScreenState();
}

class _PlaceBetScreenState extends ConsumerState<PlaceBetScreen> {
  final List<int> _selectedNumbers = [0, 0, 0, 0, 0, 0];
  final TextEditingController _amountController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String get _selectedNumbersText =>
      _selectedNumbers.map((n) => n.toString()).join('');

  double get _betAmount => double.tryParse(_amountController.text) ?? 0;

  Future<void> _onConfirm() async {
    final balance = ref.read(profileBalanceProvider);

    if (_betAmount <= 0) {
      _showSnackBar('กรุณาใส่จำนวน coin');
      return;
    }

    if (_betAmount > balance) {
      _showSnackBar('coin ไม่เพียงพอ');
      return;
    }

    final nextDraw = ref.read(nextLotteryDrawProvider).value;
    if (nextDraw == null) {
      _showSnackBar('ไม่พบรอบหวยที่เปิดรับ');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(placeBetProvider.notifier).placeBet(
            lotteryDrawId: nextDraw.id,
            selectedNumbers: List.from(_selectedNumbers),
            betAmount: _betAmount,
          );

      if (mounted) {
        _showSnackBar('วางเดิมพันสำเร็จ!', isError: false);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('เกิดข้อผิดพลาด: $e');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(profileBalanceProvider);
    final nextDraw = ref.watch(nextLotteryDrawProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Bet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Number Picker Section
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return NumberPickerDigit(
                      value: _selectedNumbers[index],
                      onChanged: (newValue) {
                        setState(() => _selectedNumbers[index] = newValue);
                      },
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Coin Amount Section
            const Text(
              'จำนวน coin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'ใส่จำนวน coin ที่ต้องการเดิมพัน',
                suffixText: 'coin',
              ),
            ),

            const SizedBox(height: 32),

            // Summary Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  // Selected numbers display
                  Text(
                    _selectedNumbersText,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                      letterSpacing: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Balance info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'เงินคงเหลือ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${balance.toStringAsFixed(0)} coin',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  if (_betAmount > 0) ...[
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'เดิมพัน',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${_betAmount.toStringAsFixed(0)} coin',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Next draw info
                  nextDraw.when(
                    data: (draw) {
                      if (draw == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'งวดที่',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '#${draw.drawNumber}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Confirm Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _onConfirm,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'ยืนยัน',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
