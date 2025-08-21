import 'package:livekit_client/livekit_client.dart';

class IsmCallParticipantTrack {
  IsmCallParticipantTrack({
    required this.id,
    required this.tracks,
    required this.participant,
    this.isScreenShare = false,
  });

  final String id;
  final List<Track>? tracks;
  final Participant participant;
  final bool isScreenShare;

  IsmCallParticipantTrack copyWith({
    String? id,
    List<Track>? tracks,
    Participant? participant,
    bool? isScreenShare,
  }) =>
      IsmCallParticipantTrack(
        id: id ?? this.id,
        tracks: tracks ?? this.tracks,
        participant: participant ?? this.participant,
        isScreenShare: isScreenShare ?? this.isScreenShare,
      );

  bool get hasVideo => tracks?.any((e) => e is VideoTrack) ?? false;

  VideoTrack? get videoTrack => tracks
      ?.cast<Track?>()
      .firstWhere((e) => e is VideoTrack, orElse: () => null) as VideoTrack?;

  AudioTrack? get audioTrack => tracks
      ?.cast<Track?>()
      .firstWhere((e) => e is AudioTrack, orElse: () => null) as AudioTrack?;

  @override
  String toString() =>
      'IsmCallParticipantTrack(id: $id, tracks: $tracks, participant: $participant, isScreenShare: $isScreenShare)';

  @override
  bool operator ==(covariant IsmCallParticipantTrack other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.tracks == tracks &&
        other.participant == participant &&
        other.isScreenShare == isScreenShare;
  }

  @override
  int get hashCode =>
      tracks.hashCode ^ participant.hashCode ^ isScreenShare.hashCode;
}
