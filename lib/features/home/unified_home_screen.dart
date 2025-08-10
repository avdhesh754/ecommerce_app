// lib/features/home/unified_home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/enums/user_role.dart';
import '../../core/utils/responsive_breakpoints.dart';
import '../auth/presentation/controllers/auth_controller.dart';
import '../admin/dashboard/super_admin_dashboard_screen.dart';
import '../admin/dashboard/permission_based_admin_dashboard.dart';
import '../customer/home/customer_home_screen.dart';
import '../auth/presentation/pages/login_page.dart';

class UnifiedHomeScreen extends StatelessWidget {
  const UnifiedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        // Check if user is authenticated
        if (!authController.isAuthenticated) {
          return const LoginPage();
        }

        final user = authController.currentUser.value;
        if (user == null) {
          return const LoginPage();
        }

        // Route based on primary role
        switch (user.primaryRole) {
          case UserRole.superAdmin:
            return const SuperAdminDashboardScreen();
          case UserRole.admin:
            return const PermissionBasedAdminDashboard();
          case UserRole.customer:
            return const CustomerHomeScreen();
          default:
            return const CustomerHomeScreen(); // Fallback
        }
      },
    );
  }
}

class RoleBasedLayout extends StatelessWidget {
  final Widget child;
  final UserRole requiredRole;
  final String? requiredPermission;

  const RoleBasedLayout({
    super.key,
    required this.child,
    required this.requiredRole,
    this.requiredPermission,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        final user = authController.currentUser.value;

        if (user == null) {
          return _buildUnauthorized(context, authController);
        }

        // Super admin bypasses all checks
        if (user.isSuperAdmin) {
          return child;
        }

        // Check role - Convert UserRole enum to string for comparison
        final userRoleNames = user.roleNames;
        final hasRequiredRole = userRoleNames.contains(requiredRole.value) ||
            userRoleNames.contains('super_admin');

        if (!hasRequiredRole) {
          return _buildUnauthorized(context, authController);
        }

        // Check permission if specified
        if (requiredPermission != null) {
          final hasPermission = user.permissions.any((p) => p.name == requiredPermission);
          if (!hasPermission) {
            return _buildUnauthorized(context, authController);
          }
        }

        return child;
      },
    );
  }

  Widget _buildUnauthorized(BuildContext context, AuthController authController) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: ResponsiveBreakpoints.getResponsiveIconSize(context, 64),
              color: Colors.grey,
            ),
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
            Text(
              'Access Denied',
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
            Text(
              "You don't have permission to access this resource",
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),
            ElevatedButton(
              onPressed: ()  {
                Get.back();
                authController.logout();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}