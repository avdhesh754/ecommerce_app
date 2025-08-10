import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_breakpoints.dart';
import '../../../shared/widgets/responsive_sizes.dart';

class ResponsiveAdminLayout extends StatefulWidget {
  final Widget body;
  final String currentRoute;
  final String title;

  const ResponsiveAdminLayout({
    super.key,
    required this.body,
    required this.currentRoute,
    required this.title,
  });

  @override
  State<ResponsiveAdminLayout> createState() => _ResponsiveAdminLayoutState();
}

class _ResponsiveAdminLayoutState extends State<ResponsiveAdminLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopTabletLayout(
        isTablet: ResponsiveBreakpoints.isTablet(context),
      );
    }
  }

  // Mobile Layout - Uses drawer that can be opened/closed
  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          _buildProfileAction(),
        ],
      ),
      drawer: _buildDrawer(isMobile: true),
      body: widget.body,
    );
  }

  // Desktop/Tablet Layout - Fixed sidebar + content area
  Widget _buildDesktopTabletLayout({required bool isTablet}) {
    return Scaffold(
      body: Row(
        children: [
          // Fixed Sidebar
          Container(
            width: ResponsiveBreakpoints.getSidebarWidth(context),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: _buildSidebar(isTablet: isTablet),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(isTablet: isTablet),
                // Content
                Expanded(child: widget.body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar({required bool isTablet}) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 24,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          _buildProfileAction(),
        ],
      ),
    );
  }

  Widget _buildDrawer({required bool isMobile}) {
    return Drawer(
      child: _buildSidebar(isMobile: isMobile),
    );
  }

  Widget _buildSidebar({bool isMobile = false, bool isTablet = false}) {
    return Container(
      color: AppTheme.primaryColor,
      child: Column(
        children: [
          // Header
          Container(
            height: isMobile ? 120 : 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: isMobile ? 25 : 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: isMobile ? 30 : 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/admin/dashboard',
                  isMobile: isMobile,
                ),
                _buildNavItem(
                  icon: Icons.inventory_2_outlined,
                  selectedIcon: Icons.inventory_2,
                  title: 'Products',
                  route: '/admin/products',
                  isMobile: isMobile,
                ),
                _buildNavItem(
                  icon: Icons.people_outline,
                  selectedIcon: Icons.people,
                  title: 'Users',
                  route: '/admin/users',
                  isMobile: isMobile,
                ),
                _buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  selectedIcon: Icons.shopping_cart,
                  title: 'Orders',
                  route: '/admin/orders',
                  isMobile: isMobile,
                ),
                _buildNavItem(
                  icon: Icons.category_outlined,
                  selectedIcon: Icons.category,
                  title: 'Categories',
                  route: '/admin/categories',
                  isMobile: isMobile,
                ),
                _buildNavItem(
                  icon: Icons.reviews_outlined,
                  selectedIcon: Icons.reviews,
                  title: 'Reviews',
                  route: '/admin/reviews',
                  isMobile: isMobile,
                ),
                _buildNavItem(
                  icon: Icons.analytics_outlined,
                  selectedIcon: Icons.analytics,
                  title: 'Analytics',
                  route: '/admin/analytics',
                  isMobile: isMobile,
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings,
                  title: 'Settings',
                  route: '/admin/settings',
                  isMobile: isMobile,
                ),
              ],
            ),
          ),
          // Logout
          if (isMobile) ...[
            const Divider(color: Colors.white24),
            _buildNavItem(
              icon: Icons.logout_outlined,
              selectedIcon: Icons.logout,
              title: 'Logout',
              route: '/logout',
              isMobile: isMobile,
              isLogout: true,
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required String route,
    required bool isMobile,
    bool isLogout = false,
  }) {
    final isSelected = widget.currentRoute == route;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (isLogout) {
              _handleLogout();
            } else {
              _navigateToRoute(route, isMobile);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withValues(alpha: 0.1) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: Colors.white,
                  size: isMobile ? 22 : 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAction() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'profile':
            Get.toNamed('/admin/profile');
            break;
          case 'settings':
            Get.toNamed('/admin/settings');
            break;
          case 'logout':
            _handleLogout();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_outlined, color: Colors.red),
              SizedBox(width: 8),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: const CircleAvatar(
        radius: 18,
        backgroundColor: AppTheme.primaryColor,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _navigateToRoute(String route, bool isMobile) {
    // Close drawer on mobile after navigation
    if (isMobile && _scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
    
    // Navigate to the route
    Get.offNamed(route);
  }

  void _handleLogout() {
    // Show confirmation dialog
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
              // Handle logout logic here
              Get.offAllNamed('/login');
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
  }
}