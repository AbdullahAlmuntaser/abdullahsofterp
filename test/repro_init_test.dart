import 'package:flutter_test/flutter_test.dart';
import 'package:supermarket/core/services/security_service.dart';
import 'package:supermarket/injection_container.dart' as di;
import 'package:supermarket/presentation/features/accounting/accounting_provider.dart';
import 'package:supermarket/presentation/features/purchases/purchase_provider.dart';
import 'package:supermarket/presentation/features/accounting/shifts_provider.dart';
import 'package:supermarket/presentation/features/hr/hr_provider.dart';
import 'package:supermarket/presentation/features/hr/payroll_provider.dart';
import 'package:supermarket/presentation/features/inventory/stock_transfer_provider.dart';
import 'package:supermarket/presentation/features/accounting/asset_provider.dart';
import 'package:supermarket/presentation/features/customers/customer_statement_provider.dart';
import 'package:supermarket/presentation/features/dashboard/dashboard_provider.dart';
import 'package:supermarket/presentation/features/home/providers/command_center_provider.dart';
import 'package:supermarket/presentation/features/products/products_provider.dart';
import 'package:supermarket/presentation/features/sales/credit_note_provider.dart';
import 'package:supermarket/presentation/features/sales/commission_provider.dart';
import 'package:supermarket/presentation/features/accounting/wht_provider.dart';
import 'package:supermarket/presentation/features/hr/attendance_provider.dart';
import 'package:supermarket/presentation/features/hr/leave_provider.dart';
import 'package:supermarket/presentation/features/inventory/serial_number_provider.dart';

void main() {
  setUpAll(() {
    SecurityService.useFakeKeyForTesting = true;
  });

  test('repro: trigger ALL lazy factories including create callbacks', () async {
    await di.init();

    di.sl<AccountingProvider>();
    di.sl<ProductsProvider>();
    di.sl<PurchaseProvider>();
    di.sl<ShiftProvider>();
    di.sl<HRProvider>();
    di.sl<PayrollProvider>();
    di.sl<StockTransferProvider>();
    di.sl<AssetProvider>();
    di.sl<CustomerStatementProvider>();
    di.sl<DashboardProvider>();
    di.sl<CommandCenterProvider>();
    di.sl<CreditNoteProvider>();
    di.sl<WhtProvider>();
    di.sl<CommissionProvider>();
    di.sl<AttendanceProvider>();
    di.sl<LeaveProvider>();
    di.sl<SerialNumberProvider>();
  }, timeout: const Timeout(Duration(seconds: 60)));
}
