import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/enums/permissions.dart';
import '../../../core/enums/user_role.dart';
import '../../../shared/widgets/responsive_customer_layout.dart';
import '../../../core/utils/responsive_breakpoints.dart';
import '../../../features/home/unified_home_screen.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'widgets/dashboard_stats_grid.dart';
import 'widgets/recent_orders_card.dart';
import 'widgets/top_products_card.dart';
import 'widgets/revenue_chart_card.dart';

class PermissionBasedAdminDashboard extends StatelessWidget {
  const PermissionBasedAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleBasedLayout(
      requiredRole: UserRole.admin,
      child: GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (controller) {
          return ResponsiveCustomerLayout(
            body: _buildDashboardContent(controller, context),
            currentRoute: '/admin/dashboard',
            title: 'Admin Dashboard',
            selectedIndex: 0,
          );
        },
      ),
    );
  }

  Widget _buildDashboardContent(DashboardController controller, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshDashboard,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          _buildUserMenu(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: SingleChildScrollView(
          padding: ResponsiveBreakpoints.getResponsivePadding(context, base: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context),
              SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),
              
              // Dashboard Stats (only if has dashboard permission)
              _buildPermissionBasedWidget(
                Permission.dashboardRead,
                const DashboardStatsGrid(),
              ),
              
              SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),
              
              // Charts and Analytics
              _buildPermissionBasedWidget(
                Permission.analyticsRead,
                const RevenueChartCard(),
              ),
              
              SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),
              
              // Recent Orders and Top Products
              ResponsiveBreakpoints.isDesktop(context)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildPermissionBasedWidget(
                            Permission.ordersRead,
                            const RecentOrdersCard(),
                          ),
                        ),
                        SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                        Expanded(
                          child: _buildPermissionBasedWidget(
                            Permission.productsRead,
                            const TopProductsCard(),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildPermissionBasedWidget(
                          Permission.ordersRead,
                          const RecentOrdersCard(),
                        ),
                        SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                        _buildPermissionBasedWidget(
                          Permission.productsRead,
                          const TopProductsCard(),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        final user = authController.currentUser.value;
        return Container(
          width: double.infinity,
          padding: ResponsiveBreakpoints.getResponsivePadding(context, base: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: ResponsiveBreakpoints.getResponsiveBorderRadius(context, 12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${user?.firstName ?? 'Admin'}!',
                style: ResponsiveBreakpoints.getResponsiveTextStyle(
                  context,
                  baseFontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
              Text(
                'Here\'s what\'s happening with your store today.',
                style: ResponsiveBreakpoints.getResponsiveTextStyle(
                  context,
                  baseFontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
              Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
                  ),
                  SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
                  Text(
                    'Admin Dashboard',
                    style: ResponsiveBreakpoints.getResponsiveTextStyle(
                      context,
                      baseFontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPermissionBasedWidget(Permission permission, Widget widget) {
    return Builder(
      builder: (context) => GetBuilder<AuthController>(
        builder: (controller) {
          final hasPermission = controller.hasPermission(permission as String);
          
          if (!hasPermission) {
            return Container(
              padding: ResponsiveBreakpoints.getResponsivePadding(context, base: 24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.security,
                  size: ResponsiveBreakpoints.getResponsiveIconSize(context, 48),
                  color: Colors.grey[400],
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                Text(
                  'Access Restricted',
                  style: ResponsiveBreakpoints.getResponsiveTextStyle(
                    context,
                    baseFontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
                Text(
                  'You don\'t have permission to view this section.',
                  style: ResponsiveBreakpoints.getResponsiveTextStyle(
                    context,
                    baseFontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
          
          return widget;
        },
      ),
    );
  }

  Widget _buildUserMenu() {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                Get.toNamed('/profile');
                break;
              case 'settings':
                Get.toNamed('/settings');
                break;
              case 'logout':
                controller.logout();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        );
      },
    );
  }

}