enum Permission {
  // Product permissions
  productsRead('products:read'),
  productsWrite('products:write'),
  productsDelete('products:delete'),
  
  // Category permissions
  categoriesRead('categories:read'),
  categoriesWrite('categories:write'),
  categoriesDelete('categories:delete'),
  
  // User permissions
  usersRead('users:read'),
  usersWrite('users:write'),
  usersDelete('users:delete'),
  
  // Order permissions
  ordersRead('orders:read'),
  ordersWrite('orders:write'),
  ordersDelete('orders:delete'),
  
  // Dashboard permissions
  dashboardRead('dashboard:read'),
  
  // Role & Permission management
  rolesRead('roles:read'),
  rolesWrite('roles:write'),
  permissionsRead('permissions:read'),
  permissionsWrite('permissions:write'),
  
  // Admin management (super admin only)
  adminManagement('admin:management'),
  
  // Coupon permissions
  couponsRead('coupons:read'),
  couponsWrite('coupons:write'),
  couponsDelete('coupons:delete'),
  
  // Banner permissions
  bannersRead('banners:read'),
  bannersWrite('banners:write'),
  bannersDelete('banners:delete'),
  
  // Analytics permissions
  analyticsRead('analytics:read');

  const Permission(this.value);
  final String value;

  static Permission? fromString(String value) {
    for (final permission in Permission.values) {
      if (permission.value == value) {
        return permission;
      }
    }
    return null;
  }

  String get displayName {
    final parts = value.split(':');
    final resource = parts[0];
    final action = parts[1];
    
    return '${_capitalize(resource)} ${_capitalize(action)}';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class PermissionGroup {
  final String name;
  final List<Permission> permissions;
  final String description;

  const PermissionGroup({
    required this.name,
    required this.permissions,
    required this.description,
  });

  static const List<PermissionGroup> groups = [
    PermissionGroup(
      name: 'Products',
      description: 'Manage products and inventory',
      permissions: [
        Permission.productsRead,
        Permission.productsWrite,
        Permission.productsDelete,
      ],
    ),
    PermissionGroup(
      name: 'Categories',
      description: 'Manage product categories',
      permissions: [
        Permission.categoriesRead,
        Permission.categoriesWrite,
        Permission.categoriesDelete,
      ],
    ),
    PermissionGroup(
      name: 'Users',
      description: 'Manage customer accounts',
      permissions: [
        Permission.usersRead,
        Permission.usersWrite,
        Permission.usersDelete,
      ],
    ),
    PermissionGroup(
      name: 'Orders',
      description: 'Manage customer orders',
      permissions: [
        Permission.ordersRead,
        Permission.ordersWrite,
        Permission.ordersDelete,
      ],
    ),
    PermissionGroup(
      name: 'Marketing',
      description: 'Manage coupons and banners',
      permissions: [
        Permission.couponsRead,
        Permission.couponsWrite,
        Permission.couponsDelete,
        Permission.bannersRead,
        Permission.bannersWrite,
        Permission.bannersDelete,
      ],
    ),
    PermissionGroup(
      name: 'Analytics',
      description: 'View dashboard and analytics',
      permissions: [
        Permission.dashboardRead,
        Permission.analyticsRead,
      ],
    ),
    PermissionGroup(
      name: 'Administration',
      description: 'Role and permission management',
      permissions: [
        Permission.rolesRead,
        Permission.rolesWrite,
        Permission.permissionsRead,
        Permission.permissionsWrite,
      ],
    ),
  ];
}