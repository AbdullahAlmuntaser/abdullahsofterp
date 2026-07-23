import 'package:json_annotation/json_annotation.dart';
import 'package:decimal/decimal.dart';

part 'quotation.g.dart';

Decimal _decimalFromJson(dynamic v) => v == null ? Decimal.zero : Decimal.tryParse(v.toString()) ?? Decimal.zero;
String _decimalToJson(Decimal d) => d.toString();

@JsonSerializable()
class Quotation {
  final int? id;
  final String quotationNumber;
  final int customerId;
  final int? branchId;
  final int? warehouseId;
  final DateTime date;
  final DateTime? expiryDate;
  final String status;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal subtotal;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal discountTotal;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal taxTotal;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal totalAmount;
  final String? notes;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Quotation({
    this.id,
    required this.quotationNumber,
    required this.customerId,
    this.branchId,
    this.warehouseId,
    required this.date,
    this.expiryDate,
    this.status = 'draft',
    required this.subtotal,
    required this.discountTotal,
    required this.taxTotal,
    required this.totalAmount,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) => _$QuotationFromJson(json);
  Map<String, dynamic> toJson() => _$QuotationToJson(this);
}

@JsonSerializable()
class QuotationItem {
  final int? id;
  final int quotationId;
  final int productId;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal quantity;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal unitPrice;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal discountPercent;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal discountAmount;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal taxPercent;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal taxAmount;
  @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
  final Decimal totalAmount;
  final String? notes;

  QuotationItem({
    this.id,
    required this.quotationId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.discountPercent,
    required this.discountAmount,
    required this.taxPercent,
    required this.taxAmount,
    required this.totalAmount,
    this.notes,
  });

  factory QuotationItem.fromJson(Map<String, dynamic> json) => _$QuotationItemFromJson(json);
  Map<String, dynamic> toJson() => _$QuotationItemToJson(this);
}
