import 'dart:async';

import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:livekit_client/livekit_client.dart';

typedef IsmCallMapFunction = void Function(DynamicMap);

typedef IsmCallEventFunction = void Function(EventModel);

typedef IsmCallTriggerModel = ({IsmCallStatus status, String meetingId});

typedef IsmCallTriggerFunction = void Function(IsmCallTriggerModel);

typedef IsmCallRoomListener = EventsListener<RoomEvent>;

typedef IsmCallAcceptTrigger = Future<IsmAcceptCallModel?> Function(
  String meetingId,
  String deviceId,
);

typedef IsmCallDeclineTrigger = Future<bool> Function(String);

typedef IsmCallEndTrigger = Future<bool> Function(String);

typedef IsmCallOnRecording = void Function(bool, Map<String, dynamic>);

typedef IsmCallRefreshCallback = Future<void> Function();

typedef MapStreamSubscription = StreamSubscription<DynamicMap>;

typedef EventStreamSubscription = StreamSubscription<EventModel>;

typedef IsmCallTriggerStreamSubscription
    = StreamSubscription<IsmCallTriggerModel>;
