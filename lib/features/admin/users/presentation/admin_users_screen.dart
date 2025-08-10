import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/responsive_breakpoints.dart';
import '../../../../shared/models/user_model.dart';
import '../controllers/user_controller.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize user controller
    Get.put(UserController());
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, userController),
            
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSize(context, 24.0)),
            
            // Filters
            _buildFilters(context, userController),
            
            SizedBox(height: ResponsiveBreakpoints.getResponsiveSize(context, 16.0)),
            
            // Users table
            Expanded(
              child: _buildUsersTable(context, userController),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserForm(context, userController),
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Management',
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: 4),
            Obx(() => Text(
              '${controller.users.length} users',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            )),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: controller.refreshUsers,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _showUserForm(context, controller),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add User'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, UserController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Search field
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: controller.searchUsers,
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Role filter
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedRole.isEmpty 
                        ? null 
                        : controller.selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: '',
                        child: Text('All Roles'),
                      ),
                      ...controller.roles.map((role) =>
                        DropdownMenuItem<String>(
                          value: role.id,
                          child: Text(role.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => controller.filterByRole(value ?? ''),
                  )),
                ),
                
                SizedBox(width: 16),
                
                // Sort dropdown
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: '${controller.sortBy}-${controller.sortOrder}',
                    decoration: InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'firstName-asc',
                        child: Text('Name A-Z'),
                      ),
                      DropdownMenuItem(
                        value: 'firstName-desc',
                        child: Text('Name Z-A'),
                      ),
                      DropdownMenuItem(
                        value: 'email-asc',
                        child: Text('Email A-Z'),
                      ),
                      DropdownMenuItem(
                        value: 'email-desc',
                        child: Text('Email Z-A'),
                      ),
                      DropdownMenuItem(
                        value: 'createdAt-desc',
                        child: Text('Newest First'),
                      ),
                      DropdownMenuItem(
                        value: 'createdAt-asc',
                        child: Text('Oldest First'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        final parts = value.split('-');
                        controller.sortUsers(parts[0], parts[1]);
                      }
                    },
                  )),
                ),
                
                SizedBox(width: 16),
                
                // Clear filters button
                TextButton.icon(
                  onPressed: controller.clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTable(BuildContext context, UserController controller) {
    return Obx(() {
      if (controller.isLoading && controller.users.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.users.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: AppTheme.textLight,
              ),
              SizedBox(height: 16),
              Text(
                'No users found',
                style: AppTextStyles.heading4.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add your first user to get started',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
            ],
          ),
        );
      }

      return Card(
        child: Column(
          children: [
            Expanded(
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 900,
                columns: const [
                  DataColumn2(
                    label: Text('User'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Email'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Role'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Status'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Last Login'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Actions'),
                    size: ColumnSize.S,
                  ),
                ],
                rows: controller.users.map((user) {
                  return DataRow2(
                    cells: [
                      DataCell(_buildUserCell(user)),
                      DataCell(Text(user.email)),
                      DataCell(_buildRoleCell(user)),
                      DataCell(_buildStatusCell(user)),
                      DataCell(_buildLastLoginCell(user)),
                      DataCell(_buildActionsCell(context, user, controller)),
                    ],
                  );
                }).toList(),
              ),
            ),
            
            // Pagination
            if (controller.totalPages > 1)
              _buildPagination(controller),
          ],
        ),
      );
    });
  }

  Widget _buildUserCell(UserModel user) {
    return Row(
      children: [
        // User avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.primaryColor,
          backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null || user.avatarUrl!.isEmpty
              ? Text(
                  user.firstName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        SizedBox(width: 12),
        
        // User name and info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.fullName,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                'Joined ${DateFormat('MMM dd, yyyy').format(user.createdAt)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCell(UserModel user) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor(user.primaryRole.value).withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        user.primaryRole.displayName,
        style: AppTextStyles.bodySmall.copyWith(
          color: _getRoleColor(user.primaryRole.value),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusCell(UserModel user) {
    final isVerified = user.emailVerified;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: user.isActive ? Colors.green.withAlpha(51) : Colors.red.withAlpha(51),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            user.isActive ? 'Active' : 'Inactive',
            style: AppTextStyles.bodySmall.copyWith(
              color: user.isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(
              isVerified ? Icons.verified : Icons.email,
              size: 12,
              color: isVerified ? Colors.green : AppTheme.textLight,
            ),
            SizedBox(width: 4),
            Text(
              isVerified ? 'Verified' : 'Unverified',
              style: AppTextStyles.bodySmall.copyWith(
                color: isVerified ? Colors.green : AppTheme.textLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLastLoginCell(UserModel user) {
    if (user.lastLogin == null) {
      return Text(
        'Never',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppTheme.textLight,
        ),
      );
    }

    final now = DateTime.now();
    final difference = now.difference(user.lastLogin!);
    
    String timeAgo;
    if (difference.inDays > 0) {
      timeAgo = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes}m ago';
    } else {
      timeAgo = 'Just now';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          timeAgo,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          DateFormat('MMM dd, HH:mm').format(user.lastLogin!),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionsCell(BuildContext context, UserModel user, UserController controller) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, size: 18),
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit, size: 16),
                title: Text('Edit'),
                dense: true,
              ),
            ),
            PopupMenuItem<String>(
              value: 'status',
              child: ListTile(
                leading: Icon(
                  user.isActive ? Icons.block : Icons.check_circle,
                  size: 16,
                ),
                title: Text(user.isActive ? 'Deactivate' : 'Activate'),
                dense: true,
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, size: 16, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                dense: true,
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showUserForm(context, controller, user: user);
                break;
              case 'status':
                controller.updateUserStatus(user.id, !user.isActive);
                break;
              case 'delete':
                _confirmDelete(context, user, controller);
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildPagination(UserController controller) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${controller.currentPage} of ${controller.totalPages}',
            style: AppTextStyles.bodyMedium,
          ),
          Row(
            children: [
              IconButton(
                onPressed: controller.currentPage > 1
                    ? () => controller.loadUsers(refresh: true)
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: controller.hasNextPage
                    ? controller.loadMoreUsers
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return Colors.red;
      case 'admin':
        return Colors.blue;
      case 'customer':
        return Colors.green;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _showUserForm(BuildContext context, UserController controller, {UserModel? user}) {
    // This will show a user form dialog
    Get.showSnackbar(GetSnackBar(
      message: user == null 
          ? 'Add User form - Coming Soon'
          : 'Edit User form - Coming Soon',
      backgroundColor: AppTheme.primaryColor,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
    ));
  }

  void _confirmDelete(BuildContext context, UserModel user, UserController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete "${user.fullName}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteUser(user.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}