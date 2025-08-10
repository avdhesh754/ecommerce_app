import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_breakpoints.dart';
import '../../../shared/widgets/responsive_customer_layout.dart';
import '../../auth/presentation/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveCustomerLayout(
      currentRoute: '/profile',
      title: 'Profile',
      selectedIndex: 5,
      body: _buildProfileContent(context),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return SingleChildScrollView(
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveBreakpoints.getContentMaxWidth(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: ResponsiveBreakpoints.getValue(
                          context: context,
                          mobile: 40.0,
                          tablet: 50.0,
                          desktop: 60.0,
                        ),
                        backgroundColor: AppTheme.primaryColor,
                        child: Icon(
                          Icons.person,
                          size: ResponsiveBreakpoints.getValue(
                            context: context,
                            mobile: 40.0,
                            tablet: 50.0,
                            desktop: 60.0,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${authController.currentUser.value?.firstName ?? 'Customer'} ${authController.currentUser.value?.lastName ?? ''}',
                              style: TextStyle(
                                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 24),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              authController.currentUser.value?.email ?? 'customer@example.com',
                              style: TextStyle(
                                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (!ResponsiveBreakpoints.isMobile(context))
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Edit profile
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (ResponsiveBreakpoints.isMobile(context))
                        IconButton(
                          onPressed: () {
                            // Edit profile
                          },
                          icon: const Icon(Icons.edit),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Profile Options
              ResponsiveWidget(
                mobile: _buildMobileOptions(),
                tablet: _buildTabletDesktopOptions(context),
                desktop: _buildTabletDesktopOptions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileOptions() {
    return Column(
      children: [
        _buildOptionCard(
          icon: Icons.shopping_bag,
          title: 'My Orders',
          subtitle: 'View your order history',
          onTap: () => Get.toNamed('/orders'),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          icon: Icons.favorite,
          title: 'Wishlist',
          subtitle: 'Your saved items',
          onTap: () => Get.toNamed('/wishlist'),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          icon: Icons.location_on,
          title: 'Addresses',
          subtitle: 'Manage shipping addresses',
          onTap: () => Get.toNamed('/addresses'),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          icon: Icons.payment,
          title: 'Payment Methods',
          subtitle: 'Manage payment options',
          onTap: () => Get.toNamed('/payment-methods'),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'App preferences',
          onTap: () => Get.toNamed('/settings'),
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help with your account',
          onTap: () => Get.toNamed('/help'),
        ),
        const SizedBox(height: 24),
        _buildLogoutCard(),
      ],
    );
  }

  Widget _buildTabletDesktopOptions(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveBreakpoints.getValue(
            context: context,
            mobile: 2,
            tablet: 2,
            desktop: 3,
          ),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildOptionCard(
              icon: Icons.shopping_bag,
              title: 'My Orders',
              subtitle: 'View your order history',
              onTap: () => Get.toNamed('/orders'),
            ),
            _buildOptionCard(
              icon: Icons.favorite,
              title: 'Wishlist',
              subtitle: 'Your saved items',
              onTap: () => Get.toNamed('/wishlist'),
            ),
            _buildOptionCard(
              icon: Icons.location_on,
              title: 'Addresses',
              subtitle: 'Manage shipping addresses',
              onTap: () => Get.toNamed('/addresses'),
            ),
            _buildOptionCard(
              icon: Icons.payment,
              title: 'Payment Methods',
              subtitle: 'Manage payment options',
              onTap: () => Get.toNamed('/payment-methods'),
            ),
            _buildOptionCard(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'App preferences',
              onTap: () => Get.toNamed('/settings'),
            ),
            _buildOptionCard(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help with your account',
              onTap: () => Get.toNamed('/help'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildLogoutCard(),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutCard() {
    return Card(
      child: InkWell(
        onTap: () {
          final authController = Get.find<AuthController>();
          Get.dialog(
            AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    authController.logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 16),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}