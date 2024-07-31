import 'package:flutter/material.dart';

class TapHandler extends StatelessWidget {
  const TapHandler({
    super.key,
    this.onTap,
    this.behavior,
    this.onLongPress,
    this.onDoubleTap,
    required this.child,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final HitTestBehavior? behavior;
  final Widget child;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        hitTestBehavior: behavior ?? HitTestBehavior.translucent,
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          behavior: behavior ?? HitTestBehavior.translucent,
          child: child,
        ),
      );
}
