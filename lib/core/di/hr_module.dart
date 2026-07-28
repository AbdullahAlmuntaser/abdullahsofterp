import 'package:get_it/get_it.dart';
import 'package:supermarket/core/services/hr/hr_service.dart';
import 'package:supermarket/core/services/hr/attendance_service.dart';
import 'package:supermarket/core/services/hr/leave_management_service.dart';
import 'package:supermarket/core/services/hr/payroll_service.dart';
import 'package:supermarket/core/services/hr/shift_service.dart';
import 'package:supermarket/core/services/hr/auto_break_service.dart';
import 'package:supermarket/core/services/hr/eosb_service.dart';
import 'package:supermarket/core/services/packaging_engine.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

void registerHRModule(GetIt sl) {
  final db = sl<AppDatabase>();

  sl.registerLazySingleton<HRService>(() => HRService(db));
  sl.registerLazySingleton<AttendanceService>(
    () => AttendanceService(db),
  );
  sl.registerLazySingleton<LeaveManagementService>(
    () => LeaveManagementService(db),
  );
  sl.registerLazySingleton<PayrollService>(() => PayrollService(db));
  sl.registerLazySingleton<ShiftService>(() => ShiftService(db));
  sl.registerLazySingleton<EndOfServiceBenefitService>(() => EndOfServiceBenefitService(db));
  sl.registerLazySingleton<AutoBreakService>(
    () => AutoBreakService(db, sl<PackagingEngine>()),
  );
}
