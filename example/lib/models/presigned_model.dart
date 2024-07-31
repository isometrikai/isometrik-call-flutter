import 'dart:convert';

import 'package:call_qwik_example/main.dart';

class PresignedModel {
  PresignedModel({
    required this.data,
    required this.url,
    required this.expire,
  });

  factory PresignedModel.fromMap(
    Map<String, dynamic> map,
  ) =>
      PresignedModel(
        data: AwsModel.fromMap(map['data'] as Map<String, dynamic>),
        url: map['url'] as String,
        expire: map['expire'] as int,
      );

  factory PresignedModel.fromJson(
    String source,
  ) =>
      PresignedModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final AwsModel data;
  final String url;
  final int expire;

  PresignedModel copyWith({
    AwsModel? data,
    String? url,
    int? expire,
  }) =>
      PresignedModel(
        data: data ?? this.data,
        url: url ?? this.url,
        expire: expire ?? this.expire,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'data': data.toMap(),
        'url': url,
        'expire': expire,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'PresignedModel(data: $data, url: $url, expire: $expire)';

  @override
  bool operator ==(covariant PresignedModel other) {
    if (identical(this, other)) return true;

    return other.data == data && other.url == url && other.expire == expire;
  }

  @override
  int get hashCode => data.hashCode ^ url.hashCode ^ expire.hashCode;
}
