import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

enum PrinterConnectionType { bluetooth, usb, network }

class _NetworkPrinter {
  String name;
  String host;
  int port;

  _NetworkPrinter(this.name, this.host, this.port);
}

class ThermalPrinterService {
  static PrinterConnectionType _connectionType =
      PrinterConnectionType.network;
  static String? _connectedDeviceName;
  static bool _isConnected = false;
  static int _paperSize = 80;
  static Socket? _socket;
  static _NetworkPrinter? _networkPrinter;

  static bool get isConnected => _isConnected;
  static String? get connectedDeviceName => _connectedDeviceName;
  static PrinterConnectionType get connectionType => _connectionType;
  static int get paperSize => _paperSize;
  static String? get connectedHost => _networkPrinter?.host;
  static int? get connectedPort => _networkPrinter?.port;

  static void setConnectionType(PrinterConnectionType type) {
    _connectionType = type;
  }

  static void setPaperSize(int size) {
    _paperSize = size;
  }

  static Future<bool> connectToDevice({
    required String deviceName,
    PrinterConnectionType type = PrinterConnectionType.network,
    String? host,
    int port = 9100,
  }) async {
    try {
      await disconnect();
      _connectionType = type;
      _connectedDeviceName = deviceName;

      if (type == PrinterConnectionType.network) {
        if (host == null) return false;
        _socket = await Socket.connect(host, port,
            timeout: const Duration(seconds: 5));
        _networkPrinter = _NetworkPrinter(deviceName, host, port);
      }

      _isConnected = true;
      return true;
    } catch (e) {
      _isConnected = false;
      _connectedDeviceName = null;
      _socket = null;
      _networkPrinter = null;
      return false;
    }
  }

  static Future<void> disconnect() async {
    _isConnected = false;
    _connectedDeviceName = null;
    _networkPrinter = null;
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
  }

  static Future<List<Map<String, String>>> getAvailableDevices() async {
    return [
      {
        'name': 'Network Printer (port 9100)',
        'address': '192.168.1.100:9100',
        'type': 'network',
      },
      {
        'name': 'Network Printer (port 9100)',
        'address': '192.168.1.101:9100',
        'type': 'network',
      },
    ];
  }

  static Future<Uint8List> generateReceiptBytes({
    required Sale sale,
    required List<SaleItem> items,
    required List<Product> products,
    String? customerName,
    String? storeName,
    String? receiptFooter,
  }) async {
    final profile = await CapabilityProfile.load();
    final paper = _paperSize == 58 ? PaperSize.mm58 : PaperSize.mm80;
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    bytes += generator.setStyles(const PosStyles(
      align: PosAlign.center,
      bold: true,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
    ));
    bytes += generator.text(storeName ?? 'SUPERMARKET');
    bytes += generator.setStyles(const PosStyles(
      align: PosAlign.center,
      bold: false,
      height: PosTextSize.size1,
      width: PosTextSize.size1,
    ));
    bytes += generator.text('─' * (_paperSize == 58 ? 32 : 48));
    bytes += generator.text('رقم الفاتورة: ${sale.id.substring(0, 8)}');
    bytes += generator.text(
        'التاريخ: ${DateFormat("yyyy-MM-dd HH:mm").format(sale.createdAt)}');
    if (customerName != null) {
      bytes += generator.text('العميل: $customerName');
    }
    bytes += generator.text('─' * (_paperSize == 58 ? 32 : 48));

    bytes += generator.row([
      PosColumn(
          text: 'الصنف',
          width: _paperSize == 58 ? 4 : 6,
          styles: const PosStyles(bold: true)),
      PosColumn(text: 'الكمية', width: 2, styles: const PosStyles(bold: true)),
      PosColumn(text: 'السعر', width: 2, styles: const PosStyles(bold: true)),
      PosColumn(
          text: 'الإجمالي',
          width: _paperSize == 58 ? 4 : 4,
          styles: const PosStyles(bold: true)),
    ]);

    for (var item in items) {
      final product = products.firstWhere(
        (p) => p.id == item.productId,
        orElse: () => products.first,
      );
      bytes += generator.row([
        PosColumn(text: product.name, width: _paperSize == 58 ? 4 : 6),
        PosColumn(text: item.quantity.toString(), width: 2),
        PosColumn(text: item.price.toStringAsFixed(2), width: 2),
        PosColumn(
            text: (item.quantity * item.price).toStringAsFixed(2),
            width: _paperSize == 58 ? 4 : 4),
      ]);
    }

    bytes += generator.text('─' * (_paperSize == 58 ? 32 : 48));

    final subtotal = sale.total + sale.discount - sale.tax;
    bytes += generator.text(
      'المجموع الفرعي: ${subtotal.toStringAsFixed(2)}',
      styles: const PosStyles(align: PosAlign.right),
    );
    if (sale.discount > Decimal.zero) {
      bytes += generator.text(
        'الخصم: ${sale.discount.toStringAsFixed(2)}',
        styles: const PosStyles(align: PosAlign.right),
      );
    }
    if (sale.tax > Decimal.zero) {
      bytes += generator.text(
        'الضريبة: ${sale.tax.toStringAsFixed(2)}',
        styles: const PosStyles(align: PosAlign.right),
      );
    }
    bytes += generator.text(
      'الإجمالي: ${sale.total.toStringAsFixed(2)}',
      styles: const PosStyles(
        align: PosAlign.right,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.text('─' * (_paperSize == 58 ? 32 : 48));
    bytes += generator.text(
      receiptFooter ?? 'شكراً لتسوقكم معنا!',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(2);
    bytes += generator.cut();

    return Uint8List.fromList(bytes);
  }

  static Future<void> printReceipt({
    required Sale sale,
    required List<SaleItem> items,
    required List<Product> products,
    String? customerName,
    String? storeName,
  }) async {
    final bytes = await generateReceiptBytes(
      sale: sale,
      items: items,
      products: products,
      customerName: customerName,
      storeName: storeName,
    );

    if (_isConnected) {
      await _sendToPrinter(bytes);
    }
  }

  static Future<void> printBarcodeLabel({
    required String productName,
    required String barcode,
    required String price,
    int copies = 1,
  }) async {
    final profile = await CapabilityProfile.load();
    final paper = _paperSize == 58 ? PaperSize.mm58 : PaperSize.mm80;
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    for (int i = 0; i < copies; i++) {
      bytes += generator.setStyles(const PosStyles(
        align: PosAlign.center,
        bold: true,
      ));
      bytes += generator.text(productName,
          styles: const PosStyles(align: PosAlign.center));
      bytes += generator.barcode(Barcode.code128(barcode.codeUnits));
      bytes += generator.text(barcode,
          styles: const PosStyles(
              align: PosAlign.center, height: PosTextSize.size1));
      bytes += generator.text(price,
          styles: const PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
          ));
      bytes += generator.feed(1);
    }
    bytes += generator.cut();

    if (_isConnected) {
      await _sendToPrinter(Uint8List.fromList(bytes));
    }
  }

  static Future<void> _sendToPrinter(Uint8List bytes) async {
    try {
      switch (_connectionType) {
        case PrinterConnectionType.network:
          if (_socket != null) {
            _socket!.add(bytes);
            await _socket!.flush();
          } else {
            throw Exception('Socket not connected');
          }
          break;
        case PrinterConnectionType.bluetooth:
        case PrinterConnectionType.usb:
          throw UnimplementedError(
              '$_connectionType requires flutter_bluetooth_serial or native USB plugin');
      }
    } catch (e) {
      if (e is UnimplementedError) rethrow;
      throw Exception('فشل في إرسال البيانات للطابعة: $e');
    }
  }

  static Future<void> printText(String text,
      {bool bold = false, PosAlign align = PosAlign.center}) async {
    final profile = await CapabilityProfile.load();
    final paper = _paperSize == 58 ? PaperSize.mm58 : PaperSize.mm80;
    final generator = Generator(paper, profile);
    final bytes =
        generator.text(text, styles: PosStyles(bold: bold, align: align));

    if (_isConnected) {
      await _sendToPrinter(Uint8List.fromList(bytes));
    }
  }

  static Future<void> cutPaper() async {
    final profile = await CapabilityProfile.load();
    final paper = _paperSize == 58 ? PaperSize.mm58 : PaperSize.mm80;
    final generator = Generator(paper, profile);
    final bytes = generator.cut();

    if (_isConnected) {
      await _sendToPrinter(Uint8List.fromList(bytes));
    }
  }
}
