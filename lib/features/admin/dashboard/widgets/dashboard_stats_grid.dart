import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/responsive_breakpoints.dart';
import '../controllers/dashboard_controller.dart';
import 'admin_stats_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Obx(() => GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveBreakpoints.isDesktop(context) ? 4 : 2,
          crossAxisSpacing: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
          mainAxisSpacing: ResponsiveBreakpoints.getResponsiveSpacing(context, 16),
          childAspectRatio: 1.5,
          children: [
            AdminStatsCard(
              title: 'Total Users',
              value: controller.dashboardStats.value.totalUsers.toString(),
              icon: Icons.people,
              color: Colors.blue,
              trend: controller.dashboardStats.value.growthPercentage,
            ),
            AdminStatsCard(
              title: 'Total Products',
              value: controller.dashboardStats.value.totalProducts.toString(),
              icon: Icons.inventory,
              color: Colors.green,
              trend: 5.2,
            ),
            AdminStatsCard(
              title: 'Total Orders',
              value: controller.dashboardStats.value.totalOrders.toString(),
              icon: Icons.shopping_cart,
              color: Colors.orange,
              trend: 12.8,
            ),
            AdminStatsCard(
              title: 'Revenue',
              value: '\$${controller.dashboardStats.value.totalRevenue.toStringAsFixed(2)}',
              icon: Icons.attach_money,
              color: Colors.purple,
              trend: 8.1,
            ),
          ],
        ));
      },
    );
  }
}