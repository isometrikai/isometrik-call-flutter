import 'dart:convert';

import 'package:call_qwik_example/main.dart';

class AwsModel {
  AwsModel({
    required this.url,
    required this.method,
    required this.signedHeader,
  });

  factory AwsModel.fromMap(Map<String, dynamic> map) => AwsModel(
        url: map['URL'] as String,
        method: map['Method'] as String,
        signedHeader:
            SignedModel.fromMap(map['SignedHeader'] as Map<String, dynamic>),
      );

  factory AwsModel.fromJson(String source) =>
      AwsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String url;
  final String method;
  final SignedModel signedHeader;

  AwsModel copyWith({
    String? url,
    String? method,
    SignedModel? signedHeader,
  }) =>
      AwsModel(
        url: url ?? this.url,
        method: method ?? this.method,
        signedHeader: signedHeader ?? this.signedHeader,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'URL': url,
        'Method': method,
        'SignedHeader': signedHeader.toMap(),
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'AwsModel(url: $url, method: $method, signedHeader: $signedHeader)';

  @override
  bool operator ==(covariant AwsModel other) {
    if (identical(this, other)) return true;

    return other.url == url &&
        other.method == method &&
        other.signedHeader == signedHeader;
  }

  @override
  int get hashCode => url.hashCode ^ method.hashCode ^ signedHeader.hashCode;
}
