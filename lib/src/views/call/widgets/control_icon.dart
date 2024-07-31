import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmCallControlIcon extends StatelessWidget {
  const IsmCallControlIcon(
    this.control, {
    super.key,
    required this.isActive,
    this.onToggle,
  });

  final IsmCallControl control;
  final bool isActive;
  final void Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) => IsmCallTapHandler(
        onTap: () => onToggle?.call(!isActive),
        child: SizedBox.square(
          dimension: IsmCallDimens.fifty,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isActive
                  ? (context.callTheme?.controlIconTheme?.activeColor ??
                      context.theme.primaryColor)
                  : (context.callTheme?.controlIconTheme?.inactiveColor ??
                      context.theme.scaffoldBackgroundColor),
              shape: BoxShape.circle,
            ),
            child: UnconstrainedBox(
              child: IsmCallImage.svg(
                isActive ? control.icon : control.iconOff,
                dimensions: IsmCallDimens.thirtyTwo,
                fromPackage: false,
              ),
            ),
          ),
        ),
      );
}
