import 'package:call_qwik_example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AvailabilitySwitch extends StatelessWidget {
  const AvailabilitySwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.color,
    this.showDecoration = true,
    this.showLabel = true,
    this.padding,
  });

  final bool showLabel;
  final bool showDecoration;
  final EdgeInsets? padding;
  final Color? color;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) => TapHandler(
        onTap: () => onChanged?.call(!value),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? CallColors.cardLight,
            borderRadius: BorderRadius.circular(Dimens.hundred),
          ),
          child: Padding(
            padding: padding ?? Dimens.edgeInsets2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                  applyTheme: true,
                  inactiveTrackColor:
                      context.theme.switchTheme.trackColor?.resolve(
                            {...WidgetState.values},
                          ) ??
                          CallColors.red,
                  activeTrackColor:
                      context.theme.switchTheme.overlayColor?.resolve(
                            {...WidgetState.values},
                          ) ??
                          CallColors.green,
                ),
                Dimens.boxWidth2,
                Text(
                  value ? 'Online' : 'Offline',
                  style: context.textTheme.bodyMedium,
                ),
                Dimens.boxWidth8,
              ],
            ),
          ),
        ),
      );
}
