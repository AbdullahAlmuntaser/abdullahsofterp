import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'money.dart';
import 'quantity.dart';

class ErpLogic {
  /// Calculates financial totals for an invoice based on items.
  static ({Money subtotal, Money taxableAmount, Money tax, Money total})
      calculateInvoiceTotals({
    required List<dynamic> items,
    Money? globalDiscount,
    Decimal? taxRate, // 15% in basis points
  }) {
    Money discount = globalDiscount ?? Money.zero;
    Decimal rate = taxRate ?? Decimal.parse('15');
    Money subtotal = Money.zero;

    for (var item in items) {
      Quantity quantity;
      Money price;

      if (item is SaleItemsCompanion) {
        quantity = Quantity(item.quantity.value);
        price = Money(item.price.value);
      } else if (item is SaleItem) {
        quantity = Quantity(item.quantity);
        price = Money(item.price);
      } else if (item is PurchaseItemsCompanion) {
        quantity = Quantity(item.quantity.value);
        price = Money(item.price.value);
      } else if (item is PurchaseItem) {
        quantity = Quantity(item.quantity);
        price = Money(item.price);
      } else {
        continue;
      }

      subtotal += price * quantity.value;
    }

    final taxableAmount = subtotal - discount;
    final tax = taxableAmount * (rate / Decimal.fromInt(100));
    final total = taxableAmount + tax;

    return (
      subtotal: subtotal,
      taxableAmount: taxableAmount,
      tax: tax,
      total: total
    );
  }

  /// Generates ZATCA-compliant QR code.
  static String generateZatcaQRCode({
    required String sellerName,
    required String vatNumber,
    required DateTime timestamp,
    required Money invoiceTotal,
    required Money vatTotal,
  }) {
    List<int> bytes = [];

    void addTag(int tag, String value) {
      List<int> valueBytes = utf8.encode(value);
      bytes.add(tag);
      bytes.add(valueBytes.length);
      bytes.addAll(valueBytes);
    }

    addTag(1, sellerName);
    addTag(2, vatNumber);
    addTag(3, DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(timestamp.toUtc()));
    addTag(4, invoiceTotal.toStringAsFixed(2));
    addTag(5, vatTotal.toStringAsFixed(2));

    return base64.encode(bytes);
  }

}
