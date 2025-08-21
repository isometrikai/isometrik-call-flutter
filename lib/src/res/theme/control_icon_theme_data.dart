import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmCallControlIconThemeData with Diagnosticable {
  const IsmCallControlIconThemeData({
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

  IsmCallControlIconThemeData lerp(
    covariant IsmCallControlIconThemeData? other,
    double t,
  ) {
    if (other is! IsmCallControlIconThemeData) {
      return this;
    }
    return IsmCallControlIconThemeData(
      activeColor: Color.lerp(activeColor, other.activeColor, t),
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t),
    );
  }

  IsmCallControlIconThemeData copyWith({
    Color? activeColor,
    Color? inactiveColor,
    Color? disableColor,
    BorderRadius? borderRadius,
  }) =>
      IsmCallControlIconThemeData(
        activeColor: activeColor ?? this.activeColor,
        inactiveColor: inactiveColor ?? this.inactiveColor,
      );
}
