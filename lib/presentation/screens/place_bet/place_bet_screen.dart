import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/providers/bet_providers.dart';
import '../../../domain/providers/lottery_providers.dart';
import '../../../domain/providers/profile_providers.dart';
import 'widgets/number_picker_digit.dart';

class PlaceBetScreen extends ConsumerStatefulWidget {
  const PlaceBetScreen({super.key});
  @override
  ConsumerState<PlaceBetScreen> createState() => _PlaceBetScreenState();
}

// Pre-built constants to avoid re-allocation during slider drags
const _kSliderTheme = SliderThemeData(
  activeTrackColor: Color(0xFFFFB627),
  inactiveTrackColor: Color(0xFFF0F0F0),
  thumbColor: Color(0xFFFFB627),
  overlayColor: Color(0x33FFB627),
  trackHeight: 8,
  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14),
  overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
);

const _kSelectedChipDecoration = BoxDecoration(
  color: Color(0xFFFFB627),
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(BorderSide(color: Color(0xFFFF9505))),
);

const _kUnselectedChipDecoration = BoxDecoration(
  color: Color(0xFFF5F5F5),
  borderRadius: BorderRadius.all(Radius.circular(20)),
  border: Border.fromBorderSide(BorderSide(color: Color(0xFFE0E0E0))),
);

const _kSelectedChipTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const _kUnselectedChipTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: Color(0xFF757575),
);

class _PlaceBetScreenState extends ConsumerState<PlaceBetScreen> {
  final List<int> _selectedNumbers = [0, 0, 0, 0, 0, 0];
  final ValueNotifier<double> _betPercentage = ValueNotifier<double>(0);
  bool _isSubmitting = false;

  @override
  void dispose() {
    _betPercentage.dispose();
    super.dispose();
  }

  String get _selectedNumbersText =>
      _selectedNumbers.map((n) => n.toString()).join('');

  double get _betAmount {
    final balance = ref.read(profileBalanceProvider);
    return (balance * _betPercentage.value / 100).floorToDouble();
  }

  Future<void> _onConfirm() async {
    if (_betPercentage.value <= 0 || _betAmount <= 0) {
      _showSnackBar('กรุณาเลือกจำนวน coin ที่ต้องการเดิมพัน');
      return;
    }

    final nextDraw = ref.read(nextLotteryDrawProvider).value;
    if (nextDraw == null) {
      _showSnackBar('ไม่พบรอบหวยที่เปิดรับ');
      return;
    }

    // Capture values before async gap to avoid using ref after dispose
    final notifier = ref.read(placeBetProvider.notifier);
    final amount = _betAmount;
    final numbers = List<int>.from(_selectedNumbers);

    setState(() => _isSubmitting = true);

    try {
      await notifier.placeBet(
            lotteryDrawId: nextDraw.id,
            selectedNumbers: numbers,
            betAmount: amount,
          );

      if (mounted) {
        _showSnackBar('วางเดิมพันสำเร็จ!', isError: false);
        context.go('/home');
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
        backgroundColor:
            isError ? const Color(0xFFE53935) : const Color(0xFF4CAF50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(profileBalanceProvider);
    final nextDraw = ref.watch(nextLotteryDrawProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button
                _buildHeader(),

                const SizedBox(height: 24),

                // Number Picker Section
                _buildNumberPicker(),

                const SizedBox(height: 24),

                // Coin Amount Input
                _buildAmountInput(),

                const SizedBox(height: 24),

                // Summary Section
                _buildSummary(balance, nextDraw),

                const SizedBox(height: 32),

                // Confirm Button
                _buildConfirmButton(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/home'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF1A1A1A),
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'วางเดิมพัน',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เลือกเลขของคุณ',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFAFAFA), Color(0xFFF0F0F0)],
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
      ],
    );
  }

  Widget _buildAmountInput() {
    final balance = ref.watch(profileBalanceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'จำนวน coin ที่ใช้เดิมพัน',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          child: RepaintBoundary(
            child: ValueListenableBuilder<double>(
              valueListenable: _betPercentage,
              builder: (context, percentage, child) {
                final coinAmount = (balance * percentage / 100).floor();
                return Column(
                  children: [
                    // Percentage display
                    Text(
                      '${percentage.round()}%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: percentage > 0
                            ? const Color(0xFFFFB627)
                            : const Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$coinAmount coin',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Slider — theme is a top-level const, not rebuilt
                    SliderTheme(
                      data: _kSliderTheme,
                      child: Slider(
                        value: percentage,
                        min: 0,
                        max: 50,
                        divisions: 50,
                        onChanged: (value) {
                          _betPercentage.value = value;
                        },
                      ),
                    ),

                    // Static labels passed via child (never rebuilt)
                    child!,

                    // Quick select buttons — use pre-built decorations
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [10, 20, 30, 40, 50].map((pct) {
                        final isSelected = percentage == pct;
                        return GestureDetector(
                          onTap: () =>
                              _betPercentage.value = pct.toDouble(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: isSelected
                                ? _kSelectedChipDecoration
                                : _kUnselectedChipDecoration,
                            child: Text(
                              '$pct%',
                              style: isSelected
                                  ? _kSelectedChipTextStyle
                                  : _kUnselectedChipTextStyle,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
              // Static portion — built once, reused every frame
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '50%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(double balance, AsyncValue nextDraw) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFAFAFA), Color(0xFFF0F0F0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFB627),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Selected numbers display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                width: 40,
                height: 56,
                margin: EdgeInsets.only(
                  right: index < 5 ? 8 : 0,
                  left: index == 3 ? 8 : 0,
                ),
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
                    _selectedNumbers[index].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // Balance info
          _buildSummaryRow(
            'เงินคงเหลือ',
            '${balance.toStringAsFixed(0)} coin',
            valueColor: const Color(0xFF1A1A1A),
          ),

          ValueListenableBuilder<double>(
            valueListenable: _betPercentage,
            builder: (context, percentage, _) {
              final betAmt =
                  (balance * percentage / 100).floorToDouble();
              if (betAmt <= 0) return const SizedBox.shrink();
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFE0E0E0)),
                  ),
                  _buildSummaryRow(
                    'เดิมพัน',
                    '${betAmt.toStringAsFixed(0)} coin',
                    valueColor: const Color(0xFFFF9505),
                  ),
                  const SizedBox(height: 4),
                  _buildSummaryRow(
                    'คงเหลือหลังเดิมพัน',
                    '${(balance - betAmt).toStringAsFixed(0)} coin',
                    valueColor: balance - betAmt >= 0
                        ? const Color(0xFF1A1A1A)
                        : const Color(0xFFE53935),
                  ),
                ],
              );
            },
          ),

          // Next draw info
          nextDraw.when(
            data: (draw) {
              if (draw == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _buildSummaryRow(
                  'งวดที่',
                  '#${draw.drawNumber}',
                  valueColor: const Color(0xFFFFB627),
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 12),
              child: SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFFB627),
                ),
              ),
            ),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _onConfirm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB627),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'ยืนยัน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
