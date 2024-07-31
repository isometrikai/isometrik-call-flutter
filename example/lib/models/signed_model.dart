import 'dart:convert';

class SignedModel {
  SignedModel({
    required this.host,
    required this.read,
  });

  factory SignedModel.fromMap(Map<String, dynamic> map) => SignedModel(
        host: (map['Host'] as List<dynamic>).cast().first,
        read: (map['X-Amz-Acl'] as List<dynamic>).cast().first,
      );

  factory SignedModel.fromJson(String source) =>
      SignedModel.fromMap(json.decode(source) as Map<String, dynamic>);
  final String host;
  final String read;

  SignedModel copyWith({
    String? host,
    String? read,
  }) =>
      SignedModel(
        host: host ?? this.host,
        read: read ?? this.read,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'Host': host,
        'X-Amz-Acl': read,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'SignedModel(Host: $host, read: $read)';

  @override
  bool operator ==(covariant SignedModel other) {
    if (identical(this, other)) return true;

    return other.host == host && other.read == read;
  }

  @override
  int get hashCode => host.hashCode ^ read.hashCode;
}
