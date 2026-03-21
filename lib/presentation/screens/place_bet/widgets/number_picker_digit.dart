import 'package:flutter/material.dart';

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
        IconButton(
          onPressed: _increment,
          icon: const Icon(Icons.arrow_drop_up, size: 32),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
          color: const Color(0xFFFFB627),
        ),
        Container(
          width: 44,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB627), Color(0xFFFF9505)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'monospace',
            ),
          ),
        ),
        IconButton(
          onPressed: _decrement,
          icon: const Icon(Icons.arrow_drop_down, size: 32),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
          color: const Color(0xFFFFB627),
        ),
      ],
    );
  }
}
