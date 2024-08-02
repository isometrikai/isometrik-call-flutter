class IsmCallTranslationsData {
  const IsmCallTranslationsData({
    this.appName,
    this.joining,
    this.opponentLeft,
    this.misscalled,
    this.enablingVideo,
    this.opponentCallEnded,
  });

  final String? appName;
  final String? joining;
  final String? opponentLeft;
  final String? opponentCallEnded;
  final String? misscalled;
  final String? enablingVideo;

  IsmCallTranslationsData lerp(
      covariant IsmCallTranslationsData? other, double t) {
    if (other is! IsmCallTranslationsData) {
      return this;
    }
    return IsmCallTranslationsData(
      appName: t < 0.5 ? appName : other.appName,
      joining: t < 0.5 ? joining : other.joining,
      opponentLeft: t < 0.5 ? opponentLeft : other.opponentLeft,
      opponentCallEnded: t < 0.5 ? opponentCallEnded : other.opponentCallEnded,
      misscalled: t < 0.5 ? misscalled : other.misscalled,
      enablingVideo: t < 0.5 ? enablingVideo : other.enablingVideo,
    );
  }

  IsmCallTranslationsData copyWith({
    String? appName,
    String? joining,
    String? opponentLeft,
    String? opponentCallEnded,
    String? misscalled,
    String? enablingVideo,
  }) =>
      IsmCallTranslationsData(
        appName: appName ?? this.appName,
        joining: joining ?? this.joining,
        opponentLeft: opponentLeft ?? this.opponentLeft,
        misscalled: misscalled ?? this.misscalled,
        enablingVideo: enablingVideo ?? this.enablingVideo,
        opponentCallEnded: opponentCallEnded ?? this.opponentCallEnded,
      );
}
