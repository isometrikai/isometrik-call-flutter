import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallButton extends StatelessWidget {
  const IsmCallButton({
    super.key,
    this.onTap,
    required this.label,
    this.small = false,
    this.backgroundColor,
  })  : showBorder = false,
        _type = IsmCallButtonType.primary,
        icon = null,
        secondary = false;

  const IsmCallButton.secondary({
    super.key,
    this.onTap,
    required this.label,
    this.small = false,
    this.backgroundColor,
  })  : showBorder = false,
        _type = IsmCallButtonType.secondary,
        icon = null,
        secondary = false;

  const IsmCallButton.outlined({
    super.key,
    this.onTap,
    required this.label,
    this.small = false,
    this.backgroundColor,
  })  : showBorder = true,
        _type = IsmCallButtonType.outlined,
        icon = null,
        secondary = false;

  const IsmCallButton.icon({
    super.key,
    required this.icon,
    this.secondary = false,
    this.onTap,
    this.backgroundColor,
  })  : _type = IsmCallButtonType.icon,
        label = '',
        small = false,
        showBorder = false,
        assert(
          icon != null,
          'icon cannot be null for type `IsmCallButton.icon`',
        );

  final VoidCallback? onTap;
  final String label;
  final IsmCallButtonType _type;
  final bool small;
  final IconData? icon;
  final bool secondary;
  final bool showBorder;
  final Color? backgroundColor;

  static WidgetStateProperty<TextStyle?> _textStyle(
          BuildContext context, bool small) =>
      WidgetStateProperty.all(
        (small ? context.textTheme.labelSmall : context.textTheme.bodyMedium)
            ?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      );

  static WidgetStateProperty<EdgeInsetsGeometry?> _padding(
          BuildContext context, bool small) =>
      WidgetStateProperty.all(
        small ? IsmCallDimens.edgeInsets8_4 : IsmCallDimens.edgeInsets16_8,
      );

  static WidgetStateProperty<OutlinedBorder?> _borderRadius(
          BuildContext context) =>
      WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: context.callTheme?.buttonRadius ??
              BorderRadius.circular(IsmCallDimens.twentyFive),
        ),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _type == IsmCallButtonType.icon ? null : 48,
        width: _type == IsmCallButtonType.icon ? null : double.maxFinite,
        child: switch (_type) {
          IsmCallButtonType.primary => _Primary(
              label: label,
              onTap: onTap,
              small: small,
              showBorder: showBorder,
              backgroundColor: backgroundColor,
            ),
          IsmCallButtonType.secondary => _Secondary(
              label: label,
              onTap: onTap,
              small: small,
              showBorder: showBorder,
              backgroundColor: backgroundColor,
            ),
          IsmCallButtonType.outlined => _Outlined(
              label: label,
              onTap: onTap,
              small: small,
              showBorder: showBorder,
              backgroundColor: backgroundColor,
            ),
          IsmCallButtonType.icon => _Icon(
              icon: icon!,
              onTap: onTap,
              secondary: secondary,
              backgroundColor: backgroundColor,
            ),
        },
      );
}

class _Primary extends StatelessWidget {
  const _Primary({
    this.onTap,
    required this.label,
    this.small = false,
    this.showBorder = false,
    this.backgroundColor,
  });

  final VoidCallback? onTap;
  final String label;
  final bool small;
  final bool showBorder;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ButtonStyle(
          padding: IsmCallButton._padding(context, small),
          shape: IsmCallButton._borderRadius(context),
          backgroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.isDisabled) {
                return context.callTheme?.primaryButtonTheme?.disableColor ??
                    context.callTheme?.disableColor ??
                    IsmCallColors.grey;
              }
              return backgroundColor ??
                  context.callTheme?.primaryButtonTheme?.backgroundColor ??
                  context.theme.primaryColor;
            },
          ),
          foregroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.isDisabled) {
                return IsmCallColors.black;
              }
              return context.callTheme?.primaryButtonTheme?.foregroundColor ??
                  IsmCallColors.white;
            },
          ),
          textStyle: IsmCallButton._textStyle(context, small),
        ),
        onPressed: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      );
}

class _Secondary extends StatelessWidget {
  const _Secondary({
    this.onTap,
    required this.label,
    this.small = false,
    this.showBorder = false,
    this.backgroundColor,
  });

  final VoidCallback? onTap;
  final String label;
  final bool small;
  final bool showBorder;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ButtonStyle(
          padding: IsmCallButton._padding(context, small),
          shape: IsmCallButton._borderRadius(context),
          backgroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.isDisabled) {
                return context.callTheme?.secondaryButtonTheme?.disableColor ??
                    context.callTheme?.disableColor ??
                    IsmCallColors.grey;
              }
              return backgroundColor ??
                  context.callTheme?.secondaryButtonTheme?.backgroundColor ??
                  context.theme.canvasColor;
            },
          ),
          foregroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.isDisabled) {
                return IsmCallColors.black;
              }
              return context.callTheme?.secondaryButtonTheme?.foregroundColor ??
                  IsmCallColors.white;
            },
          ),
          textStyle: IsmCallButton._textStyle(context, small),
        ),
        onPressed: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      );
}

class _Outlined extends StatelessWidget {
  const _Outlined({
    this.onTap,
    required this.label,
    this.small = false,
    this.showBorder = false,
    this.backgroundColor,
  });

  final VoidCallback? onTap;
  final String label;
  final bool small;
  final bool showBorder;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: ButtonStyle(
          padding: IsmCallButton._padding(context, small),
          shape: IsmCallButton._borderRadius(context),
          elevation: const WidgetStatePropertyAll(0),
          side: showBorder
              ? WidgetStateProperty.resolveWith(
                  (states) {
                    var color = context
                            .callTheme?.outlinedButtonTheme?.foregroundColor ??
                        context.theme.primaryColor;
                    if (states.isDisabled) {
                      color = context
                              .callTheme?.outlinedButtonTheme?.disableColor ??
                          IsmCallColors.grey;
                    }
                    return BorderSide(color: color);
                  },
                )
              : null,
          backgroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.isDisabled) {
                return IsmCallColors.grey;
              }
              return backgroundColor ??
                  context.callTheme?.outlinedButtonTheme?.backgroundColor ??
                  context.theme.scaffoldBackgroundColor;
            },
          ),
          foregroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.isDisabled) {
                return IsmCallColors.grey;
              }
              return context.callTheme?.outlinedButtonTheme?.foregroundColor ??
                  context.theme.primaryColor;
            },
          ),
          textStyle: IsmCallButton._textStyle(context, small),
        ),
        onPressed: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      );
}

class _Icon extends StatelessWidget {
  const _Icon({
    this.onTap,
    required this.icon,
    this.secondary = false,
    this.backgroundColor,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final bool secondary;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => IconButton(
        style: ButtonStyle(
          shape: context.theme.elevatedButtonTheme.style?.shape ??
              WidgetStateProperty.all(
                RoundedRectangleBorder(
                  // borderRadius: context.liveTheme?.iconButtonRadius ?? BorderRadius.circular(IsmCallIsmCallDimens.sixteen),
                  borderRadius: BorderRadius.circular(IsmCallDimens.sixteen),
                ),
              ),
          backgroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.isDisabled) {
                return IsmCallColors.grey;
              }
              // final primaryColor = context.theme.elevatedButtonTheme.style?.backgroundColor?.resolve(states) ??
              //     context.liveTheme?.primaryColor ??
              //     IsmCallColors.primary;
              const primaryColor = IsmCallColors.primary;

              // final secondaryColor = context.liveTheme?.secondaryColor ?? IsmCallColors.secondary;
              const secondaryColor = IsmCallColors.secondary;

              return backgroundColor ??
                  (secondary ? secondaryColor : primaryColor);
            },
          ),
          foregroundColor: WidgetStateColor.resolveWith(
            (states) {
              if (states.isDisabled) {
                return IsmCallColors.black;
              }
              // final primaryColor = context.theme.elevatedButtonTheme.style?.foregroundColor?.resolve(states) ??
              //     context.liveTheme?.backgroundColor ??
              //     IsmCallColors.white;
              const primaryColor = IsmCallColors.white;
              // final secondaryColor = context.theme.elevatedButtonTheme.style?.backgroundColor?.resolve(states) ??
              //     context.liveTheme?.primaryColor ??
              //     IsmCallColors.primary;
              const secondaryColor = IsmCallColors.primary;

              return secondary ? secondaryColor : primaryColor;
            },
          ),
        ),
        onPressed: onTap,
        icon: Icon(icon),
      );
}
