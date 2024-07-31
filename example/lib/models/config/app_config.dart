import 'dart:convert';

class AppConfig {
  AppConfig({
    this.isAvailable = false,
    this.pushToken = '',
  });
  factory AppConfig.fromMap(Map<String, dynamic> map) => AppConfig(
        isAvailable: map['isAvailable'] as bool? ?? false,
        pushToken: map['pushToken'] as String? ?? '',
      );

  factory AppConfig.fromJson(
    String source,
  ) =>
      AppConfig.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final bool isAvailable;
  final String pushToken;

  AppConfig copyWith({
    bool? isAvailable,
    String? pushToken,
  }) =>
      AppConfig(
        isAvailable: isAvailable ?? this.isAvailable,
        pushToken: pushToken ?? this.pushToken,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'isAvailable': isAvailable,
        'pushToken': pushToken,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'AppConfig( isAvailable: $isAvailable, pushToken: $pushToken)';
}
