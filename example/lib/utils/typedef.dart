import 'dart:async';

import 'package:call_qwik_example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

typedef MapFunction = void Function(DynamicMap);

typedef EventFunction = void Function(EventModel);

typedef NavIconBuilder = Widget Function(BuildContext, int);

typedef LogsList = List<CallLogsModel>;

typedef LogsGroupList = List<LogsList>;

typedef ContactsList = List<ContactsModel>;

typedef ContactsGroupList = List<ContactsList>;

typedef NotesList = List<NoteModel>;

typedef RecordingsList = List<RecordingModel>;

typedef RoomListener = EventsListener<RoomEvent>;

typedef AnswerTrigger = Future<IsmAcceptCallModel?> Function(String, bool);

typedef EndTrigger = Future<bool> Function(String);

typedef OnRecording = void Function(bool, Map<String, dynamic>);

typedef RefreshCallback = Future<void> Function();

typedef MapStreamSubscription = StreamSubscription<DynamicMap>;

typedef EventStreamSubscription = StreamSubscription<EventModel>;
