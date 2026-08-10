import 'package:supermarket/data/datasources/local/app_database.dart';

class PurchaseTotals {
  final Decimal subtotal;
  final Decimal discount;
  final Decimal shippingCost;
  final Decimal otherExpenses;
  final Decimal landedCosts;
  final Decimal tax;
  final Decimal total;

  const PurchaseTotals({
    required this.subtotal,
    required this.discount,
    required this.shippingCost,
    required this.otherExpenses,
    required this.landedCosts,
    required this.tax,
    required this.total,
  });
}

class PurchaseTotalsCalculator {
  const PurchaseTotalsCalculator._();

  /// يحسب مكونات فاتورة المشتريات من المخزّن.
  ///
  /// معادلة الحفظ في add_purchase_page:
  /// total = subtotal - discount + shippingCost + otherExpenses + landedCosts + tax
  static PurchaseTotals fromPurchase(Purchase purchase) {
    final subtotal = purchase.total -
        purchase.tax -
        purchase.shippingCost -
        purchase.otherExpenses -
        purchase.landedCosts +
        purchase.discount;
    return PurchaseTotals(
      subtotal: subtotal,
      discount: purchase.discount,
      shippingCost: purchase.shippingCost,
      otherExpenses: purchase.otherExpenses,
      landedCosts: purchase.landedCosts,
      tax: purchase.tax,
      total: purchase.total,
    );
  }
}
