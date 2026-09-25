import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Target responsive device categories based on academic lab guidelines:
/// - Mobile: < 600px
/// - Tablet: 600px – 1023px
/// - Desktop: >= 1024px
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// A comprehensive responsive utility and layout switcher.
/// Demonstrates:
/// - Responsive UI with LayoutBuilder & MediaQuery (Lab Experiments 3a & 3b)
/// - Clean breakpoint-driven UI scaling without code duplication
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Standard Breakpoints:
  /// Mobile: < 600px
  /// Tablet: 600px – 1023px
  /// Desktop: >= 1024px
  static const double mobileBreakpoint = AppConstants.mobileBreakpoint; // 600.0
  static const double tabletBreakpoint = AppConstants.tabletBreakpoint; // 1024.0

  // ==========================================
  // MEDIAQUERY-BASED HELPERS
  // ==========================================

  /// Checks if screen width is in Mobile range (< 600px)
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  /// Checks if screen width is in Tablet range (600px - 1023px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Checks if screen width is in Desktop range (>= 1024px)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  /// Returns the current DeviceType via MediaQuery
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletBreakpoint) return DeviceType.desktop;
    if (width >= mobileBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  /// Returns a responsive value of type [T] depending on screen width.
  /// Eliminates screen and widget duplication.
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletBreakpoint) {
      return desktop ?? tablet ?? mobile;
    }
    if (width >= mobileBreakpoint) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Returns responsive horizontal padding
  static EdgeInsets horizontalPadding(BuildContext context) {
    return value<EdgeInsets>(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 16.0),
      tablet: const EdgeInsets.symmetric(horizontal: 28.0),
      desktop: const EdgeInsets.symmetric(horizontal: 36.0),
    );
  }

  /// Returns responsive card grid column count
  static int cardColumnCount(BuildContext context) {
    return value<int>(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 2,
    );
  }

  // ==========================================
  // LAYOUTBUILDER-BASED BUILDERS
  // ==========================================

  /// Custom builder variant providing local constraints and screen DeviceType
  static Widget builder({
    required Widget Function(
      BuildContext context,
      BoxConstraints constraints,
      DeviceType deviceType,
    ) builder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = getDeviceType(context);
        return builder(context, constraints, deviceType);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }
}
