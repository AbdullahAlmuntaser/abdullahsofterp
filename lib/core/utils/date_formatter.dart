import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Centralized, locale-aware date/time formatting (AUD-043).
///
/// All UI screens should use these helpers instead of ad-hoc `DateFormat(...)`
/// or `toString().substring(...)` so the date representation stays consistent
/// with the active application locale (ar / en).
class AppDateFormatter {
  /// Full date, e.g. "2024-01-31" (locale-independent, good for storage display).
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Date + time, e.g. "2024-01-31 14:30".
  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  /// Locale-aware short date, e.g. "31 يناير 2024" / "Jan 31, 2024".
  static String formatShortDate(DateTime date, BuildContext context) {
    return DateFormat.yMMMd(Localizations.localeOf(context).languageCode)
        .format(date);
  }

  /// Locale-aware long date, e.g. "31 يناير، 2024" with weekday.
  static String formatLongDate(DateTime date, BuildContext context) {
    return DateFormat.yMMMMd(Localizations.localeOf(context).languageCode)
        .format(date);
  }

  /// Month + year, e.g. "2024-01".
  static String formatMonthYear(DateTime date) {
    return DateFormat('yyyy-MM').format(date);
  }

  /// Parses an ISO date string safely, returning null on failure.
  static DateTime? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
