import 'dart:convert';

class TokenModel {
  TokenModel({
    required this.accessToken,
    required this.expiresIn,
    required this.notBeforepolicy,
    required this.refreshExpiresIn,
    required this.refreshToken,
    required this.scope,
    required this.sessionState,
    required this.tokenType,
  });

  factory TokenModel.fromMap(Map<String, dynamic> map) => TokenModel(
        accessToken: map['access_token'] as String? ?? '',
        expiresIn: map['expires_in'] as num? ?? 0,
        notBeforepolicy: map['not-before-policy'] as int? ?? 0,
        refreshExpiresIn: map['refresh_expires_in'] as num? ?? 0,
        refreshToken: map['refresh_token'] as String? ?? '',
        scope: map['scope'] as String? ?? '',
        sessionState: map['session_state'] as String? ?? '',
        tokenType: map['token_type'] as String? ?? '',
      );

  factory TokenModel.fromJson(
    String source,
  ) =>
      TokenModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String accessToken;
  final num expiresIn;
  final int notBeforepolicy;
  final num refreshExpiresIn;
  final String refreshToken;
  final String scope;
  final String sessionState;
  final String tokenType;

  TokenModel copyWith({
    String? accessToken,
    num? expiresIn,
    int? notBeforepolicy,
    num? refreshExpiresIn,
    String? refreshToken,
    String? scope,
    String? sessionState,
    String? tokenType,
  }) =>
      TokenModel(
        accessToken: accessToken ?? this.accessToken,
        expiresIn: expiresIn ?? this.expiresIn,
        notBeforepolicy: notBeforepolicy ?? this.notBeforepolicy,
        refreshExpiresIn: refreshExpiresIn ?? this.refreshExpiresIn,
        refreshToken: refreshToken ?? this.refreshToken,
        scope: scope ?? this.scope,
        sessionState: sessionState ?? this.sessionState,
        tokenType: tokenType ?? this.tokenType,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'access_token': accessToken,
        'expires_in': expiresIn,
        'not-before-policy': notBeforepolicy,
        'refresh_expires_in': refreshExpiresIn,
        'refresh_token': refreshToken,
        'scope': scope,
        'session_state': sessionState,
        'token_type': tokenType,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'TokenModel(accessToken: $accessToken, expiresIn: $expiresIn, notBeforepolicy: $notBeforepolicy, refreshExpiresIn: $refreshExpiresIn, refreshToken: $refreshToken, scope: $scope, sessionState: $sessionState, tokenType: $tokenType)';

  @override
  bool operator ==(covariant TokenModel other) {
    if (identical(this, other)) return true;

    return other.accessToken == accessToken &&
        other.expiresIn == expiresIn &&
        other.notBeforepolicy == notBeforepolicy &&
        other.refreshExpiresIn == refreshExpiresIn &&
        other.refreshToken == refreshToken &&
        other.scope == scope &&
        other.sessionState == sessionState &&
        other.tokenType == tokenType;
  }

  @override
  int get hashCode =>
      accessToken.hashCode ^
      expiresIn.hashCode ^
      notBeforepolicy.hashCode ^
      refreshExpiresIn.hashCode ^
      refreshToken.hashCode ^
      scope.hashCode ^
      sessionState.hashCode ^
      tokenType.hashCode;
}
