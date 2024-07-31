import 'dart:convert';

class TeamModel {
  TeamModel({
    required this.id,
    required this.teamName,
  });

  factory TeamModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      TeamModel(
        id: map['id'] as String,
        teamName: map['teamName'] as String,
      );

  factory TeamModel.fromJson(
    String source,
  ) =>
      TeamModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final String id;
  final String teamName;

  TeamModel copyWith({
    String? id,
    String? teamName,
  }) =>
      TeamModel(
        id: id ?? this.id,
        teamName: teamName ?? this.teamName,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'teamName': teamName,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'TeamModel(id: $id, teamName: $teamName)';

  @override
  bool operator ==(covariant TeamModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.teamName == teamName;
  }

  @override
  int get hashCode => id.hashCode ^ teamName.hashCode;
}
