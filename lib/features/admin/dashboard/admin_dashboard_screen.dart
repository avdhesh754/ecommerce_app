import 'package:cosmetic_ecommerce_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/utils/responsive_breakpoints.dart' as rb;
import 'controllers/dashboard_controller.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var currentPage = 'Dashboard'.obs;
  var navigationStack = <String>['Dashboard'].obs;
  var isDrawerOpen = false.obs;

  void selectMenuItem(int index, String pageName) {
    selectedIndex.value = index;
    currentPage.value = pageName;
    navigationStack.value = [pageName];
    update();
  }

  void navigateToPage(String pageName) {
    navigationStack.add(pageName);
    currentPage.value = pageName;
    update();
  }

  void navigateBack() {
    if (navigationStack.length > 1) {
      navigationStack.removeLast();
      currentPage.value = navigationStack.last;
      update();
    }
  }

  void toggleDrawer(GlobalKey<ScaffoldState> scaffoldKey, bool isDesktop) {
    if (isDesktop) return;

    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Get.back();
      isDrawerOpen.value = false;
    } else {
      scaffoldKey.currentState?.openDrawer();
      isDrawerOpen.value = true;
    }
  }

  void setDrawerState(bool isOpen) {
    isDrawerOpen.value = isOpen;
  }

}

// Main Dashboard Widget
class AdminDashboard extends StatelessWidget {

  AdminDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationController navController = Get.put(NavigationController());
  final DashboardController dashboardController = Get.put(DashboardController());
  final AuthController authController = Get.find<AuthController>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      onDrawerChanged: (isOpened) => navController.setDrawerState(isOpened),
      body: Row(
        children: [
          // Persistent sidebar for desktop and tablet
          if (rb.ResponsiveBreakpoints.isDesktopOrLarger(context) ||
              rb.ResponsiveBreakpoints.isTablet(context))
            SizedBox(
              width: rb.ResponsiveBreakpoints.getSidebarWidth(context),
              child: _buildSidebar(context, isPersistent: true),
            ),
          // Main Content
          Expanded(child: _buildMainContent(context)),
        ],
      ),
      // Drawer for mobile
      drawer: rb.ResponsiveBreakpoints.isMobile(context)
          ? _buildSidebar(context, isPersistent: false)
          : null,
    );
  }

  Widget _buildSidebar(BuildContext context, {required bool isPersistent}) {
    final menuItems = [
      {'icon': Icons.dashboard, 'title': 'Dashboard', 'index': 0},
      {'icon': Icons.admin_panel_settings, 'title': 'Admins', 'index': 1},
      {'icon': Icons.inventory, 'title': 'Products', 'index': 2},
      {'icon': Icons.shopping_cart, 'title': 'Orders', 'index': 3},
      {'icon': Icons.storage, 'title': 'Inventory', 'index': 4},
      {'icon': Icons.star, 'title': 'Reviews', 'index': 5},
      {'icon': Icons.category, 'title': 'Categories', 'index': 6},
    ];

    return Container(
      color: const Color(0xFF2A2A2A),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(20),
            child: const Row(
              children: [
                Icon(
                  Icons.face_retouching_natural,
                  color: Colors.pink,
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'Beauty Co',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = navController.selectedIndex.value == item['index'];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF3A3A3A)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item['icon'] as IconData,
                      color: isSelected ? Colors.white : Colors.grey[400],
                      size: 20,
                    ),
                    title: Text(
                      item['title'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    onTap: () {
                      navController.selectMenuItem(
                        item['index'] as int,
                        item['title'] as String,
                      );

                      // Close drawer only on mobile and only if it's not persistent
                      if (rb.ResponsiveBreakpoints.isMobile(context) && !isPersistent) {
                        Get.back();
                        navController.setDrawerState(false);
                      }
                    },
                  ),
                );
              },
            ),

            /// Obx(() => ),
          ),
          // Settings
          Container(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.settings, color: Colors.grey[400], size: 20),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              onTap: () {
                navController.navigateToPage('Settings');
                if (rb.ResponsiveBreakpoints.isMobile(context) && !isPersistent) {
                  Get.back();
                  navController.setDrawerState(false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with navigation
          _buildHeader(context),
          const SizedBox(height: 30),

          // Content based on current page
          Expanded(
            child: Obx(
              () => _buildPageContent(navController.currentPage.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          // Menu button for mobile
          if (rb.ResponsiveBreakpoints.isMobile(context))
            IconButton(
              key: const Key('menu_button'),
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => navController.toggleDrawer(
                _scaffoldKey,
                rb.ResponsiveBreakpoints.isDesktop(context),
              ),
            ),

          // Breadcrumb navigation
          Expanded(
            child: Row(
              children: [
                if (rb.ResponsiveBreakpoints.isMobile(context))
                  const SizedBox(width: 8),

                // Back button if we're deep in navigation
                if (navController.navigationStack.length > 1)
                  IconButton(
                    key: const Key('back_button'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => navController.navigateBack(),
                  ),

                // Page title
                Text(
                  navController.currentPage.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Breadcrumb trail
                if (navController.navigationStack.length > 1) ...[
                  const SizedBox(width: 10),
                  Text(
                    navController.navigationStack.join(' > '),
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => navController.navigateToPage('Notifications'),
              ),
              IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () async => await authController.logout(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(String currentPage) {
    switch (currentPage) {
      case 'Dashboard':
        return _buildDashboardContent();
      case 'Products':
        return _buildProductsContent();
      case 'Orders':
        return _buildOrdersContent();
      case 'Inventory':
        return _buildInventoryContent();
      case 'Product Details':
        return _buildProductDetailsContent();
      case 'Order Details':
        return _buildOrderDetailsContent();
      default:
        return _buildPlaceholderContent(currentPage);
    }
  }

  Widget _buildDashboardContent() {
    return Obx(() {
      if (dashboardController.isLoading) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.pink),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Metrics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => dashboardController.loadDashboardData(),
                ),
              ],
            ),
            const SizedBox(height: 15),

            _buildQuickMetrics(),
            const SizedBox(height: 30),

            // Revenue Trends
            _buildRevenueChart(),
            const SizedBox(height: 30),

            // Orders and Inventory
            _buildOrdersAndInventory(),
          ],
        ),
      );
    });
  }

  Widget _buildProductsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All Products',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => navController.navigateToPage('Add Product'),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                  title: Text(
                    'Product ${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'SKU: PRD00${index + 1}',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${(index + 1) * 25}.00',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                        onPressed: () =>
                            navController.navigateToPage('Product Details'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 15,
              itemBuilder: (context, index) {
                final statuses = [
                  'Pending',
                  'Shipped',
                  'Delivered',
                  'Cancelled',
                ];
                final status = statuses[index % statuses.length];

                return ListTile(
                  title: Text(
                    'Order #1234${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Customer ${index + 1}',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //_buildStatusBadge(status),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                        onPressed: () =>
                            navController.navigateToPage('Order Details'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryContent() {
    return const Center(
      child: Text(
        'Inventory Management',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildProductDetailsContent() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is a detailed view of the selected product. Here you can edit product information, manage inventory, view sales data, and more.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsContent() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is a detailed view of the selected order. Here you can update order status, view customer information, manage shipping, and more.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent(String pageName) {
    return Center(
      child: Text(
        pageName,
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  Widget _buildQuickMetrics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1024
            ? 3
            : (constraints.maxWidth > 768 ? 2 : 1);

        return Obx(
          () => GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 2.5,
            children: [
              _buildMetricCard(
                'Current Month Sales',
                '\$${dashboardController.totalRevenue.toStringAsFixed(0)}',
                '+15%',
                Colors.green,
              ),
              _buildMetricCard(
                'Pending Shipments',
                '${dashboardController.pendingOrders}',
                '-5%',
                Colors.red,
              ),
              _buildMetricCard(
                'Low Stock Alerts',
                '${dashboardController.lowStockProducts}',
                '+2%',
                Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String change,
    Color changeColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                change,
                style: TextStyle(
                  color: changeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Trends',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Revenue Over Time',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Obx(
            () => Row(
              children: [
                Text(
                  '\$${(dashboardController.totalRevenue * 2.67).toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Last 12 Months +10%',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                        ];
                        if (value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 4),
                      FlSpot(2, 3.5),
                      FlSpot(3, 5),
                      FlSpot(4, 4),
                      FlSpot(5, 6),
                      FlSpot(6, 5.5),
                    ],
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersAndInventory() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1024;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRecentOrders()),
              const SizedBox(width: 20),
              Expanded(child: _buildInventoryTable()),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRecentOrders(),
              const SizedBox(height: 20),
              _buildInventoryTable(),
            ],
          );
        }
      },
    );
  }

  Widget _buildRecentOrders() {
    final orders = [
      {
        'id': '#12345',
        'customer': 'Olivia Bennett',
        'date': '2024-07-20',
        'status': 'Shipped',
        'total': 150,
      },
      {
        'id': '#12346',
        'customer': 'Ethan Carter',
        'date': '2024-07-21',
        'status': 'Pending',
        'total': 200,
      },
      {
        'id': '#12347',
        'customer': 'Chloe Foster',
        'date': '2024-07-22',
        'status': 'Delivered',
        'total': 100,
      },
      {
        'id': '#12348',
        'customer': 'Owen Hayes',
        'date': '2024-07-23',
        'status': 'Shipped',
        'total': 180,
      },
      {
        'id': '#12349',
        'customer': 'Grace Mitchell',
        'date': '2024-07-24',
        'status': 'Pending',
        'total': 220,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Orders & Inventory',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
                ),
                children: [
                  _buildTableHeader('Order ID'),
                  _buildTableHeader('Customer'),
                  _buildTableHeader('Date'),
                  _buildTableHeader('Status'),
                  _buildTableHeader('Total'),
                ],
              ),
              ...orders.map(
                (order) => TableRow(
                  children: [
                    _buildTableCell(order['id'] as String),
                    _buildTableCell(order['customer'] as String),
                    _buildTableCell(order['date'] as String),
                    _buildTableCell(order['status'] as String),
                    _buildTableCell('\$${order['total']}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTable() {
    final inventory = [
      {'name': 'Product A', 'stock': 50, 'reorder': 20, 'status': 'In Stock'},
      {'name': 'Product B', 'stock': 15, 'reorder': 20, 'status': 'Low Stock'},
      {'name': 'Product C', 'stock': 100, 'reorder': 50, 'status': 'In Stock'},
      {
        'name': 'Product D',
        'stock': 5,
        'reorder': 10,
        'status': 'Out of Stock',
      },
      {'name': 'Product E', 'stock': 30, 'reorder': 25, 'status': 'In Stock'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
                ),
                children: [
                  _buildTableHeader('Product'),
                  _buildTableHeader('Stock Level'),
                  _buildTableHeader('Reorder Point'),
                  _buildTableHeader('Status'),
                ],
              ),
              ...inventory.map(
                (product) => TableRow(
                  children: [
                    _buildTableCell(product['name'] as String),
                    _buildTableCell(product['stock'].toString()),
                    _buildTableCell(product['reorder'].toString()),
                    _buildTableCell(product['status'] as String),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

}
