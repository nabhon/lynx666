import 'package:intl/intl.dart';

/// Formats coin amounts with abbreviated suffixes.
/// - T for trillions (>= 1,000,000,000,000)
/// - B for billions (>= 1,000,000,000)
/// - M for millions (>= 1,000,000)
/// - K for thousands (>= 1,000)
/// - Plain number with commas below 1,000
String formatCoin(double value) {
  if (value >= 1e12) {
    return '${_trimTrailingZero(value / 1e12)} T';
  } else if (value >= 1e9) {
    return '${_trimTrailingZero(value / 1e9)} B';
  } else if (value >= 1e6) {
    return '${_trimTrailingZero(value / 1e6)} M';
  } else if (value >= 1e3) {
    return '${_trimTrailingZero(value / 1e3)} K';
  }
  return NumberFormat('#,##0', 'th_TH').format(value);
}

String _trimTrailingZero(double value) {
  final formatted = value.toStringAsFixed(1);
  if (formatted.endsWith('.0')) {
    return formatted.substring(0, formatted.length - 2);
  }
  return formatted;
}
