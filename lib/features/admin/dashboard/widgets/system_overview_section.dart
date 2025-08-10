import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/responsive_breakpoints.dart';
import '../controllers/super_admin_controller.dart';

class SystemOverviewSection extends StatelessWidget {
  const SystemOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SuperAdminController>(
      builder: (controller) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Overview',
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                Obx(() {
                  final stats = controller.dashboardStats.value;
                  final health = stats.systemHealth;
                  
                  return Column(
                    children: [
                      _buildHealthIndicator('Database', health['database'] ?? true,context),
                      _buildHealthIndicator('API', health['api'] ?? true,context),
                      _buildHealthIndicator('Cache', health['cache'] ?? true,context),
                      _buildHealthIndicator('Storage', health['storage'] ?? true,context),
                      SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMetric('Uptime', health['uptime'] ?? '99.9%',context),
                          _buildMetric('Response Time', health['responseTime'] ?? '45ms',context),
                          _buildMetric('Memory Usage', health['memoryUsage'] ?? '67%',context),
                        ],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthIndicator(String service, bool isHealthy, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveBreakpoints.getResponsiveSpacing(context, 4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            service,
            style: TextStyle(fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16)),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isHealthy ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: ResponsiveBreakpoints.getResponsiveSpacing(context, 4)),
              Text(
                isHealthy ? 'Healthy' : 'Error',
                style: TextStyle(
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                  color: isHealthy ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}