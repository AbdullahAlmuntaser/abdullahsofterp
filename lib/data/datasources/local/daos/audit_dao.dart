import 'package:drift/drift.dart';
import '../app_database.dart';

class AuditDao extends DatabaseAccessor<AppDatabase> {
  AuditDao(super.db);

  Future<int> insertLog(AuditLogsCompanion entry) =>
      into(db.auditLogs).insert(entry);
}
