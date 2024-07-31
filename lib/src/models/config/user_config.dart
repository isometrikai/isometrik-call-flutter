import 'dart:convert';

class IsmCallUserConfig {
  IsmCallUserConfig({
    this.userToken,
    this.userId,
    this.firstName,
    this.lastName,
    this.userEmail,
    this.userProfile,
    this.accessToken,
    this.refreshToken,
    this.countryCode,
    this.isoCode,
    this.number,
    this.teamId,
    this.teamName,
  });

  factory IsmCallUserConfig.fromMap(
    Map<String, dynamic> map,
  ) =>
      IsmCallUserConfig(
        userToken: map['userToken'] as String?,
        userId: map['userId'] as String?,
        firstName: map['firstName'] as String?,
        lastName: map['lastName'] as String?,
        userEmail: map['userEmail'] as String?,
        userProfile: map['userProfile'] as String?,
        accessToken: map['accessToken'] as String?,
        refreshToken: map['refreshToken'] as String?,
        countryCode: map['countryCode'] as String?,
        isoCode: map['isoCode'] as String?,
        number: map['number'] as String?,
        teamId: map['teamId'] as String?,
        teamName: map['teamName'] as String?,
      );

  factory IsmCallUserConfig.fromJson(
    String source,
  ) =>
      IsmCallUserConfig.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String? userToken;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? userEmail;
  final String? userProfile;
  final String? accessToken;
  final String? refreshToken;
  final String? countryCode;
  final String? isoCode;
  final String? number;
  final String? teamId;
  final String? teamName;

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  String get phoneNumber => '$countryCode $number';

  IsmCallUserConfig copyWith({
    String? userToken,
    String? userId,
    String? firstName,
    String? lastName,
    String? userEmail,
    String? userProfile,
    String? accessToken,
    String? refreshToken,
    String? countryCode,
    String? isoCode,
    String? number,
    String? teamId,
    String? teamName,
  }) =>
      IsmCallUserConfig(
        userToken: userToken ?? this.userToken,
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        userEmail: userEmail ?? this.userEmail,
        userProfile: userProfile ?? this.userProfile,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        countryCode: countryCode ?? this.countryCode,
        isoCode: isoCode ?? this.isoCode,
        number: number ?? this.number,
        teamId: teamId ?? this.teamId,
        teamName: teamName ?? this.teamName,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userToken': userToken,
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'userEmail': userEmail,
        'userProfile': userProfile,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'countryCode': countryCode,
        'isoCode': isoCode,
        'number': number,
        'teamId': teamId,
        'teamName': teamName,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallUserConfig(userToken: $userToken, userId: $userId, firstName: $firstName, lastName: $lastName, userEmail: $userEmail, userProfile: $userProfile, accessToken: $accessToken, refreshToken: $refreshToken, countryCode: $countryCode, isoCode: $isoCode, number: $number, teamId: $teamId, teamName: $teamName)';

  @override
  bool operator ==(covariant IsmCallUserConfig other) {
    if (identical(this, other)) return true;

    return other.userToken == userToken &&
        other.userId == userId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.userEmail == userEmail &&
        other.userProfile == userProfile &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.countryCode == countryCode &&
        other.isoCode == isoCode &&
        other.number == number &&
        other.teamId == teamId &&
        other.teamName == teamName;
  }

  @override
  int get hashCode =>
      userToken.hashCode ^
      userId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      userEmail.hashCode ^
      userProfile.hashCode ^
      accessToken.hashCode ^
      refreshToken.hashCode ^
      countryCode.hashCode ^
      isoCode.hashCode ^
      number.hashCode ^
      teamId.hashCode ^
      teamName.hashCode;
}
