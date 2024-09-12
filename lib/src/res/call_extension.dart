import 'package:flutter/material.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallExtension extends ThemeExtension<IsmCallExtension> {
  const IsmCallExtension({
    IsmCallThemeData? theme,
    IsmCallPropertiesData? properties,
    IsmCallTranslationsData? translations,
  })  : theme = theme ?? const IsmCallThemeData(),
        properties = properties ?? const IsmCallPropertiesData(),
        translations = translations ?? const IsmCallTranslationsData();

  final IsmCallThemeData theme;
  final IsmCallPropertiesData properties;
  final IsmCallTranslationsData translations;

  @override
  ThemeExtension<IsmCallExtension> lerp(
    covariant ThemeExtension<IsmCallExtension>? other,
    double t,
  ) {
    if (other is! IsmCallExtension) {
      return this;
    }
    return IsmCallExtension(
      theme: theme.lerp(other.theme, t),
      properties: properties.lerp(other.properties, t),
      translations: translations.lerp(other.translations, t),
    );
  }

  @override
  IsmCallExtension copyWith({
    IsmCallThemeData? theme,
    IsmCallPropertiesData? properties,
    IsmCallTranslationsData? translations,
  }) =>
      IsmCallExtension(
        theme: theme ?? this.theme,
        properties: properties ?? this.properties,
        translations: translations ?? this.translations,
      );
}
