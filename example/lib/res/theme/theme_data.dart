import 'package:flutter/material.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class CallThemeData {
  const CallThemeData({
    this.videoBackgroundColor,
    this.videoOffBackgroundColor,
    this.videoOffCardColor,
    this.disableColor,
    this.buttonRadius,
    this.primaryButtonTheme,
    this.secondaryButtonTheme,
    this.outlinedButtonTheme,
    this.controlIconTheme,
  });

  final Color? videoBackgroundColor;
  final Color? videoOffBackgroundColor;
  final Color? videoOffCardColor;
  final Color? disableColor;
  final BorderRadius? buttonRadius;
  final IsmCallButtonThemeData? primaryButtonTheme;
  final IsmCallButtonThemeData? secondaryButtonTheme;
  final IsmCallButtonThemeData? outlinedButtonTheme;
  final IsmCallControlIconThemeData? controlIconTheme;

  CallThemeData lerp(covariant CallThemeData? other, double t) {
    if (other is! CallThemeData) {
      return this;
    }
    return CallThemeData(
      videoBackgroundColor:
          Color.lerp(videoBackgroundColor, other.videoBackgroundColor, t),
      videoOffBackgroundColor:
          Color.lerp(videoOffBackgroundColor, other.videoOffBackgroundColor, t),
      videoOffCardColor:
          Color.lerp(videoOffCardColor, other.videoOffCardColor, t),
      disableColor: Color.lerp(disableColor, other.disableColor, t),
      buttonRadius: BorderRadius.lerp(buttonRadius, other.buttonRadius, t),
      primaryButtonTheme: primaryButtonTheme?.lerp(other.primaryButtonTheme, t),
      secondaryButtonTheme:
          secondaryButtonTheme?.lerp(other.secondaryButtonTheme, t),
      outlinedButtonTheme:
          outlinedButtonTheme?.lerp(other.outlinedButtonTheme, t),
      controlIconTheme: controlIconTheme?.lerp(other.controlIconTheme, t),
    );
  }

  CallThemeData copyWith({
    Color? videoBackgroundColor,
    Color? videoOffBackgroundColor,
    Color? videoOffCardColor,
    Color? disableColor,
    BorderRadius? buttonRadius,
    IsmCallButtonThemeData? primaryButtonTheme,
    IsmCallButtonThemeData? secondaryButtonTheme,
    IsmCallButtonThemeData? outlinedButtonTheme,
    IsmCallControlIconThemeData? controlIconTheme,
  }) =>
      CallThemeData(
        videoBackgroundColor: videoBackgroundColor ?? this.videoBackgroundColor,
        videoOffBackgroundColor:
            videoOffBackgroundColor ?? this.videoOffBackgroundColor,
        videoOffCardColor: videoOffCardColor ?? this.videoOffCardColor,
        disableColor: disableColor ?? this.disableColor,
        buttonRadius: buttonRadius ?? this.buttonRadius,
        primaryButtonTheme: primaryButtonTheme ?? this.primaryButtonTheme,
        secondaryButtonTheme: secondaryButtonTheme ?? this.secondaryButtonTheme,
        outlinedButtonTheme: outlinedButtonTheme ?? this.outlinedButtonTheme,
        controlIconTheme: controlIconTheme ?? this.controlIconTheme,
      );
}
