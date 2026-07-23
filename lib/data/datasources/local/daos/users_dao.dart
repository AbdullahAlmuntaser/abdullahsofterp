import 'package:bcrypt/bcrypt.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';

class UsersDao extends DatabaseAccessor<AppDatabase> {
  UsersDao(super.db);

  Future<List<User>> getAllUsers() => select(db.users).get();
  Stream<List<User>> watchAllUsers() => select(db.users).watch();
  Future<int> addUser(UsersCompanion user) => into(db.users).insert(user);
  Future<bool> updateUser(User user) => update(db.users).replace(user);
  Future<int> deleteUser(User user) => delete(db.users).delete(user);

  Future<int> createUser({
    required String username,
    required String password,
    required String role,
    required String fullName,
    String? id,
  }) async {
    final salt = BCrypt.gensalt();
    final hash = BCrypt.hashpw(password, salt);
    return into(db.users).insert(UsersCompanion.insert(
      id: id != null ? Value(id) : Value(const Uuid().v4()),
      fullName: fullName,
      username: username,
      password: hash,
      role: role,
      passwordHash: Value(hash),
      passwordSalt: Value(salt),
    ));
  }

  // Permission Checks
  Future<bool> hasPermission(String username, String permissionCode) async {
    final user = await (select(db.users)..where((u) => u.username.equals(username)))
        .getSingleOrNull();
    if (user == null) return false;
    if (user.role.toLowerCase() == 'admin') {
      return true; // Admin has all permissions
    }

    final query = select(db.rolePermissions)
      ..where(
        (rp) =>
            rp.role.equals(user.role) &
            rp.permissionCode.equals(permissionCode),
      );
    final result = await query.getSingleOrNull();
    return result != null;
  }

  // Permission Management
  Future<void> addPermission(PermissionsCompanion permission) =>
      into(db.permissions).insertOnConflictUpdate(permission);

  Future<void> assignPermissionToRole(String role, String permissionCode) =>
      into(db.rolePermissions).insert(
        RolePermissionsCompanion.insert(
          role: role,
          permissionCode: permissionCode,
        ),
      );

  Future<List<String>> getRolePermissions(String role) async {
    final query = select(db.rolePermissions)..where((rp) => rp.role.equals(role));
    final rows = await query.get();
    return rows.map((r) => r.permissionCode).toList();
  }

  Future<void> removePermissionFromRole(String role, String permissionCode) {
    return (delete(db.rolePermissions)
          ..where(
            (rp) =>
                rp.role.equals(role) & rp.permissionCode.equals(permissionCode),
          ))
        .go();
  }
}
