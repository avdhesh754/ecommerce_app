// lib/features/auth/domain/entities/user_entity.dart
import '../../../../core/enums/permissions.dart';
import '../../../../core/enums/user_role.dart';

class UserEntity {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final List<dynamic> roles;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.dateOfBirth,
    this.gender,
    required this.roles,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  // FIXED: Better role checking methods
  bool get isAdmin {
    print('Checking isAdmin with roles: $roles');
    final result = _hasRole('admin');
    print('isAdmin result: $result');
    return result;
  }

  bool get isSuperAdmin {
    print('Checking isSuperAdmin with roles: $roles');
    final result = _hasRole('super_admin') || _hasRole('superadmin');
    print('isSuperAdmin result: $result');
    return result;
  }

  bool get isCustomer {
    print('Checking isCustomer with roles: $roles');
    final result = _hasRole('customer') || roles.isEmpty;
    print('isCustomer result: $result');
    return result;
  }

  // Helper method to check if user has a specific role
  bool _hasRole(String roleName) {
    for (final role in roles) {
      if (role is String) {
        if (role.toLowerCase() == roleName.toLowerCase()) {
          return true;
        }
      } else if (role is Map<String, dynamic>) {
        final name = role['name'] as String?;
        if (name?.toLowerCase() == roleName.toLowerCase()) {
          return true;
        }
      }
    }
    return false;
  }

  String get fullName => '$firstName $lastName';

  // Helper method to get role names as strings
  List<String> get roleNames {
    return roles.map((role) {
      if (role is String) {
        return role;
      } else if (role is Map<String, dynamic>) {
        return role['name'] as String? ?? '';
      }
      return role.toString();
    }).where((name) => name.isNotEmpty).toList();
  }

  // Add primaryRole getter for compatibility
  UserRole get primaryRole {
    if (isSuperAdmin) return UserRole.superAdmin;
    if (isAdmin) return UserRole.admin;
    return UserRole.customer;
  }

  // Add permissions getter for compatibility
  List<Permission> get permissions {
    // Extract permissions from roles
    final List<Permission> allPermissions = [];

    for (final role in roles) {
      if (role is Map<String, dynamic> && role['permissions'] != null) {
        final rolePermissions = role['permissions'] as List<dynamic>;
        for (final perm in rolePermissions) {
          if (perm is Map<String, dynamic>) {
            final permissionName = perm['name'] as String?;
            if (permissionName != null) {
              final permission = _mapApiPermissionToEnum(permissionName);
              if (permission != null) {
                allPermissions.add(permission);
              }
            }
          }
        }
      }
    }

    // Super admin gets all permissions
    if (isSuperAdmin) {
      return Permission.values;
    }

    return allPermissions;
  }

  // Helper method to map API permission names to your enum values
  Permission? _mapApiPermissionToEnum(String apiPermissionName) {
    // Map API permission names to your enum format
    switch (apiPermissionName.toLowerCase()) {
    // Product permissions
      case 'read_product':
      case 'view_product':
        return Permission.productsRead;
      case 'create_product':
      case 'add_product':
        return Permission.productsWrite;
      case 'update_product':
      case 'edit_product':
        return Permission.productsWrite;
      case 'delete_product':
      case 'remove_product':
        return Permission.productsDelete;

    // User permissions
      case 'read_user':
      case 'view_user':
        return Permission.usersRead;
      case 'create_user':
      case 'add_user':
        return Permission.usersWrite;
      case 'update_user':
      case 'edit_user':
        return Permission.usersWrite;
      case 'delete_user':
      case 'remove_user':
        return Permission.usersDelete;

    // Order permissions
      case 'read_order':
      case 'view_order':
        return Permission.ordersRead;
      case 'create_order':
      case 'add_order':
        return Permission.ordersWrite;
      case 'update_order':
      case 'edit_order':
        return Permission.ordersWrite;
      case 'delete_order':
      case 'remove_order':
        return Permission.ordersDelete;

    // Role permissions
      case 'read_role':
      case 'view_role':
        return Permission.rolesRead;
      case 'create_role':
      case 'add_role':
        return Permission.rolesWrite;
      case 'update_role':
      case 'edit_role':
        return Permission.rolesWrite;
      case 'delete_role':
      case 'remove_role':
        return Permission.rolesWrite;

    // Permission permissions
      case 'read_permission':
      case 'view_permission':
        return Permission.permissionsRead;
      case 'create_permission':
      case 'add_permission':
        return Permission.permissionsWrite;
      case 'update_permission':
      case 'edit_permission':
        return Permission.permissionsWrite;
      case 'delete_permission':
      case 'remove_permission':
        return Permission.permissionsWrite;

    // Analytics permissions
      case 'view_analytics':
      case 'read_analytics':
        return Permission.analyticsRead;

    // Dashboard permissions
      case 'dashboard':
      case 'view_dashboard':
        return Permission.dashboardRead;

    // System admin (maps to admin management)
      case 'system_admin':
      case 'admin_management':
        return Permission.adminManagement;

      default:
        print('Unknown API permission: $apiPermissionName');
        return null;
    }
  }
}