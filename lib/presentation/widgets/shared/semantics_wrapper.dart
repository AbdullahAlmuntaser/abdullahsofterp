import 'package:flutter/material.dart';

class SemanticsWrapper extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final String? value;
  final SemanticsButton? button;
  final bool enabled;

  const SemanticsWrapper({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.value,
    this.button,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button != null,
      enabled: enabled,
      excludeSemantics: true,
      child: child,
    );
  }
}

class SemanticsButton extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback? onTap;

  const SemanticsButton({
    super.key,
    required this.child,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}

extension SemanticsExtension on Widget {
  Widget withSemantics(String label, {String? hint, String? value}) {
    return SemanticsWrapper(
      label: label,
      hint: hint,
      value: value,
      child: this,
    );
  }
}
