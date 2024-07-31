import 'dart:convert';

import 'package:call_qwik_example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class CallLogsModel {
  CallLogsModel({
    required this.agentUserId,
    required this.agentIsometrikUserId,
    required this.status,
    required this.timestamp,
    required this.startTime,
    required this.endTime,
    required this.ip,
    required this.currentCallStatus,
    required this.countryFlag,
    required this.countryName,
    required this.meetingId,
    required this.countryCode,
    required this.isometrikUserId,
    required this.contactName,
    required this.contactImage,
    required this.userIdentifier,
    this.notes = const [],
    this.recordings = const [],
  });

  factory CallLogsModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      CallLogsModel(
        agentUserId: map['agentUserId'] as String? ?? '',
        agentIsometrikUserId: map['agentIsometrikUserId'] as String? ?? '',
        status: CallStatus.fromString(map['status'] as String? ?? ''),
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int? ?? 0),
        startTime:
            DateTime.fromMillisecondsSinceEpoch(map['actionTs'] as int? ?? 0),
        endTime: DateTime.fromMillisecondsSinceEpoch(map['endTs'] as int? ?? 0),
        ip: map['ip'] as String? ?? '',
        currentCallStatus:
            CallStatus.fromString(map['currentCallStatus'] as String? ?? ''),
        countryFlag: map['countryFlag'] as String? ?? '',
        countryName: map['countryName'] as String? ?? '',
        meetingId: map['meetingId'] as String? ?? '',
        countryCode: map['countryCode'] as String? ?? '',
        isometrikUserId: map['isometrikUserId'] as String? ?? '',
        contactName: map['contactName'] as String? ?? '',
        contactImage: map['contactImage'] as String? ?? '',
        userIdentifier: map['userIdentifier'] as String? ?? '',
        notes: (map['notes'] as List? ?? [])
            .map((e) => NoteModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        recordings: (map['segmentRecordings'] as List? ?? [])
            .map((e) => RecordingModel.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  factory CallLogsModel.fromJson(
    String source,
  ) =>
      CallLogsModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  String get imageUrl =>
      contactImage.trim().isNotEmpty ? contactImage : countryFlag;

  String get name => contactName.trim().isNotEmpty ? contactName : countryName;

  String get subtitle =>
      [if (contactName.trim().isNotEmpty) countryName, ip].join(' ');

  bool get isMissed => [CallStatus.missed].contains(status);

  bool get isRinging => [CallStatus.requested].contains(status);

  bool get isOngoing => [CallStatus.accepted].contains(currentCallStatus);

  bool get isContactSaved =>
      contactName.trim().isNotEmpty && (contactName != countryName);

  bool get isExpandable => notes.isNotEmpty || recordings.isNotEmpty;

  String get state {
    if (isMissed) {
      return 'Missed';
    }
    if (isOngoing) {
      return 'Active';
    }
    if (isRinging) {
      return 'Ringing';
    }
    return duration.formatDuration;
  }

  Color get color {
    if (isMissed) {
      return CallColors.red;
    }
    if (isOngoing || isRinging) {
      return CallColors.green;
    }
    return CallColors.unselected;
  }

  Duration get duration => endTime.millisecondsSinceEpoch == 0
      ? DateTime.now().difference(startTime)
      : endTime.difference(startTime);

  final String agentUserId;
  final String agentIsometrikUserId;
  final CallStatus status;
  final DateTime timestamp;
  final DateTime startTime;
  final DateTime endTime;
  final String ip;
  final CallStatus currentCallStatus;
  final String countryFlag;
  final String countryName;
  final String meetingId;
  final String countryCode;
  final String isometrikUserId;
  final String contactName;
  final String contactImage;
  final String userIdentifier;
  final List<NoteModel> notes;
  final List<RecordingModel> recordings;

  CallLogsModel copyWith({
    String? agentUserId,
    String? agentIsometrikUserId,
    CallStatus? status,
    DateTime? timestamp,
    DateTime? startTime,
    DateTime? endTime,
    String? ip,
    CallStatus? currentCallStatus,
    String? countryFlag,
    String? countryName,
    String? meetingId,
    String? countryCode,
    String? isometrikUserId,
    String? contactName,
    String? contactImage,
    String? userIdentifier,
    List<NoteModel>? notes,
    List<RecordingModel>? recordings,
  }) =>
      CallLogsModel(
        agentUserId: agentUserId ?? this.agentUserId,
        agentIsometrikUserId: agentIsometrikUserId ?? this.agentIsometrikUserId,
        status: status ?? this.status,
        timestamp: timestamp ?? this.timestamp,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        ip: ip ?? this.ip,
        currentCallStatus: currentCallStatus ?? this.currentCallStatus,
        countryFlag: countryFlag ?? this.countryFlag,
        countryName: countryName ?? this.countryName,
        meetingId: meetingId ?? this.meetingId,
        countryCode: countryCode ?? this.countryCode,
        isometrikUserId: isometrikUserId ?? this.isometrikUserId,
        contactName: contactName ?? this.contactName,
        contactImage: contactImage ?? this.contactImage,
        userIdentifier: userIdentifier ?? this.userIdentifier,
        notes: notes ?? this.notes,
        recordings: recordings ?? this.recordings,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'agentUserId': agentUserId,
        'agentIsometrikUserId': agentIsometrikUserId,
        'status': status.name,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'actionTs': startTime.millisecondsSinceEpoch,
        'endTs': endTime.millisecondsSinceEpoch,
        'ip': ip,
        'currentCallStatus': currentCallStatus.name,
        'countryFlag': countryFlag,
        'countryName': countryName,
        'meetingId': meetingId,
        'countryCode': countryCode,
        'isometrikUserId': isometrikUserId,
        'contactName': contactName,
        'contactImage': contactImage,
        'userIdentifier': userIdentifier,
        'notes': notes.map((e) => e.toMap()).toList(),
        'segmentRecordings': recordings.map((e) => e.toMap()).toList(),
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'CallLogsModel(agentUserId: $agentUserId, agentIsometrikUserId: $agentIsometrikUserId, status: $status, timestamp: $timestamp, endTs: $endTime, actionTs: $startTime, ip: $ip, currentCallStatus: $currentCallStatus, countryFlag: $countryFlag, countryName: $countryName, meetingId: $meetingId, countryCode: $countryCode, isometrikUserId: $isometrikUserId, contactName: $contactName, contactImage: $contactImage, userIdentifier: $userIdentifier, notes: $notes, segmentRecordings: $recordings)';

  @override
  bool operator ==(covariant CallLogsModel other) {
    if (identical(this, other)) return true;

    return other.agentUserId == agentUserId &&
        other.agentIsometrikUserId == agentIsometrikUserId &&
        other.status == status &&
        other.timestamp == timestamp &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.ip == ip &&
        other.currentCallStatus == currentCallStatus &&
        other.countryFlag == countryFlag &&
        other.countryName == countryName &&
        other.meetingId == meetingId &&
        other.countryCode == countryCode &&
        other.isometrikUserId == isometrikUserId &&
        other.contactName == contactName &&
        other.contactImage == contactImage &&
        other.userIdentifier == userIdentifier &&
        listEquals(other.notes, notes) &&
        listEquals(other.recordings, recordings);
  }

  @override
  int get hashCode =>
      agentUserId.hashCode ^
      agentIsometrikUserId.hashCode ^
      status.hashCode ^
      timestamp.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      ip.hashCode ^
      currentCallStatus.hashCode ^
      countryFlag.hashCode ^
      countryName.hashCode ^
      meetingId.hashCode ^
      countryCode.hashCode ^
      isometrikUserId.hashCode ^
      contactName.hashCode ^
      contactImage.hashCode ^
      userIdentifier.hashCode ^
      notes.hashCode ^
      recordings.hashCode;
}
