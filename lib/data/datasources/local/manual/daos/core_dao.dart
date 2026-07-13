import 'package:supermarket/data/datasources/local/manual/manual_database.dart';
import 'package:supermarket/data/datasources/local/manual/entities.dart';
import 'package:uuid/uuid.dart';

class CoreDao {
  final ManualDatabase _db;
  CoreDao(this._db);

  // ==================== USERS ====================
  Future<List<AppUser>> getAllUsers() async {
    final rows = _db.query('SELECT * FROM users ORDER BY full_name');
    return rows.map((r) => AppUser.fromMap(r)).toList();
  }

  Future<AppUser?> getUserById(String id) async {
    final rows = _db.query('SELECT * FROM users WHERE id = ?', [id]);
    return rows.isEmpty ? null : AppUser.fromMap(rows.first);
  }

  Future<AppUser?> getUserByUsername(String username) async {
    final rows = _db.query('SELECT * FROM users WHERE username = ?', [username]);
    return rows.isEmpty ? null : AppUser.fromMap(rows.first);
  }

  Future<String> insertUser({
    required String username,
    required String password,
    required String role,
    required String fullName,
    String? passwordHash,
    String? passwordSalt,
    String? branchId,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO users (id, username, password, role, full_name, password_hash, password_salt, branch_id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [id, username, password, role, fullName, passwordHash, passwordSalt, branchId]);
    return id;
  }

  Future<void> updateUser(AppUser user) async {
    _db.execute('''
      UPDATE users SET username=?, password=?, role=?, full_name=?, password_hash=?, password_salt=?, branch_id=?, updated_at=datetime('now')
      WHERE id=?
    ''', [user.username, user.password, user.role, user.fullName,
          user.passwordHash, user.passwordSalt, user.branchId, user.id]);
  }

  Future<void> deleteUser(String id) async {
    _db.execute('DELETE FROM users WHERE id = ?', [id]);
  }

  Future<bool> hasPermission(String username, String permissionCode) async {
    final rows = _db.query('''
      SELECT u.role FROM users u WHERE u.username = ?
    ''', [username]);
    if (rows.isEmpty) return false;
    if (rows.first['role'] == 'admin') return true;
    final perms = _db.query('''
      SELECT 1 FROM role_permissions rp
      JOIN users u ON u.role = rp.role
      WHERE u.username = ? AND rp.permission_code = ?
    ''', [username, permissionCode]);
    return perms.isNotEmpty;
  }

  // ==================== PERMISSIONS ====================
  Future<void> addPermission(String code, String? description) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO permissions (id, code, description) VALUES (?, ?, ?)',
        [id, code, description]);
  }

  Future<void> assignPermissionToRole(String role, String permissionCode) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO role_permissions (id, role, permission_code) VALUES (?, ?, ?)',
        [id, role, permissionCode]);
  }

  Future<List<String>> getRolePermissions(String role) async {
    final rows = _db.query('SELECT permission_code FROM role_permissions WHERE role = ?', [role]);
    return rows.map((r) => r['permission_code'] as String).toList();
  }

  Future<void> removePermissionFromRole(String role, String permissionCode) async {
    _db.execute('DELETE FROM role_permissions WHERE role = ? AND permission_code = ?',
        [role, permissionCode]);
  }

  // ==================== BRANCHES ====================
  Future<List<Branch>> getAllBranches() async {
    final rows = _db.query('SELECT * FROM branches ORDER BY name');
    return rows.map((r) => Branch.fromMap(r)).toList();
  }

  Future<Branch?> getBranchById(String id) async {
    final rows = _db.query('SELECT * FROM branches WHERE id = ?', [id]);
    return rows.isEmpty ? null : Branch.fromMap(rows.first);
  }

  Future<String> insertBranch(String name, String code, {String? address, String? phone}) async {
    final id = const Uuid().v4();
    _db.execute('INSERT INTO branches (id, name, code, address, phone) VALUES (?, ?, ?, ?, ?)',
        [id, name, code, address, phone]);
    return id;
  }

  // ==================== AUDIT LOGS ====================
  Future<void> insertAuditLog({
    required String action,
    required String targetEntity,
    required String entityId,
    String? userId,
    String? details,
  }) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO audit_logs (id, user_id, action, target_entity, entity_id, details)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [id, userId, action, targetEntity, entityId, details]);
  }

  Future<List<AuditLog>> getAuditLogs({String? targetEntity, int limit = 100}) async {
    String sql = 'SELECT * FROM audit_logs';
    final params = <Object?>[];
    if (targetEntity != null) {
      sql += ' WHERE target_entity = ?';
      params.add(targetEntity);
    }
    sql += ' ORDER BY timestamp DESC LIMIT ?';
    params.add(limit);
    final rows = _db.query(sql, params);
    return rows.map((r) => AuditLog.fromMap(r)).toList();
  }

  // ==================== SYNC QUEUE ====================
  Future<void> addToSyncQueue(String table, String entityId, String operation,
      {String? payload}) async {
    final id = const Uuid().v4();
    _db.execute('''
      INSERT INTO sync_queue (id, entity_table, entity_id, operation, payload)
      VALUES (?, ?, ?, ?, ?)
    ''', [id, table, entityId, operation, payload]);
  }

  Future<List<SyncQueueItem>> getPendingSyncItems() async {
    final rows = _db.query('SELECT * FROM sync_queue WHERE status = 0 ORDER BY created_at');
    return rows.map((r) => SyncQueueItem.fromMap(r)).toList();
  }

  Future<void> markSyncDone(String id) async {
    _db.execute('UPDATE sync_queue SET status = 1 WHERE id = ?', [id]);
  }

  // ==================== APP SETTINGS ====================
  Future<AppSetting?> getSetting(String key) async {
    final rows = _db.query('SELECT * FROM app_settings WHERE key = ?', [key]);
    return rows.isEmpty ? null : AppSetting.fromMap(rows.first);
  }

  Future<void> putSetting(String key, String value, {String? groupName}) async {
    final existing = await getSetting(key);
    if (existing != null) {
      _db.execute('UPDATE app_settings SET value = ? WHERE key = ?', [value, key]);
    } else {
      final id = const Uuid().v4();
      _db.execute('INSERT INTO app_settings (id, key, value, group_name) VALUES (?, ?, ?, ?)',
          [id, key, value, groupName]);
    }
  }
}
