import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CallButtonThemeData with Diagnosticable {
  const CallButtonThemeData({
    this.foregroundColor,
    this.backgroundColor,
    this.disableColor,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? disableColor;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('foregroundColor', foregroundColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('disableColor', disableColor));
  }

  CallButtonThemeData lerp(covariant CallButtonThemeData? other, double t) {
    if (other is! CallButtonThemeData) {
      return this;
    }
    return CallButtonThemeData(
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      disableColor: Color.lerp(disableColor, other.disableColor, t),
    );
  }

  CallButtonThemeData copyWith(
          {Color? foregroundColor,
          Color? backgroundColor,
          Color? disableColor,
          BorderRadius? borderRadius}) =>
      CallButtonThemeData(
        foregroundColor: foregroundColor ?? this.foregroundColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        disableColor: disableColor ?? this.disableColor,
      );
}
