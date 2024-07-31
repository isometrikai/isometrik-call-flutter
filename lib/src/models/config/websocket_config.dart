import 'dart:convert';

import 'package:flutter/foundation.dart';

class IsmCallWebSocketConfig {
  const IsmCallWebSocketConfig({
    this.useWebsocket,
    this.websocketProtocols,
  }) : assert(
          useWebsocket == null ||
              !useWebsocket ||
              (useWebsocket &&
                  websocketProtocols != null &&
                  websocketProtocols.length != 0),
          'if useWebsocket is set to true, the websocket protocols must be specified',
        );

  factory IsmCallWebSocketConfig.fromMap(Map<String, dynamic> map) =>
      IsmCallWebSocketConfig(
        useWebsocket: map['useWebsocket'] as bool? ?? false,
        websocketProtocols: (map['websocketProtocols'] as List? ?? []).cast(),
      );

  factory IsmCallWebSocketConfig.fromJson(
    String source,
  ) =>
      IsmCallWebSocketConfig.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final bool? useWebsocket;
  final List<String>? websocketProtocols;

  IsmCallWebSocketConfig copyWith({
    bool? useWebsocket,
    List<String>? websocketProtocols,
  }) =>
      IsmCallWebSocketConfig(
        useWebsocket: useWebsocket ?? this.useWebsocket,
        websocketProtocols: websocketProtocols ?? this.websocketProtocols,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'useWebsocket': useWebsocket,
        'websocketProtocols': websocketProtocols,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallWebSocketConfig(useWebsocket: $useWebsocket, websocketProtocols: $websocketProtocols)';

  @override
  bool operator ==(covariant IsmCallWebSocketConfig other) {
    if (identical(this, other)) return true;

    return other.useWebsocket == useWebsocket &&
        listEquals(other.websocketProtocols, websocketProtocols);
  }

  @override
  int get hashCode => useWebsocket.hashCode ^ websocketProtocols.hashCode;
}
