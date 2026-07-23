// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quotation _$QuotationFromJson(Map<String, dynamic> json) => Quotation(
      id: (json['id'] as num?)?.toInt(),
      quotationNumber: json['quotationNumber'] as String,
      customerId: (json['customerId'] as num).toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      warehouseId: (json['warehouseId'] as num?)?.toInt(),
      date: DateTime.parse(json['date'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      status: json['status'] as String? ?? 'draft',
      subtotal: _decimalFromJson(json['subtotal']),
      discountTotal: _decimalFromJson(json['discountTotal']),
      taxTotal: _decimalFromJson(json['taxTotal']),
      totalAmount: _decimalFromJson(json['totalAmount']),
      notes: json['notes'] as String?,
      createdBy: (json['createdBy'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$QuotationToJson(Quotation instance) => <String, dynamic>{
      'id': instance.id,
      'quotationNumber': instance.quotationNumber,
      'customerId': instance.customerId,
      'branchId': instance.branchId,
      'warehouseId': instance.warehouseId,
      'date': instance.date.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'status': instance.status,
      'subtotal': _decimalToJson(instance.subtotal),
      'discountTotal': _decimalToJson(instance.discountTotal),
      'taxTotal': _decimalToJson(instance.taxTotal),
      'totalAmount': _decimalToJson(instance.totalAmount),
      'notes': instance.notes,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

QuotationItem _$QuotationItemFromJson(Map<String, dynamic> json) =>
    QuotationItem(
      id: (json['id'] as num?)?.toInt(),
      quotationId: (json['quotationId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      quantity: _decimalFromJson(json['quantity']),
      unitPrice: _decimalFromJson(json['unitPrice']),
      discountPercent: _decimalFromJson(json['discountPercent']),
      discountAmount: _decimalFromJson(json['discountAmount']),
      taxPercent: _decimalFromJson(json['taxPercent']),
      taxAmount: _decimalFromJson(json['taxAmount']),
      totalAmount: _decimalFromJson(json['totalAmount']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$QuotationItemToJson(QuotationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quotationId': instance.quotationId,
      'productId': instance.productId,
      'quantity': _decimalToJson(instance.quantity),
      'unitPrice': _decimalToJson(instance.unitPrice),
      'discountPercent': _decimalToJson(instance.discountPercent),
      'discountAmount': _decimalToJson(instance.discountAmount),
      'taxPercent': _decimalToJson(instance.taxPercent),
      'taxAmount': _decimalToJson(instance.taxAmount),
      'totalAmount': _decimalToJson(instance.totalAmount),
      'notes': instance.notes,
    };
