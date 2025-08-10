import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/permissions.dart';
import '../../../../core/utils/responsive_breakpoints.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: GetBuilder<AuthController>(
        builder: (authController) {
          final user = authController.currentUser.value;
          return Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 24)),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        user?.firstName.substring(0, 1).toUpperCase() ?? 'A',
                        style: TextStyle(
                          fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                    Text(
                      user?.fullName ?? 'Admin User',
                      style: TextStyle(
                        fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user?.primaryRole.displayName ?? 'Admin',
                      style: TextStyle(
                        fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Navigation Menu
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveBreakpoints.getResponsiveSize(context, 16)),
                  children: [
                    _buildMenuItem(context,
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      onTap: () => Get.toNamed('/admin/dashboard'),
                    ),
                    
                    // Products Section
                    if (user?.hasPermission(Permission.productsRead) ?? false) ...[
                      _buildMenuHeader(context, 'Products'),
                      _buildMenuItem(context,
                        icon: Icons.inventory,
                        title: 'All Products',
                        onTap: () => Get.toNamed('/admin/products'),
                        permission: Permission.productsRead,
                      ),
                      if (user?.hasPermission(Permission.productsWrite) ?? false)
                        _buildMenuItem(context,
                          icon: Icons.add_box,
                          title: 'Add Product',
                          onTap: () => Get.toNamed('/admin/products/create'),
                          permission: Permission.productsWrite,
                        ),
                      _buildMenuItem(context,
                        icon: Icons.category,
                        title: 'Categories',
                        onTap: () => Get.toNamed('/admin/categories'),
                        permission: Permission.categoriesRead,
                      ),
                    ],
                    
                    // Orders Section
                    if (user?.hasPermission(Permission.ordersRead) ?? false) ...[
                      _buildMenuHeader(context, 'Orders'),
                      _buildMenuItem(context,
                        icon: Icons.shopping_cart,
                        title: 'All Orders',
                        onTap: () => Get.toNamed('/admin/orders'),
                        permission: Permission.ordersRead,
                      ),
                      _buildMenuItem(context,
                        icon: Icons.pending_actions,
                        title: 'Pending Orders',
                        onTap: () => Get.toNamed('/admin/orders/pending'),
                        permission: Permission.ordersRead,
                      ),
                    ],
                    
                    // Users Section
                    if (user?.hasPermission(Permission.usersRead) ?? false) ...[
                      _buildMenuHeader(context, 'Users'),
                      _buildMenuItem(context,
                        icon: Icons.people,
                        title: 'All Users',
                        onTap: () => Get.toNamed('/admin/users'),
                        permission: Permission.usersRead,
                      ),
                    ],
                    
                    // Marketing Section
                    if ((user?.hasPermission(Permission.couponsRead) ?? false) ||
                        (user?.hasPermission(Permission.bannersRead) ?? false)) ...[
                      _buildMenuHeader(context, 'Marketing'),
                      if (user?.hasPermission(Permission.couponsRead) ?? false)
                        _buildMenuItem(context,
                          icon: Icons.local_offer,
                          title: 'Coupons',
                          onTap: () => Get.toNamed('/admin/coupons'),
                          permission: Permission.couponsRead,
                        ),
                      if (user?.hasPermission(Permission.bannersRead) ?? false)
                        _buildMenuItem(context,
                          icon: Icons.web_asset,
                          title: 'Banners',
                          onTap: () => Get.toNamed('/admin/banners'),
                          permission: Permission.bannersRead,
                        ),
                    ],
                    
                    // Analytics Section
                    if (user?.hasPermission(Permission.analyticsRead) ?? false) ...[
                      _buildMenuHeader(context, 'Analytics'),
                      _buildMenuItem(context,
                        icon: Icons.analytics,
                        title: 'Reports',
                        onTap: () => Get.toNamed('/admin/analytics'),
                        permission: Permission.analyticsRead,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Footer
              Container(
                padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(context,
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () => Get.toNamed('/admin/settings'),
                    ),
                    _buildMenuItem(context,
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: () => Get.toNamed('/admin/help'),
                    ),
                    _buildMenuItem(context,
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () => authController.logout(),
                      textColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveBreakpoints.getResponsiveSize(context, 16),
        vertical: ResponsiveBreakpoints.getResponsiveSize(context, 8),
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Permission? permission,
    Color? textColor,
  }) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        final user = authController.currentUser.value;
        
        // Check permission if specified
        if (permission != null && user != null && !user.hasPermission(permission)) {
          return const SizedBox.shrink();
        }

        return ListTile(
          leading: Icon(
            icon,
            size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
            color: textColor ?? Colors.grey[700],
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
              color: textColor ?? Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onTap,
          dense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveBreakpoints.getResponsiveSize(context, 16),
            vertical: ResponsiveBreakpoints.getResponsiveSize(context, 4),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          hoverColor: Colors.grey[100],
        );
      },
    );
  }
}