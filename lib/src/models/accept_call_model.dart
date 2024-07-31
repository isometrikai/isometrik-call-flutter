import 'dart:convert';

class IsmAcceptCallModel {
  IsmAcceptCallModel({
    this.joinTime,
    this.meetingId,
    required this.rtcToken,
    this.uid = 0,
  });

  factory IsmAcceptCallModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      IsmAcceptCallModel(
        joinTime: map['creationTime'] as int? ?? map['joinTime'] as int? ?? 0,
        meetingId: map['meetingId'] as String?,
        rtcToken: map['rtcToken'] as String? ?? '',
        uid: map['uid'] as int? ?? 0,
      );

  factory IsmAcceptCallModel.fromJson(
    String source,
  ) =>
      IsmAcceptCallModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final int? joinTime;
  final String? meetingId;
  final String rtcToken;
  final int uid;

  IsmAcceptCallModel copyWith({
    int? joinTime,
    String? meetingId,
    String? rtcToken,
    int? uid,
  }) =>
      IsmAcceptCallModel(
        joinTime: joinTime ?? this.joinTime,
        meetingId: meetingId ?? this.meetingId,
        rtcToken: rtcToken ?? this.rtcToken,
        uid: uid ?? this.uid,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'joinTime': joinTime,
        'meetingId': meetingId,
        'rtcToken': rtcToken,
        'uid': uid,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmAcceptCallModel(joinTime: $joinTime, meetingId: $meetingId, rtcToken: $rtcToken, uid: $uid)';

  @override
  bool operator ==(covariant IsmAcceptCallModel other) {
    if (identical(this, other)) return true;

    return other.joinTime == joinTime &&
        other.meetingId == meetingId &&
        other.rtcToken == rtcToken &&
        other.uid == uid;
  }

  @override
  int get hashCode =>
      joinTime.hashCode ^ meetingId.hashCode ^ rtcToken.hashCode ^ uid.hashCode;
}
