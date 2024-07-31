import 'dart:convert';

import 'package:call_qwik_example/main.dart';
import 'package:flutter/foundation.dart';

class AgentDetailsModel {
  AgentDetailsModel({
    required this.clientName,
    required this.userId,
    required this.keycloakUserId,
    required this.userType,
    required this.userToken,
    required this.isometrikUserId,
    required this.licenseKey,
    required this.projectId,
    required this.appSecret,
    required this.keysetId,
    required this.accountId,
    required this.name,
    required this.email,
    required this.emailVerified,
    required this.phoneNumber,
    required this.phoneIsoCode,
    required this.phoneCountryCode,
    required this.phoneVerified,
    required this.token,
    required this.userProfileUrl,
    required this.isFirstTimeLogin,
    required this.teamInfo,
    required this.clientNames,
  });

  factory AgentDetailsModel.fromMap(Map<String, dynamic> map) =>
      AgentDetailsModel(
        clientName: map['clientName'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        keycloakUserId: map['keycloakUserId'] as String? ?? '',
        userType: map['userType'] as String? ?? '',
        userToken: map['userToken'] as String? ?? '',
        isometrikUserId: map['isometrikUserId'] as String? ?? '',
        licenseKey: map['licenseKey'] as String? ?? '',
        projectId: map['projectId'] as String? ?? '',
        appSecret: map['appSecret'] as String? ?? '',
        keysetId: map['keysetId'] as String? ?? '',
        accountId: map['accountId'] as String? ?? '',
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        emailVerified: map['emailVerified'] as bool? ?? false,
        phoneNumber: map['phoneNumber'] as String? ?? '',
        phoneIsoCode: map['phoneIsoCode'] as String? ?? '',
        phoneCountryCode: map['phoneCountryCode'] as String? ?? '',
        phoneVerified: map['phoneVerified'] as bool? ?? false,
        token: TokenModel.fromMap(map['token'] as Map<String, dynamic>? ?? {}),
        userProfileUrl: map['userProfileUrl'] as String? ?? '',
        isFirstTimeLogin: map['isFirstTimeLogin'] as bool? ??
            map['IsFirstTimeLogin'] as bool? ??
            false,
        teamInfo: (map['teamInfo'] as List? ?? [])
            .map(
              (e) => TeamModel.fromMap(e as Map<String, dynamic>),
            )
            .toList(),
        clientNames: (map['clientNames'] as List? ?? [])
            .map(
              (e) => ApplicationModel.fromMap(e as Map<String, dynamic>),
            )
            .toList(),
      );

  factory AgentDetailsModel.fromJson(
    String source,
  ) =>
      AgentDetailsModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String clientName;
  final String userId;
  final String keycloakUserId;
  final String userType;
  final String userToken;
  final String isometrikUserId;
  final String licenseKey;
  final String projectId;
  final String appSecret;
  final String keysetId;
  final String accountId;
  final String name;
  final String email;
  final bool emailVerified;
  final String phoneNumber;
  final String phoneIsoCode;
  final String phoneCountryCode;
  final bool phoneVerified;
  final TokenModel token;
  final String userProfileUrl;
  final bool isFirstTimeLogin;
  final List<TeamModel> teamInfo;
  final List<ApplicationModel> clientNames;

  String get mobileNumber => '$phoneCountryCode $phoneNumber'.trim();

  AgentDetailsModel copyWith({
    String? clientName,
    String? userId,
    String? keycloakUserId,
    String? userType,
    String? userToken,
    String? isometrikUserId,
    String? licenseKey,
    String? projectId,
    String? appSecret,
    String? keysetId,
    String? accountId,
    String? name,
    String? email,
    bool? emailVerified,
    String? phoneNumber,
    String? phoneIsoCode,
    String? phoneCountryCode,
    bool? phoneVerified,
    TokenModel? token,
    String? userProfileUrl,
    bool? isFirstTimeLogin,
    List<TeamModel>? teamInfo,
    List<ApplicationModel>? clientNames,
  }) =>
      AgentDetailsModel(
        clientName: clientName ?? this.clientName,
        userId: userId ?? this.userId,
        keycloakUserId: keycloakUserId ?? this.keycloakUserId,
        userType: userType ?? this.userType,
        userToken: userToken ?? this.userToken,
        isometrikUserId: isometrikUserId ?? this.isometrikUserId,
        licenseKey: licenseKey ?? this.licenseKey,
        projectId: projectId ?? this.projectId,
        appSecret: appSecret ?? this.appSecret,
        keysetId: keysetId ?? this.keysetId,
        accountId: accountId ?? this.accountId,
        name: name ?? this.name,
        email: email ?? this.email,
        emailVerified: emailVerified ?? this.emailVerified,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        phoneIsoCode: phoneIsoCode ?? this.phoneIsoCode,
        phoneCountryCode: phoneCountryCode ?? this.phoneCountryCode,
        phoneVerified: phoneVerified ?? this.phoneVerified,
        token: token ?? this.token,
        userProfileUrl: userProfileUrl ?? this.userProfileUrl,
        isFirstTimeLogin: isFirstTimeLogin ?? this.isFirstTimeLogin,
        teamInfo: teamInfo ?? this.teamInfo,
        clientNames: clientNames ?? this.clientNames,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'clientName': clientName,
        'userId': userId,
        'keycloakUserId': keycloakUserId,
        'userType': userType,
        'userToken': userToken,
        'isometrikUserId': isometrikUserId,
        'licenseKey': licenseKey,
        'projectId': projectId,
        'appSecret': appSecret,
        'keysetId': keysetId,
        'accountId': accountId,
        'name': name,
        'email': email,
        'emailVerified': emailVerified,
        'phoneNumber': phoneNumber,
        'phoneIsoCode': phoneIsoCode,
        'phoneCountryCode': phoneCountryCode,
        'phoneVerified': phoneVerified,
        'token': token.toMap(),
        'userProfileUrl': userProfileUrl,
        'isFirstTimeLogin': isFirstTimeLogin,
        'teamInfo': teamInfo.map((e) => e.toMap()).toList(),
        'clientNames': clientNames.map((e) => e.toMap()).toList(),
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'AgentDetailsModel(clientName: $clientName, userId: $userId, keycloakUserId: $keycloakUserId, userType: $userType, userToken: $userToken, isometrikUserId: $isometrikUserId, licenseKey: $licenseKey, projectId: $projectId, appSecret: $appSecret, keysetId: $keysetId, accountId: $accountId, name: $name, email: $email, emailVerified: $emailVerified, phoneNumber: $phoneNumber, phoneIsoCode: $phoneIsoCode, phoneCountryCode: $phoneCountryCode, phoneVerified: $phoneVerified, token: $token, userProfileUrl: $userProfileUrl, isFirstTimeLogin: $isFirstTimeLogin, teamInfo: $teamInfo, clientNames: $clientNames)';

  @override
  bool operator ==(covariant AgentDetailsModel other) {
    if (identical(this, other)) return true;

    return other.clientName == clientName &&
        other.userId == userId &&
        other.keycloakUserId == keycloakUserId &&
        other.userType == userType &&
        other.userToken == userToken &&
        other.isometrikUserId == isometrikUserId &&
        other.licenseKey == licenseKey &&
        other.projectId == projectId &&
        other.appSecret == appSecret &&
        other.keysetId == keysetId &&
        other.accountId == accountId &&
        other.name == name &&
        other.email == email &&
        other.emailVerified == emailVerified &&
        other.phoneNumber == phoneNumber &&
        other.phoneIsoCode == phoneIsoCode &&
        other.phoneCountryCode == phoneCountryCode &&
        other.phoneVerified == phoneVerified &&
        other.token == token &&
        other.userProfileUrl == userProfileUrl &&
        other.isFirstTimeLogin == isFirstTimeLogin &&
        listEquals(other.teamInfo, teamInfo) &&
        listEquals(other.clientNames, clientNames);
  }

  @override
  int get hashCode =>
      clientName.hashCode ^
      userId.hashCode ^
      keycloakUserId.hashCode ^
      userType.hashCode ^
      userToken.hashCode ^
      isometrikUserId.hashCode ^
      licenseKey.hashCode ^
      projectId.hashCode ^
      appSecret.hashCode ^
      keysetId.hashCode ^
      accountId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      emailVerified.hashCode ^
      phoneNumber.hashCode ^
      phoneIsoCode.hashCode ^
      phoneCountryCode.hashCode ^
      phoneVerified.hashCode ^
      token.hashCode ^
      userProfileUrl.hashCode ^
      isFirstTimeLogin.hashCode ^
      teamInfo.length ^
      clientNames.length;
}
