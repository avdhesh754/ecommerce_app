import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/permissions.dart';
import '../../../../core/utils/responsive_breakpoints.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../controllers/super_admin_controller.dart';

class CreateAdminDialog extends StatefulWidget {
  const CreateAdminDialog({super.key});

  @override
  State<CreateAdminDialog> createState() => _CreateAdminDialogState();
}

class _CreateAdminDialogState extends State<CreateAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Set<Permission> _selectedPermissions = {};
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                  Text(
                    'Create New Admin',
                    style: TextStyle(
                      fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      Text(
                        'Basic Information',
                        style: TextStyle(
                          fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                      
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _firstNameController,
                              label: 'First Name',
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'First name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                          Expanded(
                            child: CustomTextField(
                              controller: _lastNameController,
                              label: 'Last Name',
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Last name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                      
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Email is required';
                          }
                          if (!GetUtils.isEmail(value!)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                      
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Password is required';
                          }
                          if (value!.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                      
                      CustomTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 24)),
                      
                      // Permissions
                      Text(
                        'Permissions',
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
            ),
            
            // Footer
            Container(
              padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                  CustomButton(
                    text: 'Create Admin',
                    onPressed: _isLoading ? null : _createAdmin,
                    isLoading: _isLoading,
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
        return Card(
          margin: EdgeInsets.only(bottom: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
          child: ExpansionTile(
            title: Text(
              group.name,
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                fontWeight: FontWeight.w500,
              ),
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
                  children: group.permissions.map((permission) {
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
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _createAdmin() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedPermissions.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one permission',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final controller = Get.find<SuperAdminController>();
      await controller.createAdmin(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        permissions: _selectedPermissions.map((p) => p.value).toList(),
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