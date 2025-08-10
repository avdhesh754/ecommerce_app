import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/utils/responsive_breakpoints.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import 'controllers/super_admin_controller.dart';
import 'widgets/quick_actions_section.dart';

// Professional Custom AppBar with Responsive Design
class ProfessionalAppBar extends StatelessWidget {
  final String userName;
  final String? userImage;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const ProfessionalAppBar({
    super.key,
    required this.userName,
    this.userImage,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {

    final authcontroller = Get.find<AuthController>();

    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ResponsiveBreakpoints.getResponsiveSize(context, 24),
        ResponsiveBreakpoints.getResponsiveSize(context, 60),
        ResponsiveBreakpoints.getResponsiveSize(context, 24),
        ResponsiveBreakpoints.getResponsiveSize(context, 24),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF8FAFC),
            Colors.white,
            const Color(0xFFF1F5F9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 20),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Professional Profile Avatar
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: ResponsiveBreakpoints.getResponsiveSize(context, 56),
              height: ResponsiveBreakpoints.getResponsiveSize(context, 56),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 12),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: userImage != null
                    ? Image.network(
                  userImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildInitialAvatar(context),
                )
                    : _buildInitialAvatar(context),
              ),
            ),
          ),

          SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 20)),

          // Professional Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Good ${_getTimeGreeting()},',
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 2)),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 24),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Notification Bell with Badge
          GestureDetector(
            onTap: onNotificationTap,
            child: Container(
              width: ResponsiveBreakpoints.getResponsiveSize(context, 48),
              height: ResponsiveBreakpoints.getResponsiveSize(context, 48),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 12),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_outlined,
                      color: const Color(0xFF475569),
                      size: ResponsiveBreakpoints.getResponsiveIconSize(context, 22),
                    ),
                  ),
                  // Notification Badge
                  Positioned(
                    top: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                    right: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                    child: Container(
                      width: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                      height: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          IconButton(
            onPressed: (){
              authcontroller.logout();
            },icon: Icon(SolarIconsOutline.logout, color: Colors.black,))
        ],
      ),
    );
  }

  Widget _buildInitialAvatar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
      ),
      child: Center(
        child: Text(
          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 24),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

// Professional Stats Card with Enhanced Design
class ProfessionalStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double? trend;
  final String? subtitle;

  const ProfessionalStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveBreakpoints.getResponsiveRadius(context, 16),
        ),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 12),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveBreakpoints.getResponsiveSize(context, 12),
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveBreakpoints.getResponsiveRadius(context, 12),
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveBreakpoints.getResponsiveIconSize(context, 24),
                ),
              ),
              if (trend != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                    vertical: ResponsiveBreakpoints.getResponsiveSize(context, 4),
                  ),
                  decoration: BoxDecoration(
                    color: trend! >= 0
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : const Color(0xFFEF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveBreakpoints.getResponsiveRadius(context, 8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trend! >= 0 ? Icons.trending_up : Icons.trending_down,
                        size: ResponsiveBreakpoints.getResponsiveIconSize(context, 12),
                        color: trend! >= 0
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                      SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 2)),
                      Text(
                        '${trend!.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 10),
                          fontWeight: FontWeight.w600,
                          color: trend! >= 0
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 32),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 4)),
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
              letterSpacing: 0.1,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 2)),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Professional Section Card
class ProfessionalSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? action;
  final EdgeInsets? padding;

  const ProfessionalSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.action,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(
        ResponsiveBreakpoints.getResponsiveSize(context, 24),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveBreakpoints.getResponsiveRadius(context, 16),
        ),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 12),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              if (action != null) action!,
            ],
          ),
          SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 20)),
          child,
        ],
      ),
    );
  }
}

class SuperAdminDashboardScreen extends StatelessWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuperAdminController>(
      init: SuperAdminController(),
      builder: (controller) {
        return _buildDashboardContent(controller, context);
      },
    );
  }

  Widget _buildStatsGrid(SuperAdminController controller, BuildContext context) {
    return Obx(() {
      return GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: ResponsiveBreakpoints.getGridColumnCount(
          context,
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 4,
        ),
        crossAxisSpacing: ResponsiveBreakpoints.getResponsiveSpacing(context, 10),
        mainAxisSpacing: ResponsiveBreakpoints.getResponsiveSpacing(context, 10),
        childAspectRatio: ResponsiveBreakpoints.isMobile(context) ? 1.7 : 1.3,
        children: [
          ProfessionalStatsCard(
            title: 'Total Users',
            value: controller.dashboardStats.value.totalUsers.toString(),
            icon: Icons.people_outline,
            color: const Color(0xFF3B82F6),
            trend: controller.dashboardStats.value.userGrowth,
            subtitle: 'Active users',
          ),
          ProfessionalStatsCard(
            title: 'Active Admins',
            value: controller.dashboardStats.value.activeAdmins.toString(),
            icon: Icons.admin_panel_settings_outlined,
            color: const Color(0xFF10B981),
            trend: 0.0,
            subtitle: 'System administrators',
          ),
          ProfessionalStatsCard(
            title: 'Total Orders',
            value: controller.dashboardStats.value.totalOrders.toString(),
            icon: Icons.shopping_cart_outlined,
            color: const Color(0xFFF59E0B),
            trend: controller.dashboardStats.value.orderGrowth,
            subtitle: 'This month',
          ),
          ProfessionalStatsCard(
            title: 'Revenue',
            value: '\$${controller.dashboardStats.value.totalRevenue.toStringAsFixed(0)}',
            icon: Icons.attach_money_outlined,
            color: const Color(0xFF8B5CF6),
            trend: controller.dashboardStats.value.revenueGrowth,
            subtitle: 'Total earnings',
          ),
        ],
      );
    });
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return ProfessionalSectionCard(
      title: 'Quick Actions',
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: ResponsiveBreakpoints.getGridColumnCount(
          context,
          mobileColumns: 2,
          tabletColumns: 3,
          desktopColumns: 6,
        ),
        crossAxisSpacing: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
        mainAxisSpacing: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
        childAspectRatio: 1.1,
        children: [
          QuickActionButton(
            label: 'Create Admin',
            icon: Icons.person_add_outlined,
            color: const Color(0xFF3B82F6),
            onPressed: () => Get.snackbar('Action', 'Create Admin clicked'),
            isPrimary: true,
          ),
          QuickActionButton(
            label: 'System Backup',
            icon: Icons.backup_outlined,
            color: const Color(0xFF10B981),
            onPressed: () => Get.snackbar('Action', 'System Backup clicked'),
          ),
          QuickActionButton(
            label: 'View Logs',
            icon: Icons.description_outlined,
            color: const Color(0xFFF59E0B),
            onPressed: () => Get.snackbar('Action', 'View Logs clicked'),
          ),
          QuickActionButton(
            label: 'Security Audit',
            icon: Icons.security_outlined,
            color: const Color(0xFFEF4444),
            onPressed: () => Get.snackbar('Action', 'Security Audit clicked'),
          ),
          QuickActionButton(
            label: 'Broadcast',
            icon: Icons.campaign_outlined,
            color: const Color(0xFF8B5CF6),
            onPressed: () => Get.snackbar('Action', 'Broadcast clicked'),
          ),
          QuickActionButton(
            label: 'Settings',
            icon: Icons.settings_outlined,
            color: const Color(0xFF64748B),
            onPressed: () => Get.snackbar('Action', 'Settings clicked'),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemOverviewSection(SuperAdminController controller, BuildContext context) {
    return Obx(() {
      final stats = controller.dashboardStats.value;
      final health = stats.systemHealth;

      return ProfessionalSectionCard(
        title: 'System Health',
        child: Column(
          children: [
            // Health Indicators
            ...['Database', 'API', 'Cache', 'Storage'].map((service) =>
                _buildHealthIndicator(
                  service,
                  health[service.toLowerCase()] ?? true,
                  context,
                ),
            ),

            SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),

            // Metrics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetric('Uptime', health['uptime'] ?? '99.9%', context),
                _buildMetric('Response', health['responseTime'] ?? '45ms', context),
                _buildMetric('Memory', health['memoryUsage'] ?? '67%', context),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHealthIndicator(String service, bool isHealthy, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveBreakpoints.getResponsiveSpacing(context, 12),
      ),
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 12),
        horizontal: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
      ),
      decoration: BoxDecoration(
        color: isHealthy
            ? const Color(0xFF10B981).withOpacity(0.05)
            : const Color(0xFFEF4444).withOpacity(0.05),
        borderRadius: BorderRadius.circular(
          ResponsiveBreakpoints.getResponsiveRadius(context, 12),
        ),
        border: Border.all(
          color: isHealthy
              ? const Color(0xFF10B981).withOpacity(0.2)
              : const Color(0xFFEF4444).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            service,
            style: TextStyle(
              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0F172A),
            ),
          ),
          Row(
            children: [
              Container(
                width: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                height: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                decoration: BoxDecoration(
                  color: isHealthy ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
              Text(
                isHealthy ? 'Healthy' : 'Error',
                style: TextStyle(
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                  color: isHealthy ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 18),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF3B82F6),
          ),
        ),
        SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 4)),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAdminManagementSection(SuperAdminController controller, BuildContext context) {
    return ProfessionalSectionCard(
      title: 'Admin Management',
      action: ElevatedButton.icon(
        onPressed: () => Get.snackbar('Action', 'Create Admin Dialog'),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Admin'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: Obx(() {
        if (controller.adminUsers.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 40)),
              child: Text(
                'No admin users found',
                style: TextStyle(
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.adminUsers.length,
          separatorBuilder: (context, index) => Divider(
            height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24),
            color: const Color(0xFFE2E8F0),
          ),
          itemBuilder: (context, index) {
            final admin = controller.adminUsers[index];
            return _buildAdminTile(context, admin, controller);
          },
        );
      }),
    );
  }

  Widget _buildAdminTile(BuildContext context, dynamic admin, SuperAdminController controller) {
    return Container(
      padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(
          ResponsiveBreakpoints.getResponsiveRadius(context, 12),
        ),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: ResponsiveBreakpoints.getResponsiveSize(context, 24),
            backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
            child: Icon(
              Icons.admin_panel_settings_outlined,
              color: const Color(0xFF3B82F6),
              size: ResponsiveBreakpoints.getResponsiveIconSize(context, 24),
            ),
          ),
          SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin.fullName ?? 'Admin User',
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 4)),
                Text(
                  admin.email ?? 'admin@example.com',
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 2)),
                Text(
                  '${admin.permissions?.length ?? 0} permissions',
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveBreakpoints.getResponsiveSize(context, 12),
              vertical: ResponsiveBreakpoints.getResponsiveSize(context, 6),
            ),
            decoration: BoxDecoration(
              color: (admin.isActive ?? true)
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveBreakpoints.getResponsiveRadius(context, 20),
              ),
            ),
            child: Text(
              (admin.isActive ?? true) ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
                color: (admin.isActive ?? true)
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 12)),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: const Color(0xFF64748B),
              size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
            ),
            onSelected: (value) => _handleAdminMenuAction(context, value, admin, controller),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit_permissions',
                child: Row(
                  children: [
                    Icon(Icons.security_outlined, size: 18),
                    SizedBox(width: 12),
                    Text('Edit Permissions'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle_status',
                child: Row(
                  children: [
                    Icon(
                      (admin.isActive ?? true) ? Icons.block_outlined : Icons.check_circle_outline,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text((admin.isActive ?? true) ? 'Deactivate' : 'Activate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 18),
                    SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAdminMenuAction(BuildContext context, String action, dynamic admin, SuperAdminController controller) {
    switch (action) {
      case 'edit_permissions':
        Get.snackbar('Action', 'Edit permissions for ${admin.fullName}');
        break;
      case 'toggle_status':
        Get.snackbar('Action', 'Toggle status for ${admin.fullName}');
        break;
      case 'delete':
        Get.snackbar('Action', 'Delete ${admin.fullName}');
        break;
    }
  }

  Widget _buildRecentActivitiesSection(SuperAdminController controller, BuildContext context) {
    return ProfessionalSectionCard(
      title: 'Recent Activities',
      child: Obx(() {
        if (controller.recentActivities.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 40)),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: ResponsiveBreakpoints.getResponsiveIconSize(context, 48),
                    color: const Color(0xFF94A3B8),
                  ),
                  SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                  Text(
                    'No recent activities',
                    style: TextStyle(
                      fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
                  Text(
                    'Activity logs will appear here',
                    style: TextStyle(
                      fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recentActivities.length,
          separatorBuilder: (context, index) => Divider(
            height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24),
            color: const Color(0xFFE2E8F0),
          ),
          itemBuilder: (context, index) {
            final activity = controller.recentActivities[index];
            return _buildActivityTile(context, activity);
          },
        );
      }),
    );
  }

  Widget _buildActivityTile(BuildContext context, dynamic activity) {
    return Container(
      padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(
          ResponsiveBreakpoints.getResponsiveRadius(context, 12),
        ),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveBreakpoints.getResponsiveSize(context, 48),
            height: ResponsiveBreakpoints.getResponsiveSize(context, 48),
            decoration: BoxDecoration(
              color: _getActivityColor(activity.type ?? 'default').withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActivityIcon(activity.type ?? 'default'),
              color: _getActivityColor(activity.type ?? 'default'),
              size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
            ),
          ),
          SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description ?? 'System activity',
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 4)),
                Row(
                  children: [
                    Text(
                      activity.userEmail ?? 'system@admin.com',
                      style: TextStyle(
                        fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TextStyle(
                        fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      _formatTime(activity.timestamp ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (activity.isImportant ?? false)
            Container(
              width: ResponsiveBreakpoints.getResponsiveSize(context, 8),
              height: ResponsiveBreakpoints.getResponsiveSize(context, 8),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'user_created':
        return const Color(0xFF10B981);
      case 'admin_created':
        return const Color(0xFF3B82F6);
      case 'permission_changed':
        return const Color(0xFFF59E0B);
      case 'system_alert':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'user_created':
        return Icons.person_add_outlined;
      case 'admin_created':
        return Icons.admin_panel_settings_outlined;
      case 'permission_changed':
        return Icons.security_outlined;
      case 'system_alert':
        return Icons.warning_outlined;
      default:
        return Icons.info_outlined;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  // Widget _buildDashboardContent(
  //     SuperAdminController controller,
  //     BuildContext context,
  //     ) {
  //   final authController = Get.find<AuthController>();
  //
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFF8FAFC),
  //     body: CustomScrollView(
  //       slivers: [
  //         // Professional SliverAppBar with Search
  //         SliverAppBar(
  //           expandedHeight: ResponsiveBreakpoints.getResponsiveSize(context, 200),
  //           floating: false,
  //           pinned: true,
  //           stretch: true,
  //           backgroundColor: Colors.white,
  //           elevation: 0,
  //           automaticallyImplyLeading: false,
  //           flexibleSpace: LayoutBuilder(
  //             builder: (BuildContext context, BoxConstraints constraints) {
  //               final top = constraints.biggest.height;
  //               final isCollapsed = top <= kToolbarHeight + MediaQuery.of(context).padding.top + 20;
  //
  //               return FlexibleSpaceBar(
  //                 titlePadding: EdgeInsets.zero,
  //                 title: isCollapsed
  //                     ? _buildCollapsedAppBar(context, authController, controller)
  //                     : null,
  //                 background: _buildExpandedAppBar(context, authController, controller),
  //                 stretchModes: const [
  //                   StretchMode.zoomBackground,
  //                   StretchMode.fadeTitle,
  //                 ],
  //               );
  //             },
  //           ),
  //           // bottom: PreferredSize(
  //           //   preferredSize: Size.fromHeight(
  //           //     ResponsiveBreakpoints.getResponsiveSize(context, 40),
  //           //   ),
  //           //   child: _buildSearchBar(context, controller),
  //           // ),
  //         ),
  //
  //         // Main Content as Slivers
  //         SliverPadding(
  //           padding: EdgeInsets.all(
  //             ResponsiveBreakpoints.getResponsiveSize(context, 24),
  //           ),
  //           sliver: SliverList(
  //             delegate: SliverChildListDelegate([
  //               // Statistics Overview
  //               _buildStatsGrid(controller, context),
  //               SizedBox(
  //                 height: ResponsiveBreakpoints.getResponsiveSpacing(context, 32),
  //               ),
  //
  //               // Quick Actions Section
  //               _buildQuickActionsSection(context),
  //               SizedBox(
  //                 height: ResponsiveBreakpoints.getResponsiveSpacing(context, 32),
  //               ),
  //
  //               // System Overview Section
  //               _buildSystemOverviewSection(controller, context),
  //               SizedBox(
  //                 height: ResponsiveBreakpoints.getResponsiveSpacing(context, 32),
  //               ),
  //
  //               // Admin Management Section
  //               _buildAdminManagementSection(controller, context),
  //               SizedBox(
  //                 height: ResponsiveBreakpoints.getResponsiveSpacing(context, 32),
  //               ),
  //
  //               // Recent Activities Section
  //               _buildRecentActivitiesSection(controller, context),
  //             ]),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //
  // }
  //
  // // Collapsed App Bar (shown when scrolled)
  // Widget _buildCollapsedAppBar(BuildContext context, AuthController authController, SuperAdminController controller) {
  //   return Container(
  //     padding: EdgeInsets.fromLTRB(
  //       ResponsiveBreakpoints.getResponsiveSize(context, 24),
  //       ResponsiveBreakpoints.getResponsiveSize(context, 20),
  //       ResponsiveBreakpoints.getResponsiveSize(context, 24),
  //       ResponsiveBreakpoints.getResponsiveSize(context, 0),
  //     ),
  //     child: _buildSearchBar(context, controller),
  //     // padding: EdgeInsets.symmetric(
  //     //   horizontal: ResponsiveBreakpoints.getResponsiveSize(context, 16),
  //     // ),
  //     // child: Row(
  //     //   children: [
  //     //     // Mini Avatar
  //     //     Container(
  //     //       width: ResponsiveBreakpoints.getResponsiveSize(context, 32),
  //     //       height: ResponsiveBreakpoints.getResponsiveSize(context, 32),
  //     //       decoration: BoxDecoration(
  //     //         shape: BoxShape.circle,
  //     //         gradient: const LinearGradient(
  //     //           colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  //     //         ),
  //     //       ),
  //     //       child: Center(
  //     //         child: Text(
  //     //           'A',
  //     //           style: TextStyle(
  //     //             color: Colors.white,
  //     //             fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
  //     //             fontWeight: FontWeight.w600,
  //     //           ),
  //     //         ),
  //     //       ),
  //     //     ),
  //     //     SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 12)),
  //     //
  //     //     // User name in collapsed state
  //     //     Text(
  //     //       'Avdhesh',
  //     //       style: TextStyle(
  //     //         fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
  //     //         fontWeight: FontWeight.w600,
  //     //         color: const Color(0xFF0F172A),
  //     //       ),
  //     //     ),
  //     //
  //     //     const Spacer(),
  //     //
  //     //     // Actions
  //     //     _buildAppBarActions(context, authController, isCollapsed: true),
  //     //   ],
  //     // ),
  //   );
  // }
  //
  // // Expanded App Bar (shown when at top)
  // Widget _buildExpandedAppBar(BuildContext context, AuthController authController, SuperAdminController controller) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           const Color(0xFFF8FAFC),
  //           Colors.white,
  //           const Color(0xFFF1F5F9),
  //         ],
  //       ),
  //     ),
  //     child: SafeArea(
  //       bottom: false,
  //       child: Padding(
  //         padding: EdgeInsets.fromLTRB(
  //           ResponsiveBreakpoints.getResponsiveSize(context, 24),
  //           ResponsiveBreakpoints.getResponsiveSize(context, 20),
  //           ResponsiveBreakpoints.getResponsiveSize(context, 24),
  //           ResponsiveBreakpoints.getResponsiveSize(context, 0),
  //         ),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 // Professional Profile Avatar
  //                 GestureDetector(
  //                   onTap: () {
  //                     Get.snackbar('Profile', 'Profile settings opened');
  //                   },
  //                   child: Hero(
  //                     tag: 'user-avatar',
  //                     child: Container(
  //                       width: ResponsiveBreakpoints.getResponsiveSize(context, 56),
  //                       height: ResponsiveBreakpoints.getResponsiveSize(context, 56),
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         gradient: const LinearGradient(
  //                           colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
  //                         ),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: const Color(0xFF3B82F6).withOpacity(0.3),
  //                             blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 12),
  //                             offset: const Offset(0, 4),
  //                           ),
  //                         ],
  //                       ),
  //                       child: Center(
  //                         child: Text(
  //                           'A',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 24),
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //
  //                 SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 20)),
  //
  //                 // Professional Greeting
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Text(
  //                         'Good ${_getTimeGreeting()},',
  //                         style: TextStyle(
  //                           fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
  //                           color: const Color(0xFF64748B),
  //                           fontWeight: FontWeight.w400,
  //                           letterSpacing: 0.3,
  //                         ),
  //                       ),
  //                       SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 2)),
  //                       Text(
  //                         'Avdhesh',
  //                         style: TextStyle(
  //                           fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 24),
  //                           fontWeight: FontWeight.w700,
  //                           color: const Color(0xFF0F172A),
  //                           letterSpacing: -0.5,
  //                         ),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 // Actions
  //                 _buildAppBarActions(context, authController, isCollapsed: false),
  //               ],
  //             ),
  //             SizedBox(height: 20,),
  //             _buildSearchBar(context, controller)
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // // App Bar Actions (Notifications & Logout)
  // Widget _buildAppBarActions(BuildContext context, AuthController authController, {required bool isCollapsed}) {
  //   final iconSize = isCollapsed
  //       ? ResponsiveBreakpoints.getResponsiveIconSize(context, 20)
  //       : ResponsiveBreakpoints.getResponsiveIconSize(context, 22);
  //   final buttonSize = isCollapsed
  //       ? ResponsiveBreakpoints.getResponsiveSize(context, 40)
  //       : ResponsiveBreakpoints.getResponsiveSize(context, 48);
  //
  //   return Row(
  //     children: [
  //       // Notification Bell with Badge
  //       GestureDetector(
  //         onTap: () {
  //           Get.snackbar('Notifications', 'Notification center opened');
  //         },
  //         child: Container(
  //           width: buttonSize,
  //           height: buttonSize,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             shape: BoxShape.circle,
  //             border: Border.all(
  //               color: const Color(0xFFE2E8F0),
  //               width: 1,
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.08),
  //                 blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 12),
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: Stack(
  //             children: [
  //               Center(
  //                 child: Icon(
  //                   Icons.notifications_outlined,
  //                   color: const Color(0xFF475569),
  //                   size: iconSize,
  //                 ),
  //               ),
  //               // Notification Badge
  //               Positioned(
  //                 top: ResponsiveBreakpoints.getResponsiveSize(context, 8),
  //                 right: ResponsiveBreakpoints.getResponsiveSize(context, 8),
  //                 child: Container(
  //                   width: ResponsiveBreakpoints.getResponsiveSize(context, 8),
  //                   height: ResponsiveBreakpoints.getResponsiveSize(context, 8),
  //                   decoration: const BoxDecoration(
  //                     color: Color(0xFFEF4444),
  //                     shape: BoxShape.circle,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //
  //       SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
  //
  //       // Logout Button
  //       IconButton(
  //         onPressed: () {
  //           authController.logout();
  //         },
  //         icon: Icon(
  //           SolarIconsOutline.logout,
  //           color: Colors.black,
  //           size: iconSize,
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // // Search Bar Widget
  // Widget _buildSearchBar(BuildContext context, SuperAdminController controller) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border(
  //         bottom: BorderSide(
  //           color: const Color(0xFFE2E8F0).withOpacity(0.5),
  //           width: 1,
  //         ),
  //       ),
  //     ),
  //     child: Container(
  //       height: ResponsiveBreakpoints.getResponsiveSize(context, 48),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFF8FAFC),
  //         borderRadius: BorderRadius.circular(
  //           ResponsiveBreakpoints.getResponsiveRadius(context, 12),
  //         ),
  //         border: Border.all(
  //           color: const Color(0xFFE2E8F0),
  //           width: 1,
  //         ),
  //       ),
  //       child: TextField(
  //         //controller: controller.searchController,
  //         //onChanged: (value) => controller.onSearchChanged(value),
  //         decoration: InputDecoration(
  //           hintText: 'Search users, admins, or activities...',
  //           hintStyle: TextStyle(
  //             color: const Color(0xFF94A3B8),
  //             fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
  //           ),
  //           prefixIcon: Icon(
  //             Icons.search,
  //             color: const Color(0xFF64748B),
  //             size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
  //           ),
  //           // suffixIcon: controller.searchQuery.value.isNotEmpty
  //           //     ? IconButton(
  //           //   icon: Icon(
  //           //     Icons.clear,
  //           //     color: const Color(0xFF64748B),
  //           //     size: ResponsiveBreakpoints.getResponsiveIconSize(context, 18),
  //           //   ),
  //           //   onPressed: () {
  //           //     controller.clearSearch();
  //           //   },
  //           // )
  //           //     : Row(
  //           //   mainAxisSize: MainAxisSize.min,
  //           //   children: [
  //           //     Container(
  //           //       height: ResponsiveBreakpoints.getResponsiveSize(context, 20),
  //           //       width: 1,
  //           //       color: const Color(0xFFE2E8F0),
  //           //       margin: EdgeInsets.symmetric(
  //           //         horizontal: ResponsiveBreakpoints.getResponsiveSpacing(context, 8),
  //           //       ),
  //           //     ),
  //           //     IconButton(
  //           //       icon: Icon(
  //           //         Icons.filter_list,
  //           //         color: const Color(0xFF64748B),
  //           //         size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
  //           //       ),
  //           //       onPressed: () {
  //           //         _showFilterOptions(context, controller);
  //           //       },
  //           //     ),
  //           //   ],
  //           // ),
  //           border: InputBorder.none,
  //           contentPadding: EdgeInsets.symmetric(
  //             vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 12),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // // Filter Options Bottom Sheet
  // void _showFilterOptions(BuildContext context, SuperAdminController controller) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(
  //           ResponsiveBreakpoints.getResponsiveRadius(context, 20),
  //         ),
  //       ),
  //     ),
  //     builder: (context) => Container(
  //       padding: EdgeInsets.all(
  //         ResponsiveBreakpoints.getResponsiveSize(context, 24),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Filter Options',
  //             style: TextStyle(
  //               fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
  //               fontWeight: FontWeight.w700,
  //               color: const Color(0xFF0F172A),
  //             ),
  //           ),
  //           SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),
  //
  //           // Filter options here
  //           _buildFilterOption(context, 'All', true),
  //           _buildFilterOption(context, 'Active Users', false),
  //           _buildFilterOption(context, 'Inactive Users', false),
  //           _buildFilterOption(context, 'Admins Only', false),
  //           _buildFilterOption(context, 'Recent Activities', false),
  //
  //           SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),
  //
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: OutlinedButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   style: OutlinedButton.styleFrom(
  //                     padding: EdgeInsets.symmetric(
  //                       vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
  //                     ),
  //                     side: const BorderSide(color: Color(0xFFE2E8F0)),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(
  //                         ResponsiveBreakpoints.getResponsiveRadius(context, 12),
  //                       ),
  //                     ),
  //                   ),
  //                   child: const Text('Cancel'),
  //                 ),
  //               ),
  //               SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
  //               Expanded(
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     // controller.applyFilters();
  //                     Navigator.pop(context);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: const Color(0xFF3B82F6),
  //                     foregroundColor: Colors.white,
  //                     padding: EdgeInsets.symmetric(
  //                       vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
  //                     ),
  //                     elevation: 0,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(
  //                         ResponsiveBreakpoints.getResponsiveRadius(context, 12),
  //                       ),
  //                     ),
  //                   ),
  //                   child: const Text('Apply Filters'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildFilterOption(BuildContext context, String label, bool isSelected) {
  //   return Container(
  //     margin: EdgeInsets.only(
  //       bottom: ResponsiveBreakpoints.getResponsiveSpacing(context, 12),
  //     ),
  //     child: InkWell(
  //       onTap: () {
  //         // Handle filter selection
  //       },
  //       borderRadius: BorderRadius.circular(
  //         ResponsiveBreakpoints.getResponsiveRadius(context, 12),
  //       ),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
  //           vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 12),
  //         ),
  //         decoration: BoxDecoration(
  //           color: isSelected
  //               ? const Color(0xFF3B82F6).withOpacity(0.1)
  //               : Colors.transparent,
  //           borderRadius: BorderRadius.circular(
  //             ResponsiveBreakpoints.getResponsiveRadius(context, 12),
  //           ),
  //           border: Border.all(
  //             color: isSelected
  //                 ? const Color(0xFF3B82F6)
  //                 : const Color(0xFFE2E8F0),
  //             width: 1,
  //           ),
  //         ),
  //         child: Row(
  //           children: [
  //             Icon(
  //               isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
  //               color: isSelected
  //                   ? const Color(0xFF3B82F6)
  //                   : const Color(0xFF94A3B8),
  //               size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
  //             ),
  //             SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 12)),
  //             Text(
  //               label,
  //               style: TextStyle(
  //                 fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
  //                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
  //                 color: isSelected
  //                     ? const Color(0xFF3B82F6)
  //                     : const Color(0xFF0F172A),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // String _getTimeGreeting() {
  //   final hour = DateTime.now().hour;
  //   if (hour < 12) return 'morning';
  //   if (hour < 17) return 'afternoon';
  //   return 'evening';
  // }

  Widget _buildDashboardContent(
      SuperAdminController controller,
      BuildContext context,
      ) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Professional SliverAppBar with Search
          SliverAppBar(
            expandedHeight: ResponsiveBreakpoints.getResponsiveSize(context, 170),
            //actionsPadding: EdgeInsets.zero,
            scrolledUnderElevation: 0.0,
            floating: false,
            pinned: true,
            stretch: false,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            flexibleSpace: _buildExpandedAppBar(context, authController),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                ResponsiveBreakpoints.getResponsiveSize(context, 30),
              ),
              child: _buildSearchBar(context, controller),
            ),
          ),

          // Main Content as Slivers
          SliverPadding(
            padding: EdgeInsets.all(
              ResponsiveBreakpoints.getResponsiveSize(context, 24),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Statistics Overview
                _buildStatsGrid(controller, context),
                SizedBox(
                  height: ResponsiveBreakpoints.getResponsiveSpacing(context, 32),
                ),

                // Quick Actions Section
                _buildQuickActionsSection(context),
                SizedBox(
                  height: ResponsiveBreakpoints.getResponsiveSpacing(context, 32),
                ),

                // System Overview Section
                _buildSystemOverviewSection(controller, context),
                SizedBox(
                  height: ResponsiveBreakpoints.getResponsiveSpacing(context, 32),
                ),

                // Admin Management Section
                _buildAdminManagementSection(controller, context),
                SizedBox(
                  height: ResponsiveBreakpoints.getResponsiveSpacing(context, 32),
                ),

                // Recent Activities Section
                _buildRecentActivitiesSection(controller, context),
              ]),
            ),
          ),
        ],
      ),
    );

  }

  // Collapsed App Bar (shown when scrolled)
  Widget _buildCollapsedAppBar(BuildContext context, AuthController authController) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveBreakpoints.getResponsiveSize(context, 16),
      ),
      child: Row(
        children: [
          // Mini Avatar
          Container(
            width: ResponsiveBreakpoints.getResponsiveSize(context, 32),
            height: ResponsiveBreakpoints.getResponsiveSize(context, 32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 12)),

          // User name in collapsed state
          Text(
            'Avdhesh',
            style: TextStyle(
              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),

          const Spacer(),

          // Actions
          _buildAppBarActions(context, authController, isCollapsed: true),
        ],
      ),
    );
  }

  // Expanded App Bar (shown when at top)
  Widget _buildExpandedAppBar(BuildContext context, AuthController authController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     const Color(0xFFF8FAFC),
        //     Colors.white,
        //     const Color(0xFFF1F5F9),
        //   ],
        // ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            ResponsiveBreakpoints.getResponsiveSize(context, 24),
            ResponsiveBreakpoints.getResponsiveSize(context, 20),
            ResponsiveBreakpoints.getResponsiveSize(context, 24),
            ResponsiveBreakpoints.getResponsiveSize(context, 0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Professional Profile Avatar
                  GestureDetector(
                    onTap: () {
                      Get.snackbar('Profile', 'Profile settings opened');
                    },
                    child: Hero(
                      tag: 'user-avatar',
                      child: Container(
                        width: ResponsiveBreakpoints.getResponsiveSize(context, 56),
                        height: ResponsiveBreakpoints.getResponsiveSize(context, 56),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 12),
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 24),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 20)),

                  // Professional Greeting
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Good ${_getTimeGreeting()},',
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 2)),
                        Text(
                          'Avdhesh',
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 24),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  _buildAppBarActions(context, authController, isCollapsed: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // App Bar Actions (Notifications & Logout)
  Widget _buildAppBarActions(BuildContext context, AuthController authController, {required bool isCollapsed}) {
    final iconSize = isCollapsed
        ? ResponsiveBreakpoints.getResponsiveIconSize(context, 20)
        : ResponsiveBreakpoints.getResponsiveIconSize(context, 22);
    final buttonSize = isCollapsed
        ? ResponsiveBreakpoints.getResponsiveSize(context, 40)
        : ResponsiveBreakpoints.getResponsiveSize(context, 48);

    return Row(
      children: [
        // Notification Bell with Badge
        GestureDetector(
          onTap: () {
            Get.snackbar('Notifications', 'Notification center opened');
          },
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 1),
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    SolarIconsOutline.bell,
                    color: const Color(0xFF475569),
                    size: iconSize,
                  ),
                ),
                // Notification Badge
                Positioned(
                  top: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                  right: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                  child: Container(
                    width: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                    height: ResponsiveBreakpoints.getResponsiveSize(context, 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),

        //Logout Button
        Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: ResponsiveBreakpoints.getResponsiveSize(context, 1),
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              authController.logout();
            },
            icon: Icon(
              SolarIconsOutline.login_2,
              color: Colors.black,
              size: iconSize,
            ),
          ),
        ),
      ],
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar(BuildContext context, SuperAdminController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveBreakpoints.getResponsiveSize(context, 24),
        vertical: ResponsiveBreakpoints.getResponsiveSize(context, 12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE2E8F0).withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Container(
        height: ResponsiveBreakpoints.getResponsiveSize(context, 48),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(
            ResponsiveBreakpoints.getResponsiveRadius(context, 12),
          ),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: TextField(
          // controller: controller.searchController,
          // onChanged: (value) => controller.onSearchChanged(value),
          decoration: InputDecoration(
            hintText: 'Search users, admins, or activities...',
            hintStyle: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
            ),
            prefixIcon: Icon(
              SolarIconsOutline.magnifier,
              color: const Color(0xFF64748B),
              size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
            ),
            // suffixIcon: controller.searchQuery.value.isNotEmpty
            //     ? IconButton(
            //   icon: Icon(
            //     Icons.clear,
            //     color: const Color(0xFF64748B),
            //     size: ResponsiveBreakpoints.getResponsiveIconSize(context, 18),
            //   ),
            //   onPressed: () {
            //     //controller.clearSearch();
            //   },
            // )
            //     : Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Container(
            //       height: ResponsiveBreakpoints.getResponsiveSize(context, 20),
            //       width: 1,
            //       color: const Color(0xFFE2E8F0),
            //       margin: EdgeInsets.symmetric(
            //         horizontal: ResponsiveBreakpoints.getResponsiveSpacing(context, 8),
            //       ),
            //     ),
            //     IconButton(
            //       icon: Icon(
            //         Icons.filter_list,
            //         color: const Color(0xFF64748B),
            //         size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
            //       ),
            //       onPressed: () {
            //         _showFilterOptions(context, controller);
            //       },
            //     ),
            //   ],
            // ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(20
              //vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 12),
            ),
          ),
        ),
      ),
    );
  }

  // Filter Options Bottom Sheet
  void _showFilterOptions(BuildContext context, SuperAdminController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            ResponsiveBreakpoints.getResponsiveRadius(context, 50),
          ),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(
          ResponsiveBreakpoints.getResponsiveSize(context, 24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),

            // Filter options here
            _buildFilterOption(context, 'All', true),
            _buildFilterOption(context, 'Active Users', false),
            _buildFilterOption(context, 'Inactive Users', false),
            _buildFilterOption(context, 'Admins Only', false),
            _buildFilterOption(context, 'Recent Activities', false),

            SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveBreakpoints.getResponsiveRadius(context, 12),
                        ),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      //controller.applyFilters();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveBreakpoints.getResponsiveRadius(context, 12),
                        ),
                      ),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveBreakpoints.getResponsiveSpacing(context, 12),
      ),
      child: InkWell(
        onTap: () {
          // Handle filter selection
        },
        borderRadius: BorderRadius.circular(
          ResponsiveBreakpoints.getResponsiveRadius(context, 12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
            vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 12),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF3B82F6).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              ResponsiveBreakpoints.getResponsiveRadius(context, 12),
            ),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF94A3B8),
                size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
              ),
              SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 12)),
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

}

class DashboardStats {
  final int totalUsers;
  final int activeAdmins;
  final int totalOrders;
  final double totalRevenue;
  final double userGrowth;
  final double orderGrowth;
  final double revenueGrowth;
  final Map<String, dynamic> systemHealth;

  DashboardStats({
    this.totalUsers = 0,
    this.activeAdmins = 0,
    this.totalOrders = 0,
    this.totalRevenue = 0.0,
    this.userGrowth = 0.0,
    this.orderGrowth = 0.0,
    this.revenueGrowth = 0.0,
    this.systemHealth = const {},
  });
}

class AdminUser {
  final String id;
  final String fullName;
  final String email;
  final bool isActive;
  final List<String> permissions;

  AdminUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.isActive,
    required this.permissions,
  });
}

class RecentActivity {
  final String type;
  final String description;
  final String userEmail;
  final DateTime timestamp;
  final bool isImportant;

  RecentActivity({
    required this.type,
    required this.description,
    required this.userEmail,
    required this.timestamp,
    required this.isImportant,
  });
}

