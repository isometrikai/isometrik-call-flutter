import 'dart:async';

import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:livekit_client/livekit_client.dart';

typedef IsmCallMapFunction = void Function(DynamicMap);

typedef IsmCallEventFunction = void Function(EventModel);

typedef IsmCallDuration = Function(Duration);

typedef IsmCallTriggerModel = ({
  IsmCallStatus status,
  String meetingId,
  Map<String, dynamic> data
});

typedef IsmCallTriggerFunction = void Function(IsmCallTriggerModel);

typedef IsmCallRoomListener = EventsListener<RoomEvent>;

typedef IsmCallAcceptTrigger = Future<IsmAcceptCallModel?> Function(
  String meetingId,
  String deviceId,
  Map<String, dynamic>,
);

typedef IsmCallDeclineTrigger = Future<bool> Function(
  String,
  Map<String, dynamic>,
);

typedef IsmCallEndTrigger = Future<bool> Function(
  String,
  Map<String, dynamic>,
);

typedef IsmCallOnRecording = String Function(bool, Map<String, dynamic>);

typedef IsmCallRefreshCallback = Future<void> Function();

typedef MapStreamSubscription = StreamSubscription<DynamicMap>;

typedef EventStreamSubscription = StreamSubscription<EventModel>;

typedef TimerStreamSubscription = StreamSubscription<Duration>;

typedef IsmCallTriggerStreamSubscription
    = StreamSubscription<IsmCallTriggerModel>;

typedef StringBuilder = String Function(String);

typedef IsmCallMapBuilder = String Function(Map<String, dynamic>);
