import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

/// Provides consistent breakpoints and utilities for responsive design
class ResponsiveBreakpoints {
  // Breakpoint values
  static const double mobile = 768;
  static const double tablet = 1024;
  static const double desktop = 1440;
  static const double largeDesktop = 1920;

  /// Platform detection methods
  /// Check if the current platform is web
  static bool get isWeb => kIsWeb;

  /// Check if the current platform is mobile (iOS or Android)
  static bool get isMobilePlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  /// Check if the current platform is desktop (Windows, macOS, or Linux)
  static bool get isDesktopPlatform {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  /// Check if the current platform is iOS
  static bool get isIOS {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Check if the current platform is Android
  static bool get isAndroid {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android;
  }

  /// Core responsive size calculation function
  /// Scales sizes based on screen width with different ratios for mobile and larger screens
  static double getResponsiveSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth <= 550) {
      return baseSize * (1 + ((screenWidth - 375) / 1200) * 0.3);
    } else {
      return baseSize * (1 + ((screenWidth - 600) / 1200) * 0.2);
    }
  }

  /// Check if the current screen size is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  /// Check if the current screen size is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  /// Check if the current screen size is desktop
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tablet && width < largeDesktop;
  }

  /// Check if the current screen size is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktop;
  }

  /// Check if the current screen size is tablet or larger
  static bool isTabletOrLarger(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobile;
  }

  /// Check if the current screen size is desktop or larger
  static bool isDesktopOrLarger(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }

  /// Get the current screen type
  static ResponsiveScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return ResponsiveScreenType.mobile;
    if (width < tablet) return ResponsiveScreenType.tablet;
    if (width < largeDesktop) return ResponsiveScreenType.desktop;
    return ResponsiveScreenType.largeDesktop;
  }

  /// Get responsive value based on screen size
  /// This maintains the original method for cases where different values are needed per breakpoint
  static T getValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    final screenType = getScreenType(context);
    switch (screenType) {
      case ResponsiveScreenType.mobile:
        return mobile;
      case ResponsiveScreenType.tablet:
        return tablet ?? mobile;
      case ResponsiveScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ResponsiveScreenType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive padding using the responsive size function
  static EdgeInsets getResponsivePadding(BuildContext context, {double base = 16.0}) {
    final padding = getResponsiveSize(context, base);
    return EdgeInsets.all(padding);
  }

  /// Get responsive horizontal padding
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context, {double base = 16.0}) {
    final padding = getResponsiveSize(context, base);
    return EdgeInsets.symmetric(horizontal: padding);
  }

  /// Get responsive vertical padding
  static EdgeInsets getResponsiveVerticalPadding(BuildContext context, {double base = 16.0}) {
    final padding = getResponsiveSize(context, base);
    return EdgeInsets.symmetric(vertical: padding);
  }

  /// Get responsive symmetric padding
  static EdgeInsets getResponsiveSymmetricPadding(
      BuildContext context, {
        double horizontalBase = 16.0,
        double verticalBase = 16.0,
      }) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveSize(context, horizontalBase),
      vertical: getResponsiveSize(context, verticalBase),
    );
  }

  /// Get responsive margin using the responsive size function
  static EdgeInsets getResponsiveMargin(BuildContext context, {double base = 8.0}) {
    final margin = getResponsiveSize(context, base);
    return EdgeInsets.all(margin);
  }

  /// Get responsive font size using the responsive size function
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    return getResponsiveSize(context, baseFontSize);
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    return getResponsiveSize(context, baseSize);
  }

  /// Get responsive height
  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    return getResponsiveSize(context, baseHeight);
  }

  /// Get responsive width
  static double getResponsiveWidth(BuildContext context, double baseWidth) {
    return getResponsiveSize(context, baseWidth);
  }

  /// Get responsive radius
  static double getResponsiveRadius(BuildContext context, double baseRadius) {
    return getResponsiveSize(context, baseRadius);
  }

  /// Get responsive border radius
  static BorderRadius getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    final radius = getResponsiveSize(context, baseRadius);
    return BorderRadius.circular(radius);
  }

  /// Get responsive spacing (for SizedBox, gaps, etc.)
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    return getResponsiveSize(context, baseSpacing);
  }

  /// Get responsive elevation
  static double getResponsiveElevation(BuildContext context, double baseElevation) {
    // Elevation scales less dramatically than other properties
    double screenWidth = MediaQuery.sizeOf(context).width;
    if (screenWidth <= 550) {
      return baseElevation * (1 + ((screenWidth - 375) / 1200) * 0.1);
    } else {
      return baseElevation * (1 + ((screenWidth - 600) / 1200) * 0.05);
    }
  }

  /// Get responsive grid column count
  static int getGridColumnCount(BuildContext context, {
    int mobileColumns = 2,
    int tabletColumns = 3,
    int desktopColumns = 4,
    int largeDesktopColumns = 5,
  }) {
    return getValue(
      context: context,
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
      largeDesktop: largeDesktopColumns,
    );
  }

  /// Get responsive aspect ratio for containers
  static double getResponsiveAspectRatio(BuildContext context, double baseRatio) {
    // Aspect ratios typically don't need scaling
    return baseRatio;
  }

  /// Get responsive sidebar width
  static double getSidebarWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return 0; // No sidebar on mobile
    return getResponsiveSize(context, 250);
  }

  /// Get responsive content max width
  static double getContentMaxWidth(BuildContext context) {
    return getValue(
      context: context,
      mobile: double.infinity,
      tablet: 768,
      desktop: 1200,
      largeDesktop: 1400,
    );
  }

  /// Get responsive button height
  static double getResponsiveButtonHeight(BuildContext context, {double base = 48.0}) {
    return getResponsiveSize(context, base);
  }

  /// Get responsive text style with scaled font size
  static TextStyle getResponsiveTextStyle(
      BuildContext context, {
        required double baseFontSize,
        FontWeight? fontWeight,
        Color? color,
        double? letterSpacing,
        double? height,
      }) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, baseFontSize),
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing != null ? getResponsiveSize(context, letterSpacing) : null,
      height: height,
    );
  }
}

/// Screen type enumeration - renamed to avoid conflict with GetX
enum ResponsiveScreenType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// ResponsiveBuilder widget that rebuilds based on screen size changes
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveScreenType screenType) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = ResponsiveBreakpoints.getScreenType(context);
        return builder(context, screenType);
      },
    );
  }
}

/// ResponsiveWidget that shows different widgets based on screen size
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        switch (screenType) {
          case ResponsiveScreenType.mobile:
            return mobile;
          case ResponsiveScreenType.tablet:
            return tablet ?? mobile;
          case ResponsiveScreenType.desktop:
            return desktop ?? tablet ?? mobile;
          case ResponsiveScreenType.largeDesktop:
            return largeDesktop ?? desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

/// Responsive sized box that scales with screen size
class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const ResponsiveSizedBox({
    super.key,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? ResponsiveBreakpoints.getResponsiveSize(context, width!) : null,
      height: height != null ? ResponsiveBreakpoints.getResponsiveSize(context, height!) : null,
      child: child,
    );
  }
}

/// Responsive container with automatic scaling
class ResponsiveContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final Widget? child;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.child,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? ResponsiveBreakpoints.getResponsiveSize(context, width!) : null,
      height: height != null ? ResponsiveBreakpoints.getResponsiveSize(context, height!) : null,
      padding: padding,
      margin: margin,
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}

/// Extension methods for easy responsive sizing
extension ResponsiveExtension on num {
  /// Convert number to responsive size
  double responsive(BuildContext context) {
    return ResponsiveBreakpoints.getResponsiveSize(context, toDouble());
  }

  /// Convert number to responsive width
  double rw(BuildContext context) {
    return ResponsiveBreakpoints.getResponsiveWidth(context, toDouble());
  }

  /// Convert number to responsive height
  double rh(BuildContext context) {
    return ResponsiveBreakpoints.getResponsiveHeight(context, toDouble());
  }

  /// Convert number to responsive font size
  double rf(BuildContext context) {
    return ResponsiveBreakpoints.getResponsiveFontSize(context, toDouble());
  }

  /// Convert number to responsive spacing
  double rs(BuildContext context) {
    return ResponsiveBreakpoints.getResponsiveSpacing(context, toDouble());
  }

  /// Convert number to responsive padding
  EdgeInsets rp(BuildContext context) {
    return ResponsiveBreakpoints.getResponsivePadding(context, base: toDouble());
  }
}

/// Extension methods for BuildContext to add platform and responsive utilities
extension BuildContextExtensions on BuildContext {
  /// Check if the current platform is web
  bool get isWeb {
    return ResponsiveBreakpoints.isWeb;
  }

  /// Check if the current platform is mobile (iOS or Android)
  bool get isMobile {
    return ResponsiveBreakpoints.isMobilePlatform;
  }

  /// Check if the current platform is desktop (Windows, macOS, or Linux)
  bool get isDesktop {
    return ResponsiveBreakpoints.isDesktopPlatform;
  }

  /// Get the current screen type based on screen width
  ResponsiveScreenType get screenType {
    return ResponsiveBreakpoints.getScreenType(this);
  }

  /// Check if screen width is mobile size
  bool get isMobileScreen {
    return ResponsiveBreakpoints.isMobile(this);
  }

  /// Check if screen width is tablet size
  bool get isTabletScreen {
    return ResponsiveBreakpoints.isTablet(this);
  }

  /// Check if screen width is desktop size
  bool get isDesktopScreen {
    return ResponsiveBreakpoints.isDesktop(this);
  }

  /// Check if screen width is large desktop size
  bool get isLargeDesktopScreen {
    return ResponsiveBreakpoints.isLargeDesktop(this);
  }

  /// Check if screen width is tablet or larger
  bool get isTabletOrLarger {
    return ResponsiveBreakpoints.isTabletOrLarger(this);
  }

  /// Check if screen width is desktop or larger
  bool get isDesktopOrLarger {
    return ResponsiveBreakpoints.isDesktopOrLarger(this);
  }
}