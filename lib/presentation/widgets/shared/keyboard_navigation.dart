import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardNavigationWrapper extends StatelessWidget {
  final Widget child;

  const KeyboardNavigationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: child,
    );
  }
}

class FormKeyboardHandler extends StatefulWidget {
  final Widget child;

  const FormKeyboardHandler({super.key, required this.child});

  @override
  State<FormKeyboardHandler> createState() => _FormKeyboardHandlerState();
}

class _FormKeyboardHandlerState extends State<FormKeyboardHandler> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.enter): _focusNext,
          const SingleActivator(LogicalKeyboardKey.tab): _focusNext,
        },
        child: widget.child,
      ),
    );
  }

  void _focusNext() {
    FocusScope.of(context).nextFocus();
  }
}
