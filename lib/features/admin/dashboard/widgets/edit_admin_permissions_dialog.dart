import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/permissions.dart';
import '../../../../core/utils/responsive_breakpoints.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/models/user_model.dart';
import '../controllers/super_admin_controller.dart';

class EditAdminPermissionsDialog extends StatefulWidget {
  final UserModel admin;

  const EditAdminPermissionsDialog({
    super.key,
    required this.admin,
  });

  @override
  State<EditAdminPermissionsDialog> createState() => _EditAdminPermissionsDialogState();
}

class _EditAdminPermissionsDialogState extends State<EditAdminPermissionsDialog> {
  late Set<Permission> _selectedPermissions;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedPermissions = widget.admin.permissions
        .map((p) => Permission.fromString(p.name))
        .where((p) => p != null)
        .cast<Permission>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: ResponsiveBreakpoints.isDesktop(context) ? 600 : double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Permissions',
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.admin.fullName,
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current permissions summary
                    Container(
                      padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700]),
                          SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Status',
                                  style: TextStyle(
                                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  '${_selectedPermissions.length} permissions assigned',
                                  style: TextStyle(
                                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),
                    
                    // Permissions
                    Text(
                      'Available Permissions',
                      style: TextStyle(
                        fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                    
                    _buildPermissionsSection(),
                  ],
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _selectAllPermissions,
                    icon: const Icon(Icons.select_all),
                    label: const Text('Select All'),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                      CustomButton(
                        text: 'Update Permissions',
                        onPressed: _isLoading ? null : _updatePermissions,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSection() {
    return Column(
      children: PermissionGroup.groups.map((group) {
        final groupPermissions = group.permissions;
        final selectedInGroup = groupPermissions.where((p) => _selectedPermissions.contains(p)).length;
        
        return Card(
          margin: EdgeInsets.only(bottom: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
          child: ExpansionTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: selectedInGroup > 0 ? Colors.green[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$selectedInGroup/${groupPermissions.length}',
                    style: TextStyle(
                      fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: selectedInGroup > 0 ? Colors.green[700] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              group.description,
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                color: Colors.grey[600],
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
                child: Column(
                  children: [
                    // Group actions
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => _selectGroupPermissions(group, true),
                          icon: const Icon(Icons.check_box, size: 16),
                          label: const Text('Select All'),
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12)),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _selectGroupPermissions(group, false),
                          icon: const Icon(Icons.check_box_outline_blank, size: 16),
                          label: const Text('Clear All'),
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12)),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Individual permissions
                    ...group.permissions.map((permission) {
                      return CheckboxListTile(
                        title: Text(
                          permission.displayName,
                          style: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14)),
                        ),
                        value: _selectedPermissions.contains(permission),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value ?? false) {
                              _selectedPermissions.add(permission);
                            } else {
                              _selectedPermissions.remove(permission);
                            }
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _selectGroupPermissions(PermissionGroup group, bool select) {
    setState(() {
      if (select) {
        _selectedPermissions.addAll(group.permissions);
      } else {
        _selectedPermissions.removeWhere((p) => group.permissions.contains(p));
      }
    });
  }

  void _selectAllPermissions() {
    setState(() {
      _selectedPermissions.addAll(Permission.values);
    });
  }

  Future<void> _updatePermissions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = Get.find<SuperAdminController>();
      await controller.updateAdminPermissions(
        widget.admin.id,
        _selectedPermissions.map((p) => p.value).toList(),
      );
      
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}