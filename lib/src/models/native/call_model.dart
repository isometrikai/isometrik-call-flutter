import 'dart:convert';

import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmNativeCallModel {
  const IsmNativeCallModel({
    this.normalHandle = 0,
    this.duration = 0,
    this.extra = const IsmCallExtraModel(),
    this.avatar = '',
    this.uuid = '',
    this.id = '',
    this.handle = '',
    this.ios = const IsmCallIosModel(),
    this.nameCaller = '',
    this.appName = '',
    this.type = IsmCallType.audio,
    this.isMuted = true,
    this.isActivate = true,
  });

  factory IsmNativeCallModel.fromMap(Map<String, dynamic> map) =>
      IsmNativeCallModel(
        normalHandle: map['normalHandle'] as int? ?? 0,
        duration: map['duration'] as int? ?? 0,
        extra: IsmCallExtraModel.fromMap((map['extra'] as Map? ?? {}).cast()),
        avatar: map['avatar'] as String? ?? '',
        uuid: map['uuid'] as String? ?? '',
        id: map['id'] as String? ?? '',
        handle: map['handle'] as String? ?? '',
        ios: IsmCallIosModel.fromMap((map['ios'] as Map? ?? {}).cast()),
        nameCaller: map['nameCaller'] as String? ?? '',
        appName: map['appName'] as String? ?? '',
        type: IsmCallType.fromValue(map['type'] as int? ?? 0),
        isMuted: map['isMuted'] as bool? ?? true,
        isActivate: map['isActivate'] as bool? ?? true,
      );

  factory IsmNativeCallModel.fromJson(
    String source,
  ) =>
      IsmNativeCallModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int normalHandle;
  final int duration;
  final IsmCallExtraModel extra;
  final String avatar;
  final String uuid;
  final String id;
  final String handle;
  final IsmCallIosModel ios;
  final String nameCaller;
  final String appName;
  final IsmCallType type;
  final bool isMuted;
  final bool isActivate;

  IsmNativeCallModel copyWith({
    int? normalHandle,
    int? duration,
    IsmCallExtraModel? extra,
    String? avatar,
    String? uuid,
    String? id,
    String? handle,
    IsmCallIosModel? ios,
    String? nameCaller,
    String? appName,
    IsmCallType? type,
    bool? isMuted,
    bool? isActivate,
  }) =>
      IsmNativeCallModel(
        normalHandle: normalHandle ?? this.normalHandle,
        duration: duration ?? this.duration,
        extra: extra ?? this.extra,
        avatar: avatar ?? this.avatar,
        uuid: uuid ?? this.uuid,
        id: id ?? this.id,
        handle: handle ?? this.handle,
        ios: ios ?? this.ios,
        nameCaller: nameCaller ?? this.nameCaller,
        appName: appName ?? this.appName,
        type: type ?? this.type,
        isMuted: isMuted ?? this.isMuted,
        isActivate: isActivate ?? this.isActivate,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'normalHandle': normalHandle,
        'duration': duration,
        'extra': extra.toMap(),
        'avatar': avatar,
        'uuid': uuid,
        'id': id,
        'handle': handle,
        'ios': ios.toMap(),
        'nameCaller': nameCaller,
        'appName': appName,
        'type': type.value,
        'isMuted': isMuted,
        'isActivate': isActivate,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmNativeCallModel(normalHandle: $normalHandle, duration: $duration, extra: $extra, avatar: $avatar, uuid: $uuid, id: $id, handle: $handle, ios: $ios, nameCaller: $nameCaller, appName: $appName, type: $type, isMuted: $isMuted, isActivate: $isActivate)';

  @override
  bool operator ==(covariant IsmNativeCallModel other) {
    if (identical(this, other)) return true;

    return other.normalHandle == normalHandle &&
        other.duration == duration &&
        other.extra == extra &&
        other.avatar == avatar &&
        other.uuid == uuid &&
        other.id == id &&
        other.handle == handle &&
        other.ios == ios &&
        other.nameCaller == nameCaller &&
        other.appName == appName &&
        other.type == type &&
        other.isMuted == isMuted &&
        other.isActivate == isActivate;
  }

  @override
  int get hashCode =>
      normalHandle.hashCode ^
      duration.hashCode ^
      extra.hashCode ^
      avatar.hashCode ^
      uuid.hashCode ^
      id.hashCode ^
      handle.hashCode ^
      ios.hashCode ^
      nameCaller.hashCode ^
      appName.hashCode ^
      type.hashCode ^
      isMuted.hashCode ^
      isActivate.hashCode;
}
