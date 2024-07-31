import 'dart:convert';

class IsmCallResponseModel {
  factory IsmCallResponseModel.error() => const IsmCallResponseModel(
        data: '',
        statusCode: 1000,
        hasError: true,
      );

  factory IsmCallResponseModel.message(
    String message, {
    bool isSuccess = false,
    int statusCode = 1000,
  }) =>
      IsmCallResponseModel(
        data: jsonEncode({'message': message}),
        hasError: !isSuccess,
        statusCode: statusCode,
      );

  factory IsmCallResponseModel.fromMap(Map<String, dynamic> map) =>
      IsmCallResponseModel(
        data: map['data'] as String,
        hasError: map['hasError'] as bool,
        statusCode: map['statusCode'] != null ? map['statusCode'] as int : 1000,
      );

  factory IsmCallResponseModel.fromJson(String source) =>
      IsmCallResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  const IsmCallResponseModel({
    required this.data,
    required this.hasError,
    this.statusCode = 1000,
  });

  Map<String, dynamic> decode() => jsonDecode(data) as Map<String, dynamic>;

  final String data;
  final bool hasError;
  final int statusCode;

  IsmCallResponseModel copyWith({
    String? data,
    bool? hasError,
    int? statusCode,
  }) =>
      IsmCallResponseModel(
        data: data ?? this.data,
        hasError: hasError ?? this.hasError,
        statusCode: statusCode ?? this.statusCode,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'data': data,
        'hasError': hasError,
        'statusCode': statusCode,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallIsmCallResponseModel(data: $data, hasError: $hasError, statusCode: $statusCode)';

  @override
  bool operator ==(covariant IsmCallResponseModel other) {
    if (identical(this, other)) return true;

    return other.data == data &&
        other.hasError == hasError &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode => data.hashCode ^ hasError.hashCode ^ statusCode.hashCode;
}
