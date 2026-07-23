import 'package:decimal/decimal.dart';
import '../../data/models/quotation.dart';
import '../../domain/repositories/quotation_repository.dart';

class CreateQuotation {
  final QuotationRepository repository;

  CreateQuotation(this.repository);

  Future<Quotation> execute(Quotation quotation, List<QuotationItem> items) async {
    // التحقق من صحة البيانات
    if (quotation.customerId <= 0) {
      throw Exception('Customer ID is required');
    }
    if (items.isEmpty) {
      throw Exception('Quotation must have at least one item');
    }
    
    // توليد رقم عرض سعر فريد
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final quotationNumber = 'QUO-$timestamp';
    
    final newQuotation = Quotation(
      quotationNumber: quotationNumber,
      customerId: quotation.customerId,
      branchId: quotation.branchId,
      warehouseId: quotation.warehouseId,
      date: quotation.date,
      expiryDate: quotation.expiryDate,
      status: 'draft',
      subtotal: _calculateSubtotal(items),
      discountTotal: _calculateDiscountTotal(items),
      taxTotal: _calculateTaxTotal(items),
      totalAmount: _calculateTotal(items),
      notes: quotation.notes,
      createdBy: quotation.createdBy,
    );

    return await repository.createQuotation(newQuotation, items);
  }

  Decimal _calculateSubtotal(List<QuotationItem> items) {
    return items.fold(Decimal.zero, (sum, item) => sum + (item.quantity * item.unitPrice));
  }

  Decimal _calculateDiscountTotal(List<QuotationItem> items) {
    return items.fold(Decimal.zero, (sum, item) => sum + item.discountAmount);
  }

  Decimal _calculateTaxTotal(List<QuotationItem> items) {
    return items.fold(Decimal.zero, (sum, item) => sum + item.taxAmount);
  }

  Decimal _calculateTotal(List<QuotationItem> items) {
    return items.fold(Decimal.zero, (sum, item) => sum + item.totalAmount);
  }
}
