import 'dart:convert';

class IncomingCallArgument {
  IncomingCallArgument({
    required this.id,
    required this.meetingId,
    required this.imageUrl,
    required this.name,
    required this.ip,
    this.isAudioOnly = true,
  });

  factory IncomingCallArgument.fromMap(Map<String, dynamic> map) =>
      IncomingCallArgument(
        id: map['id'] as String,
        meetingId: map['meetingId'] as String,
        imageUrl: map['imageUrl'] as String,
        name: map['name'] as String,
        ip: map['ip'] as String,
        isAudioOnly: map['isAudioOnly'] as bool? ?? true,
      );

  factory IncomingCallArgument.fromJson(
    String source,
  ) =>
      IncomingCallArgument.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String id;
  final String meetingId;
  final String imageUrl;
  final String ip;
  final String name;
  final bool isAudioOnly;

  IncomingCallArgument copyWith({
    String? id,
    String? meetingId,
    String? imageUrl,
    String? name,
    String? ip,
    bool? isAudioOnly,
  }) =>
      IncomingCallArgument(
        id: id ?? this.id,
        meetingId: meetingId ?? this.meetingId,
        imageUrl: imageUrl ?? this.imageUrl,
        name: name ?? this.name,
        ip: ip ?? this.ip,
        isAudioOnly: isAudioOnly ?? this.isAudioOnly,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'meetingId': meetingId,
        'imageUrl': imageUrl,
        'name': name,
        'ip': ip,
        'isAudioOnly': isAudioOnly,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmIncomingCallArgument(id: $id, meetingId: $meetingId, imageUrl: $imageUrl, name: $name, ip: $ip, isAudioOnly: $isAudioOnly)';

  @override
  bool operator ==(covariant IncomingCallArgument other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.meetingId == meetingId &&
        other.imageUrl == imageUrl &&
        other.name == name &&
        other.ip == ip &&
        other.isAudioOnly == isAudioOnly;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      meetingId.hashCode ^
      imageUrl.hashCode ^
      name.hashCode ^
      ip.hashCode ^
      isAudioOnly.hashCode;
}
