import 'dart:convert';

class IsmCallMqttConfig {
  IsmCallMqttConfig({
    this.hostName,
    this.port,
  });

  factory IsmCallMqttConfig.fromMap(
    Map<String, dynamic> map,
  ) =>
      IsmCallMqttConfig(
        hostName: map['hostName'] != null ? map['hostName'] as String : null,
        port: map['port'] != null ? map['port'] as int : null,
      );

  factory IsmCallMqttConfig.fromJson(
    String source,
  ) =>
      IsmCallMqttConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  final String? hostName;
  final int? port;

  IsmCallMqttConfig copyWith({
    String? hostName,
    int? port,
  }) =>
      IsmCallMqttConfig(
        hostName: hostName ?? this.hostName,
        port: port ?? this.port,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'hostName': hostName,
        'port': port,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'IsmCallMqttConfig(hostName: $hostName, port: $port)';

  @override
  bool operator ==(covariant IsmCallMqttConfig other) {
    if (identical(this, other)) return true;

    return other.hostName == hostName && other.port == port;
  }

  @override
  int get hashCode => hostName.hashCode ^ port.hashCode;
}
