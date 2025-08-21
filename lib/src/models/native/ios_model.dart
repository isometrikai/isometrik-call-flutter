import 'dart:convert';

class IsmCallIosModel {
  const IsmCallIosModel({
    this.supportsDTMF = false,
    this.audioSessionMode = '',
    this.supportsVideo = false,
    this.audioSessionActive = false,
    this.supportsHolding = false,
    this.supportsUngrouping = false,
    this.iconName = '',
    this.maximumCallsPerCallGroup = 1,
    this.audioSessionPreferredIOBufferDuration = 0,
    this.configureAudioSession = false,
    this.audioSessionPreferredSampleRate = 0,
    this.handleType = '',
    this.ringtonePath = '',
    this.maximumCallGroups = 1,
    this.supportsGrouping = false,
    this.includesCallsInRecents = false,
  });

  factory IsmCallIosModel.fromMap(Map<String, dynamic> map) => IsmCallIosModel(
        supportsDTMF: map['supportsDTMF'] as bool? ?? false,
        audioSessionMode: map['audioSessionMode'] as String? ?? '',
        supportsVideo: map['supportsVideo'] as bool? ?? false,
        audioSessionActive: map['audioSessionActive'] as bool? ?? false,
        supportsHolding: map['supportsHolding'] as bool? ?? false,
        supportsUngrouping: map['supportsUngrouping'] as bool? ?? false,
        iconName: map['iconName'] as String? ?? '',
        maximumCallsPerCallGroup: map['maximumCallsPerCallGroup'] as int? ?? 1,
        audioSessionPreferredIOBufferDuration:
            map['audioSessionPreferredIOBufferDuration'] as double? ?? 0,
        configureAudioSession: map['configureAudioSession'] as bool? ?? false,
        audioSessionPreferredSampleRate:
            map['audioSessionPreferredSampleRate'] as double? ?? 0,
        handleType: map['handleType'] as String? ?? '',
        ringtonePath: map['ringtonePath'] as String? ?? '',
        maximumCallGroups: map['maximumCallGroups'] as int? ?? 1,
        supportsGrouping: map['supportsGrouping'] as bool? ?? false,
        includesCallsInRecents: map['includesCallsInRecents'] as bool? ?? false,
      );

  factory IsmCallIosModel.fromJson(
    String source,
  ) =>
      IsmCallIosModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final bool supportsDTMF;
  final String audioSessionMode;
  final bool supportsVideo;
  final bool audioSessionActive;
  final bool supportsHolding;
  final bool supportsUngrouping;
  final String iconName;
  final int maximumCallsPerCallGroup;
  final double audioSessionPreferredIOBufferDuration;
  final bool configureAudioSession;
  final double audioSessionPreferredSampleRate;
  final String handleType;
  final String ringtonePath;
  final int maximumCallGroups;
  final bool supportsGrouping;
  final bool includesCallsInRecents;

  IsmCallIosModel copyWith({
    bool? supportsDTMF,
    String? audioSessionMode,
    bool? supportsVideo,
    bool? audioSessionActive,
    bool? supportsHolding,
    bool? supportsUngrouping,
    String? iconName,
    int? maximumCallsPerCallGroup,
    double? audioSessionPreferredIOBufferDuration,
    bool? configureAudioSession,
    double? audioSessionPreferredSampleRate,
    String? handleType,
    String? ringtonePath,
    int? maximumCallGroups,
    bool? supportsGrouping,
    bool? includesCallsInRecents,
  }) =>
      IsmCallIosModel(
        supportsDTMF: supportsDTMF ?? this.supportsDTMF,
        audioSessionMode: audioSessionMode ?? this.audioSessionMode,
        supportsVideo: supportsVideo ?? this.supportsVideo,
        audioSessionActive: audioSessionActive ?? this.audioSessionActive,
        supportsHolding: supportsHolding ?? this.supportsHolding,
        supportsUngrouping: supportsUngrouping ?? this.supportsUngrouping,
        iconName: iconName ?? this.iconName,
        maximumCallsPerCallGroup:
            maximumCallsPerCallGroup ?? this.maximumCallsPerCallGroup,
        audioSessionPreferredIOBufferDuration:
            audioSessionPreferredIOBufferDuration ??
                this.audioSessionPreferredIOBufferDuration,
        configureAudioSession:
            configureAudioSession ?? this.configureAudioSession,
        audioSessionPreferredSampleRate: audioSessionPreferredSampleRate ??
            this.audioSessionPreferredSampleRate,
        handleType: handleType ?? this.handleType,
        ringtonePath: ringtonePath ?? this.ringtonePath,
        maximumCallGroups: maximumCallGroups ?? this.maximumCallGroups,
        supportsGrouping: supportsGrouping ?? this.supportsGrouping,
        includesCallsInRecents:
            includesCallsInRecents ?? this.includesCallsInRecents,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'supportsDTMF': supportsDTMF,
        'audioSessionMode': audioSessionMode,
        'supportsVideo': supportsVideo,
        'audioSessionActive': audioSessionActive,
        'supportsHolding': supportsHolding,
        'supportsUngrouping': supportsUngrouping,
        'iconName': iconName,
        'maximumCallsPerCallGroup': maximumCallsPerCallGroup,
        'audioSessionPreferredIOBufferDuration':
            audioSessionPreferredIOBufferDuration,
        'configureAudioSession': configureAudioSession,
        'audioSessionPreferredSampleRate': audioSessionPreferredSampleRate,
        'handleType': handleType,
        'ringtonePath': ringtonePath,
        'maximumCallGroups': maximumCallGroups,
        'supportsGrouping': supportsGrouping,
        'includesCallsInRecents': includesCallsInRecents,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallIosModel(supportsDTMF: $supportsDTMF, audioSessionMode: $audioSessionMode, supportsVideo: $supportsVideo, audioSessionActive: $audioSessionActive, supportsHolding: $supportsHolding, supportsUngrouping: $supportsUngrouping, iconName: $iconName, maximumCallsPerCallGroup: $maximumCallsPerCallGroup, audioSessionPreferredIOBufferDuration: $audioSessionPreferredIOBufferDuration, configureAudioSession: $configureAudioSession, audioSessionPreferredSampleRate: $audioSessionPreferredSampleRate, handleType: $handleType, ringtonePath: $ringtonePath, maximumCallGroups: $maximumCallGroups, supportsGrouping: $supportsGrouping, includesCallsInRecents: $includesCallsInRecents)';

  @override
  bool operator ==(covariant IsmCallIosModel other) {
    if (identical(this, other)) return true;

    return other.supportsDTMF == supportsDTMF &&
        other.audioSessionMode == audioSessionMode &&
        other.supportsVideo == supportsVideo &&
        other.audioSessionActive == audioSessionActive &&
        other.supportsHolding == supportsHolding &&
        other.supportsUngrouping == supportsUngrouping &&
        other.iconName == iconName &&
        other.maximumCallsPerCallGroup == maximumCallsPerCallGroup &&
        other.audioSessionPreferredIOBufferDuration ==
            audioSessionPreferredIOBufferDuration &&
        other.configureAudioSession == configureAudioSession &&
        other.audioSessionPreferredSampleRate ==
            audioSessionPreferredSampleRate &&
        other.handleType == handleType &&
        other.ringtonePath == ringtonePath &&
        other.maximumCallGroups == maximumCallGroups &&
        other.supportsGrouping == supportsGrouping &&
        other.includesCallsInRecents == includesCallsInRecents;
  }

  @override
  int get hashCode =>
      supportsDTMF.hashCode ^
      audioSessionMode.hashCode ^
      supportsVideo.hashCode ^
      audioSessionActive.hashCode ^
      supportsHolding.hashCode ^
      supportsUngrouping.hashCode ^
      iconName.hashCode ^
      maximumCallsPerCallGroup.hashCode ^
      audioSessionPreferredIOBufferDuration.hashCode ^
      configureAudioSession.hashCode ^
      audioSessionPreferredSampleRate.hashCode ^
      handleType.hashCode ^
      ringtonePath.hashCode ^
      maximumCallGroups.hashCode ^
      supportsGrouping.hashCode ^
      includesCallsInRecents.hashCode;
}
