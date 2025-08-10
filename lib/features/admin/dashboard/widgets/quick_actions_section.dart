// Professional Action Button
import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_breakpoints.dart';

class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isPrimary;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(
          ResponsiveBreakpoints.getResponsiveRadius(context, 12),
        ),
        child: Container(
          padding: EdgeInsets.all(
            ResponsiveBreakpoints.getResponsiveSize(context, 16),
          ),
          decoration: BoxDecoration(
            color: isPrimary ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveBreakpoints.getResponsiveRadius(context, 12),
            ),
            border: isPrimary ? null : Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ResponsiveBreakpoints.getResponsiveIconSize(context, 28),
                color: isPrimary ? Colors.white : color,
              ),
              SizedBox(height: ResponsiveBreakpoints.getResponsiveSpacing(context, 8)),
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 14),
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}