import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ControlIconThemeData with Diagnosticable {
  const ControlIconThemeData({
    this.activeColor,
    this.inactiveColor,
  });

  final Color? activeColor;
  final Color? inactiveColor;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('activeColor', activeColor));
    properties.add(ColorProperty('inactiveColor', inactiveColor));
  }

  ControlIconThemeData lerp(covariant ControlIconThemeData? other, double t) {
    if (other is! ControlIconThemeData) {
      return this;
    }
    return ControlIconThemeData(
      activeColor: Color.lerp(activeColor, other.activeColor, t),
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t),
    );
  }

  ControlIconThemeData copyWith(
          {Color? activeColor,
          Color? inactiveColor,
          Color? disableColor,
          BorderRadius? borderRadius}) =>
      ControlIconThemeData(
        activeColor: activeColor ?? this.activeColor,
        inactiveColor: inactiveColor ?? this.inactiveColor,
      );
}
