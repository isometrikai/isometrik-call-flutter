import 'dart:convert';

class RecordingModel {
  const RecordingModel({
    required this.initiatedBy,
    required this.endedAt,
    required this.startedAt,
    required this.recordingUrl,
  });

  factory RecordingModel.fromMap(Map<String, dynamic> map) => RecordingModel(
        initiatedBy: map['initiatedBy'] as String? ?? '',
        endedAt:
            DateTime.fromMillisecondsSinceEpoch(map['endedAt'] as int? ?? 0),
        startedAt:
            DateTime.fromMillisecondsSinceEpoch(map['startedAt'] as int? ?? 0),
        recordingUrl: map['recordingUrl'] as String? ?? '',
      );

  factory RecordingModel.fromJson(
    String source,
  ) =>
      RecordingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String initiatedBy;
  final DateTime endedAt;
  final DateTime startedAt;
  final String recordingUrl;

  Duration get duration => endedAt.difference(startedAt);

  RecordingModel copyWith({
    String? initiatedBy,
    DateTime? endedAt,
    DateTime? startedAt,
    String? recordingUrl,
  }) =>
      RecordingModel(
        initiatedBy: initiatedBy ?? this.initiatedBy,
        endedAt: endedAt ?? this.endedAt,
        startedAt: startedAt ?? this.startedAt,
        recordingUrl: recordingUrl ?? this.recordingUrl,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'initiatedBy': initiatedBy,
        'endedAt': endedAt.millisecondsSinceEpoch,
        'startedAt': startedAt.millisecondsSinceEpoch,
        'recordingUrl': recordingUrl,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'RecordingModel(initiatedBy: $initiatedBy, endedAt: $endedAt, startedAt: $startedAt, recordingUrl: $recordingUrl)';

  @override
  bool operator ==(covariant RecordingModel other) {
    if (identical(this, other)) return true;

    return other.initiatedBy == initiatedBy &&
        other.endedAt == endedAt &&
        other.startedAt == startedAt &&
        other.recordingUrl == recordingUrl;
  }

  @override
  int get hashCode =>
      initiatedBy.hashCode ^
      endedAt.hashCode ^
      startedAt.hashCode ^
      recordingUrl.hashCode;
}
