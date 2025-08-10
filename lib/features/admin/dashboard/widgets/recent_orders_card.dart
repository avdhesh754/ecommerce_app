import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/responsive_breakpoints.dart';
import '../controllers/dashboard_controller.dart';

class RecentOrdersCard extends StatelessWidget {
  const RecentOrdersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Builder(
                      builder: (context) {
                        // Mock data for now
                        final orders = [
                          {'id': '#12345', 'customer': 'John Doe', 'amount': 150.00, 'status': 'Shipped'},
                          {'id': '#12346', 'customer': 'Jane Smith', 'amount': 200.00, 'status': 'Pending'},
                          {'id': '#12347', 'customer': 'Bob Johnson', 'amount': 100.00, 'status': 'Delivered'},
                        ];
                        
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orders.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return ListTile(
                        title: Text(
                          'Order ${order['id']}',
                          style: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16)),
                        ),
                        subtitle: Text(
                          order['customer'].toString(),
                          style: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14)),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${order['amount']}',
                              style: TextStyle(
                                fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order['status'].toString()),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order['status'].toString(),
                                style: TextStyle(
                                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                        );
                      },
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}