import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive_breakpoints.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

class ResponsiveCustomerLayout extends StatefulWidget {
  final Widget body;
  final String currentRoute;
  final String title;
  final int selectedIndex;

  const ResponsiveCustomerLayout({
    super.key,
    required this.body,
    required this.currentRoute,
    required this.title,
    required this.selectedIndex,
  });

  @override
  State<ResponsiveCustomerLayout> createState() => _ResponsiveCustomerLayoutState();
}

class _ResponsiveCustomerLayoutState extends State<ResponsiveCustomerLayout> {
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

  // Mobile Layout - Uses bottom navigation bar, no left sidebar
  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {

            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Get.toNamed('/cart'),
          ),
          _buildProfileAction(),
        ],
      ),
      body: widget.body,
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // Desktop/Tablet Layout - Fixed left sidebar + content area
  Widget _buildDesktopTabletLayout({required bool isTablet}) {
    return Scaffold(
      body: Row(
        children: [
          // Fixed Left Sidebar - Always visible on desktop/tablet
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
            child: _buildLeftSidebar(isTablet: isTablet),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                _buildTopBar(isTablet: isTablet),
                // Content - This is the only area that changes
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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.toNamed('/cart'),
          ),
          const SizedBox(width: 12),
          _buildProfileAction(),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar({bool isTablet = false}) {
    
    return Container(
      color: AppTheme.primaryColor,
      child: Column(
        children: [
          // Header
          Container(
            height: 140,
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
                  radius: isTablet ? 25 : 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Icon(
                    Icons.person,
                    size: isTablet ? 30 : 35,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome,',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isTablet ? 14 : 16,
                  ),
                ),
                Text(
                  Get.find<AuthController>().currentUser.value?.firstName ?? 'Customer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16 : 18,
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
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  title: 'Home',
                  route: '/home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.shopping_bag_outlined,
                  selectedIcon: Icons.shopping_bag,
                  title: 'Products',
                  route: '/products',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  selectedIcon: Icons.shopping_cart,
                  title: 'Cart',
                  route: '/cart',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.receipt_long_outlined,
                  selectedIcon: Icons.receipt_long,
                  title: 'Orders',
                  route: '/orders',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.favorite_outline,
                  selectedIcon: Icons.favorite,
                  title: 'Wishlist',
                  route: '/wishlist',
                  index: 4,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  title: 'Profile',
                  route: '/profile',
                  index: 5,
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24),
                _buildNavItem(
                  icon: Icons.help_outline,
                  selectedIcon: Icons.help,
                  title: 'Help & Support',
                  route: '/help',
                  index: 6,
                ),
                _buildNavItem(
                  icon: Icons.logout_outlined,
                  selectedIcon: Icons.logout,
                  title: 'Logout',
                  route: '/logout',
                  index: -1,
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required String route,
    required int index,
    bool isLogout = false,
  }) {
    final isSelected = widget.selectedIndex == index;
    
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
              _navigateToRoute(route);
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
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedIndex >= 0 && widget.selectedIndex <= 5 ? widget.selectedIndex : 0,
      onTap: _handleBottomNavigation,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildProfileAction() {
    final authController = Get.find<AuthController>();
    
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'profile':
            Get.toNamed('/profile');
            break;
          case 'orders':
            Get.toNamed('/orders');
            break;
          case 'wishlist':
            Get.toNamed('/wishlist');
            break;
          case 'help':
            Get.toNamed('/help');
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
          value: 'orders',
          child: Row(
            children: [
              Icon(Icons.receipt_long_outlined),
              SizedBox(width: 8),
              Text('Orders'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'wishlist',
          child: Row(
            children: [
              Icon(Icons.favorite_outline),
              SizedBox(width: 8),
              Text('Wishlist'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'help',
          child: Row(
            children: [
              Icon(Icons.help_outline),
              SizedBox(width: 8),
              Text('Help & Support'),
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
      child: CircleAvatar(
        radius: 18,
        backgroundColor: MediaQuery.of(context).size.width < 768 
            ? Colors.white.withValues(alpha: 0.2)
            : AppTheme.primaryColor,
        child: const Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  void _navigateToRoute(String route) {
    Get.offNamed(route);
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        Get.offNamed('/home');
        break;
      case 1:
        Get.offNamed('/products');
        break;
      case 2:
        Get.offNamed('/cart');
        break;
      case 3:
        Get.offNamed('/orders');
        break;
      case 4:
        Get.offNamed('/wishlist');
        break;
      case 5:
        Get.offNamed('/profile');
        break;
    }
  }

  void _handleLogout() {
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
  }
}