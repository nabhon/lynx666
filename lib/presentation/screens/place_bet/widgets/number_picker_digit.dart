import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NumberPickerDigit extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const NumberPickerDigit({
    super.key,
    required this.value,
    required this.onChanged,
  });

  void _increment() {
    onChanged((value + 1) % 10);
  }

  void _decrement() {
    onChanged((value - 1 + 10) % 10);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up arrow
        IconButton(
          onPressed: _increment,
          icon: const Icon(Icons.arrow_drop_up, size: 32),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
          color: AppColors.textSecondary,
        ),
        // Number display
        Container(
          width: 48,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ),
        // Down arrow
        IconButton(
          onPressed: _decrement,
          icon: const Icon(Icons.arrow_drop_down, size: 32),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
