import 'package:decimal/decimal.dart';

/// Shared validation for split/partial payment.
/// Single source of truth used by the sales invoice UI and tests.
class SplitPaymentValidator {
  static final Decimal _tolerance = Decimal.parse('0.01');

  /// Returns an error message when the split amounts are invalid, otherwise null.
  static String? validate({
    required Decimal cash,
    required Decimal credit,
    required Decimal total,
  }) {
    if (cash < Decimal.zero || credit < Decimal.zero) {
      return 'مبلغ الكاش والآجل يجب أن يكونا أكبر من أو يساويا صفر';
    }
    if ((cash + credit - total).abs() > _tolerance) {
      return 'مبلغ الكاش والآجل يجب أن يساويا إجمالي الفاتورة';
    }
    return null;
  }
}
