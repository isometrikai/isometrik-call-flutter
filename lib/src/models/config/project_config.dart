import 'dart:convert';

class IsmCallProjectConfig {
  IsmCallProjectConfig({
    this.accountId,
    this.appSecret,
    this.userSecret,
    this.keySetId,
    this.licenseKey,
    this.projectId,
    this.deviceId,
  });

  factory IsmCallProjectConfig.fromMap(
    Map<String, dynamic> map,
  ) =>
      IsmCallProjectConfig(
        accountId: map['accountId'] as String?,
        appSecret: map['appSecret'] as String?,
        userSecret: map['userSecret'] as String?,
        keySetId: map['keySetId'] as String?,
        licenseKey: map['licenseKey'] as String?,
        projectId: map['projectId'] as String?,
        deviceId: map['deviceId'] as String?,
      );

  factory IsmCallProjectConfig.fromJson(
    String source,
  ) =>
      IsmCallProjectConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  final String? accountId;
  final String? appSecret;
  final String? userSecret;
  final String? keySetId;
  final String? licenseKey;
  final String? projectId;
  final String? deviceId;

  IsmCallProjectConfig copyWith({
    String? accountId,
    String? appSecret,
    String? userSecret,
    String? keySetId,
    String? licenseKey,
    String? projectId,
    String? deviceId,
  }) =>
      IsmCallProjectConfig(
        accountId: accountId ?? this.accountId,
        appSecret: appSecret ?? this.appSecret,
        userSecret: userSecret ?? this.userSecret,
        keySetId: keySetId ?? this.keySetId,
        licenseKey: licenseKey ?? this.licenseKey,
        projectId: projectId ?? this.projectId,
        deviceId: deviceId ?? this.deviceId,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'accountId': accountId,
        'appSecret': appSecret,
        'userSecret': userSecret,
        'keySetId': keySetId,
        'licenseKey': licenseKey,
        'projectId': projectId,
        'deviceId': deviceId,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallProjectConfig(accountId: $accountId, appSecret: $appSecret, userSecret: $userSecret, keySetId: $keySetId, licenseKey: $licenseKey, projectId: $projectId, deviceId: $deviceId)';

  @override
  bool operator ==(covariant IsmCallProjectConfig other) {
    if (identical(this, other)) return true;

    return other.accountId == accountId &&
        other.appSecret == appSecret &&
        other.userSecret == userSecret &&
        other.keySetId == keySetId &&
        other.licenseKey == licenseKey &&
        other.projectId == projectId &&
        other.deviceId == deviceId;
  }

  @override
  int get hashCode =>
      accountId.hashCode ^
      appSecret.hashCode ^
      userSecret.hashCode ^
      keySetId.hashCode ^
      licenseKey.hashCode ^
      projectId.hashCode ^
      deviceId.hashCode;
}
