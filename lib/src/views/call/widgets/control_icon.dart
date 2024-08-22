import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallControlIcon extends StatelessWidget {
  const IsmCallControlIcon(
    this.iconPath, {
    super.key,
    this.isActive = true,
  });

  final String iconPath;
  final bool isActive;

  @override
  Widget build(BuildContext context) => SizedBox.square(
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
              iconPath,
              dimensions: IsmCallDimens.thirtyTwo,
              fromPackage: false,
            ),
          ),
        ),
      );
}

class IsmCallEndCall extends StatelessWidget {
  const IsmCallEndCall({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: IsmCallDimens.fifty,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: IsmCallColors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.call_end_rounded,
            color: IsmCallColors.white,
          ),
        ),
      );
}
