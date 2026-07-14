import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

ScreenSize getScreenSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return ScreenSize.mobile;
  if (width < 1024) return ScreenSize.tablet;
  return ScreenSize.desktop;
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize size) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, getScreenSize(context));
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T tablet;
  final T desktop;

  const ResponsiveValue({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  T resolve(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet;
      case ScreenSize.desktop:
        return desktop;
    }
  }
}

double responsiveFontSize(BuildContext context, {double? mobile, double? tablet, double? desktop}) {
  return ResponsiveValue<double>(
    mobile: mobile ?? 14,
    tablet: tablet ?? 16,
    desktop: desktop ?? 18,
  ).resolve(context);
}

EdgeInsets responsivePadding(BuildContext context) {
  switch (getScreenSize(context)) {
    case ScreenSize.mobile:
      return const EdgeInsets.all(12);
    case ScreenSize.tablet:
      return const EdgeInsets.all(20);
    case ScreenSize.desktop:
      return const EdgeInsets.all(28);
  }
}

int responsiveGridColumns(BuildContext context) {
  switch (getScreenSize(context)) {
    case ScreenSize.mobile:
      return 1;
    case ScreenSize.tablet:
      return 2;
    case ScreenSize.desktop:
      return 3;
  }
}
