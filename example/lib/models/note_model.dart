import 'dart:convert';

class NoteModel {
  const NoteModel({
    required this.id,
    required this.note,
    required this.timestamp,
    required this.userFullName,
    required this.userId,
    required this.projectId,
    required this.meetingId,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) => NoteModel(
        id: map['id'] as String? ?? '',
        note: map['note'] as String? ?? '',
        timestamp:
            DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int? ?? 0),
        userFullName: map['userFullName'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        projectId: map['createdUnderProjectId'] as String? ?? '',
        meetingId: map['meetingId'] as String? ?? '',
      );

  factory NoteModel.fromJson(
    String source,
  ) =>
      NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String id;
  final String note;
  final DateTime timestamp;
  final String userFullName;
  final String userId;
  final String projectId;
  final String meetingId;

  NoteModel copyWith({
    String? id,
    String? note,
    DateTime? timestamp,
    String? userFullName,
    String? userId,
    String? projectId,
    String? meetingId,
  }) =>
      NoteModel(
        id: id ?? this.id,
        note: note ?? this.note,
        timestamp: timestamp ?? this.timestamp,
        userFullName: userFullName ?? this.userFullName,
        userId: userId ?? this.userId,
        projectId: projectId ?? this.projectId,
        meetingId: meetingId ?? this.meetingId,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'note': note,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'userFullName': userFullName,
        'userId': userId,
        'createdUnderProjectId': projectId,
        'meetingId': meetingId,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallNoteModel(id: $id, note: $note, timestamp: $timestamp, userFullName: $userFullName, userId: $userId, createdUnderProjectId: $projectId, meetingId: $meetingId)';

  @override
  bool operator ==(covariant NoteModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.note == note &&
        other.timestamp == timestamp &&
        other.userFullName == userFullName &&
        other.userId == userId &&
        other.projectId == projectId &&
        other.meetingId == meetingId;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      note.hashCode ^
      timestamp.hashCode ^
      userFullName.hashCode ^
      userId.hashCode ^
      projectId.hashCode ^
      meetingId.hashCode;
}
