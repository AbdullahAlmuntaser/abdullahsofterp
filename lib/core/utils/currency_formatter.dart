import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

/// Centralized currency formatting helper (AUD-042).
///
/// Replaces hard-coded currency symbols such as "ر.س" / "SAR" / "USD" scattered
/// across the UI with a single source of truth that resolves the symbol from the
/// currency code and keeps the numeric formatting consistent everywhere.
class CurrencyFormatter {
  static const Map<String, String> _symbolsByCode = {
    'SAR': 'ر.س',
    'USD': '\$',
    'EUR': '€',
    'YER': 'ر.ي',
    'AED': 'د.إ',
    'EGP': 'ج.م',
    'KWD': 'د.ك',
    'QAR': 'ر.ق',
    'BHD': 'د.ب',
    'JOD': 'د.أ',
  };

  /// Returns the localized symbol for a currency code, defaulting to SAR.
  static String symbolFor(String? currencyId) {
    if (currencyId == null || currencyId.isEmpty) return _symbolsByCode['SAR']!;
    return _symbolsByCode[currencyId.toUpperCase()] ?? currencyId;
  }

  /// Formats [amount] with the given currency code, e.g. "1,234.00 ر.س".
  /// Accepts both [num] and [Decimal] (used across the data layer).
  static String format(
    dynamic amount, {
    String? currencyId,
    int decimalDigits = 2,
  }) {
    final numValue = _toNum(amount);
    final formatted = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalDigits,
      locale: 'en_US',
    ).format(numValue);
    return '$formatted ${symbolFor(currencyId)}';
  }

  /// Formats [amount] using the active app locale for digit grouping.
  static String formatLocalized(
    BuildContext context,
    dynamic amount, {
    String? currencyId,
    int decimalDigits = 2,
  }) {
    final locale = Localizations.localeOf(context).languageCode;
    final numValue = _toNum(amount);
    final formatted = NumberFormat.currency(
      symbol: '',
      decimalDigits: decimalDigits,
      locale: locale == 'ar' ? 'ar' : 'en_US',
    ).format(numValue);
    return '$formatted ${symbolFor(currencyId)}';
  }

  static num _toNum(dynamic amount) {
    if (amount is num) return amount;
    if (amount is Decimal) return amount.toDouble();
    if (amount is String) return num.tryParse(amount) ?? 0;
    return 0;
  }
}
