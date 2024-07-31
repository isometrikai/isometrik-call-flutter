import 'dart:convert';

class SystemConfig {
  const SystemConfig({
    required this.heartBeatTimerInSec,
    required this.dispatchMethod,
    required this.timeToAcceptCallInSec,
    required this.totalDispatchTimeInSec,
  });

  factory SystemConfig.fromMap(
    Map<String, dynamic> map,
  ) =>
      SystemConfig(
        heartBeatTimerInSec: map['heartBeatTimerInSec'] as int? ?? 30,
        dispatchMethod: map['dispatchMethod'] as String? ?? 'broadcast',
        timeToAcceptCallInSec: map['timeToAcceptCallInSec'] as int? ?? 30,
        totalDispatchTimeInSec: map['totalDispatchTimeInSec'] as int? ?? 30,
      );

  factory SystemConfig.fromJson(
    String source,
  ) =>
      SystemConfig.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final int heartBeatTimerInSec;
  final String dispatchMethod;
  final int timeToAcceptCallInSec;
  final int totalDispatchTimeInSec;

  int get ringTimeInSec => dispatchMethod == 'broadcast'
      ? timeToAcceptCallInSec
      : totalDispatchTimeInSec;

  SystemConfig copyWith({
    int? heartBeatTimerInSec,
    String? dispatchMethod,
    int? timeToAcceptCallInSec,
    int? totalDispatchTimeInSec,
  }) =>
      SystemConfig(
        heartBeatTimerInSec: heartBeatTimerInSec ?? this.heartBeatTimerInSec,
        dispatchMethod: dispatchMethod ?? this.dispatchMethod,
        timeToAcceptCallInSec:
            timeToAcceptCallInSec ?? this.timeToAcceptCallInSec,
        totalDispatchTimeInSec:
            totalDispatchTimeInSec ?? this.totalDispatchTimeInSec,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'heartBeatTimerInSec': heartBeatTimerInSec,
        'dispatchMethod': dispatchMethod,
        'timeToAcceptCallInSec': timeToAcceptCallInSec,
        'totalDispatchTimeInSec': totalDispatchTimeInSec,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmCallSystemConfig(heartBeatTimerInSec: $heartBeatTimerInSec, dispatchMethod: $dispatchMethod, timeToAcceptCallInSec: $timeToAcceptCallInSec, totalDispatchTimeInSec: $totalDispatchTimeInSec)';

  @override
  bool operator ==(covariant SystemConfig other) {
    if (identical(this, other)) return true;

    return other.heartBeatTimerInSec == heartBeatTimerInSec &&
        other.dispatchMethod == dispatchMethod &&
        other.timeToAcceptCallInSec == timeToAcceptCallInSec &&
        other.totalDispatchTimeInSec == totalDispatchTimeInSec;
  }

  @override
  int get hashCode =>
      heartBeatTimerInSec.hashCode ^
      dispatchMethod.hashCode ^
      timeToAcceptCallInSec.hashCode ^
      totalDispatchTimeInSec.hashCode;
}
