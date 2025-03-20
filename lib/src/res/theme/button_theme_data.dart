import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmCallButtonThemeData with Diagnosticable {
  const IsmCallButtonThemeData({
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

  IsmCallButtonThemeData lerp(
    covariant IsmCallButtonThemeData? other,
    double t,
  ) {
    if (other is! IsmCallButtonThemeData) {
      return this;
    }
    return IsmCallButtonThemeData(
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      disableColor: Color.lerp(disableColor, other.disableColor, t),
    );
  }

  IsmCallButtonThemeData copyWith({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disableColor,
    BorderRadius? borderRadius,
  }) =>
      IsmCallButtonThemeData(
        foregroundColor: foregroundColor ?? this.foregroundColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        disableColor: disableColor ?? this.disableColor,
      );
}
