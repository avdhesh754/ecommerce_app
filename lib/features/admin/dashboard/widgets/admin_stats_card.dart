import 'package:flutter/material.dart';
import '../../../../../core/utils/responsive_breakpoints.dart';

class AdminStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double? trend;
  final String? subtitle;
  final VoidCallback? onTap;

  const AdminStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveBreakpoints.getResponsiveSize(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: ResponsiveBreakpoints.getResponsiveIconSize(context, 24),
                  ),
                  if (trend != null) _buildTrendIndicator(context),
                ],
              ),
              SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 24),
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 4)),
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                  color: Colors.grey[600],
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 4)),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(BuildContext context) {
    if (trend == null || trend == 0) return const SizedBox.shrink();
    
    final isPositive = trend! > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isPositive ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: ResponsiveBreakpoints.getResponsiveIconSize(context, 16),
            color: isPositive ? Colors.green[700] : Colors.red[700],
          ),
          const SizedBox(width: 2),
          Text(
            '${trend!.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 12),
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }
}