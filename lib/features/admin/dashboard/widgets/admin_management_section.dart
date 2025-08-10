import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/responsive_breakpoints.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../core/enums/permissions.dart';
import '../controllers/super_admin_controller.dart';
import 'create_admin_dialog.dart';
import 'edit_admin_permissions_dialog.dart';

class AdminManagementSection extends StatelessWidget {
  const AdminManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuperAdminController>(
      builder: (controller) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Admin Management',
                      style: TextStyle(
                        fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showCreateAdminDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Admin'),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                Obx(() {
                  if (controller.adminUsers.isEmpty) {
                    return const Center(
                      child: Text('No admin users found'),
                    );
                  }
                  
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.adminUsers.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final admin = controller.adminUsers[index];
                      return _buildAdminTile(context, admin, controller);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminTile(BuildContext context, UserModel admin, SuperAdminController controller) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: admin.isActive ? Colors.green[100] : Colors.red[100],
        child: Icon(
          Icons.admin_panel_settings,
          color: admin.isActive ? Colors.green[700] : Colors.red[700],
          size: ResponsiveBreakpoints.getResponsiveIconSize(context, 20),
        ),
      ),
      title: Text(
        admin.fullName,
        style: TextStyle(
          fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            admin.email,
            style: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14)),
          ),
          Text(
            '${admin.permissions.length} permissions',
            style: TextStyle(
              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: admin.isActive ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              admin.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
                color: admin.isActive ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value, admin, controller),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit_permissions',
                child: Row(
                  children: [
                    Icon(Icons.security),
                    SizedBox(width: 8),
                    Text('Edit Permissions'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle_status',
                child: Row(
                  children: [
                    Icon(admin.isActive ? Icons.block : Icons.check_circle),
                    const SizedBox(width: 8),
                    Text(admin.isActive ? 'Deactivate' : 'Activate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
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

  void _handleMenuAction(BuildContext context, String action, UserModel admin, SuperAdminController controller) {
    switch (action) {
      case 'edit_permissions':
        _showEditPermissionsDialog(context, admin);
        break;
      case 'toggle_status':
        _confirmToggleStatus(context, admin, controller);
        break;
      case 'delete':
        _confirmDeleteAdmin(context, admin, controller);
        break;
    }
  }

  void _showCreateAdminDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateAdminDialog(),
    );
  }

  void _showEditPermissionsDialog(BuildContext context, UserModel admin) {
    showDialog(
      context: context,
      builder: (context) => EditAdminPermissionsDialog(admin: admin),
    );
  }

  void _confirmToggleStatus(BuildContext context, UserModel admin, SuperAdminController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${admin.isActive ? 'Deactivate' : 'Activate'} Admin'),
        content: Text(
          'Are you sure you want to ${admin.isActive ? 'deactivate' : 'activate'} ${admin.fullName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.toggleAdminStatus(admin.id, !admin.isActive);
            },
            child: Text(admin.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAdmin(BuildContext context, UserModel admin, SuperAdminController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Admin'),
        content: Text(
          'Are you sure you want to delete ${admin.fullName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteAdmin(admin.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}