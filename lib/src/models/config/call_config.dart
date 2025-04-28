import 'dart:convert';

import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallConfig {
  factory IsmCallConfig.fromMap(
    Map<String, dynamic> map,
  ) =>
      IsmCallConfig(
        userConfig: IsmCallUserConfig.fromMap(
          map['userConfig'] as Map<String, dynamic>,
        ),
        projectConfig: IsmCallProjectConfig.fromMap(
          map['projectConfig'] as Map<String, dynamic>,
        ),
        mqttConfig: IsmCallMqttConfig.fromMap(
          map['mqttConfig'] as Map<String, dynamic>,
        ),
        socketConfig: map['webSocketConfig'] == null
            ? null
            : IsmCallWebSocketConfig.fromMap(
                map['webSocketConfig'] as Map<String, dynamic>,
              ),
        secure: map['secure'] as bool? ?? false,
      );

  factory IsmCallConfig.fromJson(
    String source,
  ) =>
      IsmCallConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  IsmCallConfig({
    required this.userConfig,
    required this.projectConfig,
    required this.mqttConfig,
    this.socketConfig,
    this.secure = false,
    this.autoReconnect = true,
  });

  final IsmCallUserConfig userConfig;
  final IsmCallProjectConfig projectConfig;
  final IsmCallMqttConfig mqttConfig;
  final IsmCallWebSocketConfig? socketConfig;
  final bool secure;
  final bool autoReconnect;

  String? get username =>
      '2${projectConfig.accountId}${projectConfig.projectId}';

  String? get password =>
      '${projectConfig.licenseKey}${projectConfig.keySetId}';

  IsmCallConfig copyWith({
    IsmCallUserConfig? userConfig,
    IsmCallProjectConfig? projectConfig,
    IsmCallMqttConfig? mqttConfig,
    IsmCallWebSocketConfig? socketConfig,
    bool? secure,
    bool? autoReconnect,
  }) =>
      IsmCallConfig(
        userConfig: userConfig ?? this.userConfig,
        projectConfig: projectConfig ?? this.projectConfig,
        mqttConfig: mqttConfig ?? this.mqttConfig,
        socketConfig: socketConfig ?? this.socketConfig,
        secure: secure ?? this.secure,
        autoReconnect: autoReconnect ?? this.autoReconnect,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userConfig': userConfig.toMap(),
        'projectConfig': projectConfig.toMap(),
        'mqttConfig': mqttConfig.toMap(),
        'webSocketConfig': socketConfig?.toMap(),
        'secure': secure,
        'autoReconnect': autoReconnect,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallConfig( userConfig: $userConfig, projectConfig: $projectConfig, mqttConfig: $mqttConfig, webSocketConfig: $socketConfig, secure: $secure, autoReconnect: $autoReconnect)';

  @override
  bool operator ==(covariant IsmCallConfig other) {
    if (identical(this, other)) return true;

    return other.userConfig == userConfig &&
        other.projectConfig == projectConfig &&
        other.mqttConfig == mqttConfig &&
        other.socketConfig == socketConfig &&
        other.autoReconnect == autoReconnect &&
        other.secure == secure;
  }

  @override
  int get hashCode =>
      userConfig.hashCode ^
      projectConfig.hashCode ^
      mqttConfig.hashCode ^
      socketConfig.hashCode ^
      autoReconnect.hashCode ^
      secure.hashCode;
}
