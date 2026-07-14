import 'dart:convert';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:uuid/uuid.dart';

class CustomRole {
  final String id;
  String name;
  List<String> permissions;
  bool isActive;

  CustomRole({
    required this.id,
    required this.name,
    required this.permissions,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'permissions': permissions,
        'isActive': isActive,
      };

  factory CustomRole.fromJson(Map<String, dynamic> json) => CustomRole(
        id: json['id'] as String,
        name: json['name'] as String,
        permissions: (json['permissions'] as List<dynamic>).cast<String>(),
        isActive: json['isActive'] as bool? ?? true,
      );
}

class RoleService {
  final AppConfigService _configService;

  RoleService(this._configService);

  static const String _rolesKey = 'custom_roles';

  Future<List<CustomRole>> getAllRoles() async {
    final raw = await _configService.getString(_rolesKey);
    if (raw == null || raw.isEmpty) return _defaultRoles();
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((r) => CustomRole.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<CustomRole?> getRole(String id) async {
    final roles = await getAllRoles();
    try {
      return roles.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> createRole(String name, List<String> permissions) async {
    final roles = await getAllRoles();
    roles.add(CustomRole(
      id: const Uuid().v4(),
      name: name,
      permissions: permissions,
    ));
    await _saveRoles(roles);
  }

  Future<void> updateRole(String id, {String? name, List<String>? permissions}) async {
    final roles = await getAllRoles();
    final idx = roles.indexWhere((r) => r.id == id);
    if (idx == -1) throw Exception('Role not found');
    if (name != null) roles[idx].name = name;
    if (permissions != null) roles[idx].permissions = permissions;
    await _saveRoles(roles);
  }

  Future<void> deleteRole(String id) async {
    final roles = await getAllRoles();
    roles.removeWhere((r) => r.id == id);
    await _saveRoles(roles);
  }

  Future<bool> hasPermission(String roleId, String permission) async {
    final role = await getRole(roleId);
    return role?.permissions.contains(permission) ?? false;
  }

  List<CustomRole> _defaultRoles() => [
        CustomRole(
          id: 'admin',
          name: 'مدير النظام',
          permissions: [
            'POST_SALE', 'POST_PURCHASE', 'POST_SALE_RETURN', 'POST_PURCHASE_RETURN',
            'DELETE_INVOICE', 'VOID_TRANSACTION', 'MANAGE_USERS', 'VIEW_REPORTS',
            'MANAGE_SETTINGS', 'MANAGE_INVENTORY', 'APPROVE_DISCOUNT', 'EDIT_TAX',
            'MANAGE_ROLES', 'VIEW_ACCOUNTING', 'MANAGE_HR',
          ],
        ),
        CustomRole(
          id: 'manager',
          name: 'مدير',
          permissions: [
            'POST_SALE', 'POST_PURCHASE', 'POST_SALE_RETURN', 'POST_PURCHASE_RETURN',
            'VIEW_REPORTS', 'MANAGE_INVENTORY', 'APPROVE_DISCOUNT',
          ],
        ),
        CustomRole(
          id: 'cashier',
          name: 'كاشير',
          permissions: ['POST_SALE', 'POST_SALE_RETURN'],
        ),
        CustomRole(
          id: 'accountant',
          name: 'محاسب',
          permissions: [
            'POST_PURCHASE', 'VIEW_REPORTS', 'MANAGE_INVENTORY', 'VIEW_ACCOUNTING',
          ],
        ),
      ];

  Future<void> _saveRoles(List<CustomRole> roles) async {
    await _configService.setString(
        _rolesKey, jsonEncode(roles.map((r) => r.toJson()).toList()));
  }
}
