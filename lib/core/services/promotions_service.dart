import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart';

enum PromotionType { percentageDiscount, fixedDiscount, bogo }

class PromotionResult {
  final Decimal discountAmount;
  final String promotionName;
  final PromotionType type;
  final String? freeProductId;
  final Decimal? freeQuantity;

  PromotionResult({
    required this.discountAmount,
    required this.promotionName,
    required this.type,
    this.freeProductId,
    this.freeQuantity,
  });
}

class PromotionsService {
  final AppDatabase _db;

  PromotionsService(this._db);

  Future<List<PromotionResult>> applyPromotions({
    required String productId,
    required Decimal quantity,
    required Decimal basePrice,
    String? categoryId,
    Decimal? cartTotal,
  }) async {
    final now = DateTime.now();
    final activePromotions = await (_db.select(_db.promotions)
          ..where((p) => p.isActive.equals(true))
          ..where((p) => p.startDate.isSmallerOrEqual(Variable(now)))
          ..where((p) => p.endDate.isBiggerOrEqual(Variable(now)))
          ..where((p) =>
              p.productId.equals(productId) | p.productId.isNull()))
        .get();

    final results = <PromotionResult>[];

    for (var promo in activePromotions) {
      if (promo.categoryId != null && promo.categoryId != categoryId) continue;
      if (promo.minPurchaseAmount > Decimal.zero &&
          cartTotal != null &&
          cartTotal < promo.minPurchaseAmount) continue;

      switch (promo.type) {
        case 'PERCENTAGE_DISCOUNT':
          final discountFactor =
              (promo.value / Decimal.fromInt(100)).toDecimal();
          final discount = basePrice * discountFactor;
          if (discount > Decimal.zero) {
            results.add(PromotionResult(
              discountAmount: discount * quantity,
              promotionName: promo.name,
              type: PromotionType.percentageDiscount,
            ));
          }
          break;

        case 'FIXED_DISCOUNT':
          results.add(PromotionResult(
            discountAmount: promo.value * quantity,
            promotionName: promo.name,
            type: PromotionType.fixedDiscount,
          ));
          break;

        case 'BOGO':
          if (quantity >= Decimal.fromInt(2)) {
            final freeQty = (quantity / Decimal.fromInt(2)).floor();
            results.add(PromotionResult(
              discountAmount: basePrice * Decimal.fromInt(freeQty.toInt()),
              promotionName: promo.name,
              type: PromotionType.bogo,
              freeProductId: productId,
              freeQuantity: Decimal.fromInt(freeQty.toInt()),
            ));
          }
          break;
      }
    }

    return results;
  }

  Future<Decimal> calculateBestDiscount({
    required String productId,
    required Decimal quantity,
    required Decimal basePrice,
    String? categoryId,
    Decimal? cartTotal,
  }) async {
    final results = await applyPromotions(
      productId: productId,
      quantity: quantity,
      basePrice: basePrice,
      categoryId: categoryId,
      cartTotal: cartTotal,
    );

    if (results.isEmpty) return Decimal.zero;

    Decimal bestDiscount = Decimal.zero;
    for (var r in results) {
      if (r.discountAmount > bestDiscount) bestDiscount = r.discountAmount;
    }
    return bestDiscount;
  }
}
