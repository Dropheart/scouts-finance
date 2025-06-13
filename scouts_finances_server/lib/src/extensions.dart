extension DateExtension on DateTime {
  String get formattedDate {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}

extension MoneyExtension on int {
  String get formatMoney {
    return '£${(this / 100).toStringAsFixed(2)}';
  }
}
