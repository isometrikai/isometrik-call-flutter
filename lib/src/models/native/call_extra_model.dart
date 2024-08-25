import 'dart:convert';

import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallExtraModel {
  const IsmCallExtraModel({
    this.userId = '',
    this.uid = '',
    this.callType = IsmCallType.audio,
    this.id = '',
    this.platform = '',
    this.meetingId = '',
    this.imageUrl = '',
    this.userIdentifier = '',
    this.name = '',
    this.ip = '',
    this.metaData = const {},
  });

  factory IsmCallExtraModel.fromMap(Map<String, dynamic> map) =>
      IsmCallExtraModel(
        userId: map['userId'] as String? ?? '',
        uid: map['uid'] as String? ?? '',
        callType: IsmCallType.fromName(map['callType'] as String? ?? ''),
        id: map['id'] as String? ?? '',
        platform: map['platform'] as String? ?? '',
        meetingId: map['meetingId'] as String? ?? '',
        imageUrl: map['imageUrl'] as String? ?? '',
        userIdentifier: map['userIdentifier'] as String? ?? '',
        name: map['name'] as String? ?? '',
        ip: map['ip'] as String? ?? '',
        metaData: (map['metaData'] as Map? ?? {}).cast(),
      );

  factory IsmCallExtraModel.fromJson(
    String source,
  ) =>
      IsmCallExtraModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String userId;
  final String uid;
  final IsmCallType callType;
  final String id;
  final String platform;
  final String meetingId;
  final String imageUrl;
  final String userIdentifier;
  final String name;
  final String ip;
  final Map<String, dynamic> metaData;

  IsmCallExtraModel copyWith({
    String? userId,
    String? uid,
    IsmCallType? callType,
    String? id,
    String? platform,
    String? meetingId,
    String? imageUrl,
    String? userIdentifier,
    String? name,
    String? ip,
    Map<String, dynamic>? metaData,
  }) =>
      IsmCallExtraModel(
        userId: userId ?? this.userId,
        uid: uid ?? this.uid,
        callType: callType ?? this.callType,
        id: id ?? this.id,
        platform: platform ?? this.platform,
        meetingId: meetingId ?? this.meetingId,
        imageUrl: imageUrl ?? this.imageUrl,
        userIdentifier: userIdentifier ?? this.userIdentifier,
        name: name ?? this.name,
        ip: ip ?? this.ip,
        metaData: metaData ?? this.metaData,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userId': userId,
        'uid': uid,
        'callType': callType.name,
        'id': id,
        'platform': platform,
        'meetingId': meetingId,
        'imageUrl': imageUrl,
        'userIdentifier': userIdentifier,
        'name': name,
        'ip': ip,
        'metaData': metaData,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallExtraModel(userId: $userId, uid: $uid, callType: $callType, id: $id, platform: $platform, meetingId: $meetingId, imageUrl: $imageUrl, userIdentifier: $userIdentifier, name: $name, ip: $ip, metaData $metaData)';

  @override
  bool operator ==(covariant IsmCallExtraModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.uid == uid &&
        other.callType == callType &&
        other.id == id &&
        other.platform == platform &&
        other.meetingId == meetingId &&
        other.imageUrl == imageUrl &&
        other.userIdentifier == userIdentifier &&
        other.name == name &&
        other.ip == ip &&
        other.metaData == metaData;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      uid.hashCode ^
      callType.hashCode ^
      id.hashCode ^
      platform.hashCode ^
      meetingId.hashCode ^
      imageUrl.hashCode ^
      userIdentifier.hashCode ^
      name.hashCode ^
      ip.hashCode ^
      metaData.hashCode;
}
