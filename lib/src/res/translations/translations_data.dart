class IsmCallTranslationsData {
  const IsmCallTranslationsData({
    this.appName,
    this.joining,
    this.opponentLeft,
    this.enablingVideo,
  });

  final String? appName;
  final String? joining;
  final String? opponentLeft;
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
      enablingVideo: t < 0.5 ? enablingVideo : other.enablingVideo,
    );
  }

  IsmCallTranslationsData copyWith({
    String? appName,
    String? joining,
    String? opponentLeft,
    String? enablingVideo,
  }) =>
      IsmCallTranslationsData(
        appName: appName ?? this.appName,
        joining: joining ?? this.joining,
        opponentLeft: opponentLeft ?? this.opponentLeft,
        enablingVideo: enablingVideo ?? this.enablingVideo,
      );
}
