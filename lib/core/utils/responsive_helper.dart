import 'package:flutter/material.dart';

/// Responsive layout helpers (AUD-038).
///
/// Centralizes breakpoints and adaptive builders so screens behave consistently
/// across mobile, tablet and landscape orientations instead of hard-coding
/// fixed sizes.
class ResponsiveHelper {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide < mobileMaxWidth;

  static bool isTablet(BuildContext context) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    return shortest >= mobileMaxWidth && shortest < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= tabletMaxWidth;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Number of grid columns based on available width (1–4).
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  /// Content max width for centered layouts (tables/forms).
  static double contentMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 900 ? 900 : width;
  }

  /// Returns a layout that switches between [mobile] and [tablet] builders.
  static Widget adaptive({
    required BuildContext context,
    required WidgetBuilder mobile,
    WidgetBuilder? tablet,
  }) {
    if (isMobile(context)) return mobile(context);
    return (tablet ?? mobile)(context);
  }
}
