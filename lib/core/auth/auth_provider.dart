import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart' hide UserSession;
import 'package:supermarket/core/services/security_service.dart' show SecurityService, UserSession;
import 'package:supermarket/core/services/permission_service.dart';

class AuthProvider with ChangeNotifier {
  final AppDatabase db;
  final PermissionService permissionsService;
  final SecurityService securityService;
  UserSession? _currentSession;
  String? _currentToken;

  AuthProvider(this.db, this.permissionsService, this.securityService);

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isAuthenticated => _currentSession != null;
  bool get isAdmin =>
      _currentSession?.role.toLowerCase() == 'admin';
  bool get isManager =>
      isAdmin || _currentSession?.role.toLowerCase() == 'manager';
  bool get isCashier =>
      isManager || _currentSession?.role.toLowerCase() == 'cashier';

  Future<bool> login(String username, String password) async {
    try {
      final session = await securityService.login(username, password);
      if (session != null) {
        _currentSession = session;
        _currentToken = session.token;
        _currentUser = await (db.select(db.users)
              ..where((u) => u.id.equals(session.userId)))
            .getSingleOrNull();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _currentSession = null;
      _currentToken = null;
      _currentUser = null;
      rethrow;
    }
  }

  Future<void> logout() async {
    if (_currentToken != null) {
      await securityService.logout(_currentToken!);
    }
    _currentSession = null;
    _currentToken = null;
    notifyListeners();
  }

  Future<bool> hasUsers() async {
    final users = await db.select(db.users).get();
    return users.isNotEmpty;
  }

  Future<void> createInitialAdmin({
    required String username,
    required String password,
    required String fullName,
  }) async {
    if (await hasUsers()) {
      throw Exception('Initial admin user already exists.');
    }

    if (username.trim().isEmpty) {
      throw Exception('Admin username is required.');
    }

    if (password.length < 8) {
      throw Exception('Admin password must be at least 8 characters.');
    }

    final salt = securityService.generateSalt();
    final hashedPassword = securityService.hashPassword(password, salt);
    await db.into(db.users).insert(
          UsersCompanion.insert(
            username: username.trim(),
            password: hashedPassword,
            role: 'admin',
            fullName:
                fullName.trim().isEmpty ? 'System Admin' : fullName.trim(),
            passwordHash: Value(hashedPassword),
            passwordSalt: Value(salt),
          ),
        );

    await db.seedSecurityData();
  }

  // Backward-compatible entry point for existing callers/tests.
  // It now only ensures security metadata and never creates a weak default user.
  Future<void> seedAdmin() async {
    await db.seedSecurityData();
  }
}
