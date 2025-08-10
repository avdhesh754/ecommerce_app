import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/responsive_breakpoints.dart';
import '../controllers/dashboard_controller.dart';

class TopProductsCard extends StatelessWidget {
  const TopProductsCard({super.key});

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
                  'Top Products',
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
                        final products = [
                          {'name': 'Moisturizing Cream', 'sales': 150, 'revenue': 3750.00},
                          {'name': 'Anti-Aging Serum', 'sales': 120, 'revenue': 4800.00},
                          {'name': 'Face Cleanser', 'sales': 200, 'revenue': 2400.00},
                        ];
                        
                        return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          product['name'].toString(),
                          style: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16)),
                        ),
                        subtitle: Text(
                          '${product['sales']} sold',
                          style: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14)),
                        ),
                        trailing: Text(
                          '\$${product['revenue']}',
                          style: TextStyle(
                            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
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
}