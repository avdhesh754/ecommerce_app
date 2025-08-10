import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ResponsiveText {
  static double getResponsiveTextSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth <= 550) {
      return baseSize * (1 + ((screenWidth - 375) / 1200) * 0.3);
    } else {
      return baseSize * (1 + ((screenWidth - 600) / 1200) * 0.2);
    }
  }

  // Heading Styles
  static Widget getHeading1(BuildContext context, String? text, {Color? color}) {
    final safeText = text ?? '';
    return Text(
      safeText.isNotEmpty ? safeText.capitalizeWords() : '',
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 32.0),
        fontWeight: FontWeight.bold,
        color: color ?? AppTheme.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }

  static Widget getHeading2(BuildContext context, String? text, {Color? color}) {
    final safeText = text ?? '';
    return Text(
      safeText.isNotEmpty ? safeText.capitalizeWords() : '',
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 24.0),
        fontWeight: FontWeight.bold,
        color: color ?? AppTheme.textPrimary,
        letterSpacing: -0.3,
      ),
    );
  }

  static Widget getHeading3(BuildContext context, String? text, {Color? color}) {
    final safeText = text ?? '';
    return Text(
      safeText.isNotEmpty ? safeText.capitalizeWords() : '',
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 20.0),
        fontWeight: FontWeight.w600,
        color: color ?? AppTheme.textPrimary,
        letterSpacing: 0,
      ),
    );
  }

  static Widget getHeading4(BuildContext context, String? text, {Color? color}) {
    final safeText = text ?? '';
    return Text(
      safeText.isNotEmpty ? safeText.capitalizeWords() : '',
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 18.0),
        fontWeight: FontWeight.w600,
        color: color ?? AppTheme.textPrimary,
        letterSpacing: 0,
      ),
    );
  }

  // Body Text Styles
  static Widget getBodyLarge(BuildContext context, String? text, {Color? color, TextAlign? textAlign}) {
    final safeText = text ?? '';
    return Text(
      safeText,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 16.0),
        fontWeight: FontWeight.w400,
        color: color ?? AppTheme.textPrimary,
        letterSpacing: 0.1,
        height: 1.4,
      ),
    );
  }

  static Widget getBodyMedium(BuildContext context, String? text, {Color? color, TextAlign? textAlign}) {
    final safeText = text ?? '';
    return Text(
      safeText,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 14.0),
        fontWeight: FontWeight.w400,
        color: color ?? AppTheme.textSecondary,
        letterSpacing: 0.1,
        height: 1.3,
      ),
    );
  }

  static Widget getBodySmall(BuildContext context, String? text, {Color? color, TextAlign? textAlign}) {
    final safeText = text ?? '';
    return Text(
      safeText,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 12.0),
        fontWeight: FontWeight.w400,
        color: color ?? AppTheme.textLight,
        letterSpacing: 0.2,
        height: 1.2,
      ),
    );
  }

  // Button Text
  static Widget getButtonText(BuildContext context, String? text, {Color? color}) {
    final safeText = text ?? '';
    return Text(
      safeText,
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 16.0),
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
        letterSpacing: 0.5,
      ),
    );
  }

  // Caption/Label Text
  static Widget getCaption(BuildContext context, String? text, {Color? color}) {
    final safeText = text ?? '';
    return Text(
      safeText,
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 10.0),
        fontWeight: FontWeight.w400,
        color: color ?? AppTheme.textLight,
        letterSpacing: 0.3,
      ),
    );
  }

  // Registration Title (your original method)
  static Widget getRegistrationTitle(BuildContext context, String? text) {
    final safeText = text ?? '';
    return Text(
      safeText.isNotEmpty ? safeText.capitalizeWords() : '',
      style: TextStyle(
        fontSize: getResponsiveTextSize(context, 18.0),
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: AppTheme.textPrimary,
      ),
    );
  }
}

extension StringCapitalization on String {
  String capitalizeWords() {
    return split(' ')
        .map((word) => word.isNotEmpty 
            ? word[0].toUpperCase() + word.substring(1).toLowerCase() 
            : word)
        .join(' ');
  }
}