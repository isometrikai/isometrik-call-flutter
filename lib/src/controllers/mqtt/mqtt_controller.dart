import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

class IsmCallMqttController extends GetxController {
  final _mqttHelper = MqttHelper();

  late String userTopic;
  late String statusTopic;
  late String messageTopic;

  late String userId;

  late String deviceId;

  final List<String> _topics = [];

  final eventStreamController = StreamController<EventModel>.broadcast();

  var eventListeners = <IsmCallEventFunction>[];

  String _topicPrefix = '';

  IsmCallConfig? _config;

  // ----------------- Functions -----------------------

  Future<void> setup({
    bool shouldInitialize = true,
    IsmCallConfig? config,
    List<String>? topics,
    List<String>? topicChannels,
  }) async {
    _config = config ?? IsmCall.i.config;
    _topicPrefix =
        '/${_config?.projectConfig.accountId ?? ''}/${_config?.projectConfig.projectId ?? ''}';

    deviceId = _config?.projectConfig.deviceId ?? '';

    userId = _config?.userConfig.userId ?? '';

    userTopic = '$_topicPrefix/User/$userId';
    statusTopic = '$_topicPrefix/Status/$userId';
    messageTopic = '$_topicPrefix/Message/$userId';

    var channelTopics =
        topicChannels?.map((e) => '$_topicPrefix/$e/$userId').toList();

    _topics.addAll({
      ...?topics,
      ...?channelTopics,
      userTopic,
      statusTopic,
      messageTopic,
    });

    if (!shouldInitialize) {
      return;
    }

    await _mqttHelper.initialize(
      MqttConfig(
        serverConfig: ServerConfig.fromMap(_config?.mqttConfig.toMap() ?? {}),
        projectConfig:
            ProjectConfig.fromMap(_config?.projectConfig.toMap() ?? {}),
        userId: userId,
        enableLogging: IsmCall.i.mqttLogsEnabled,
        username: _config?.username ?? '',
        password: _config?.password ?? '',
        webSocketConfig: _config?.socketConfig != null
            ? WebSocketConfig.fromMap(
                _config?.socketConfig?.toMap() ?? {},
              )
            : null,
        secure: _config?.secure ?? false,
      ),
      callbacks: MqttCallbacks(
        onConnected: _onConnected,
        onDisconnected: _onDisconnected,
        onSubscribeFail: _onSubscribeFailed,
        onSubscribed: _onSubscribed,
        onUnsubscribed: _onUnSubscribed,
        pongCallback: _pong,
      ),
      autoSubscribe: true,
      topics: _topics,
    );

    _mqttHelper
        .onConnectionChange((value) => IsmCall.i.isMqttConnected = value);
    _mqttHelper.onEvent(_onEvent);
  }

  Future<void> subscribeStream(String streamId) async {
    try {
      if (!IsmCall.i.isMqttConnected) {
        IsmCallLog.error('MQTT is not connected');
        return;
      }
      var topic = '$_topicPrefix/$streamId';
      _mqttHelper.subscribeTopic(topic);
    } catch (e) {
      IsmCallLog.error('Subscribe Error - $e');
    }
  }

  void unsubscribeTopics() {
    try {
      _mqttHelper.unsubscribeTopics(_topics);
    } catch (e, st) {
      IsmCallLog.error('Unsubscribe Error - $e', st);
    }
  }

  void unsubscribeStream(String streamId) {
    try {
      var topic = '$_topicPrefix/$streamId';
      _mqttHelper.unsubscribeTopic(topic);
    } catch (e) {
      IsmCallLog.error('Subscribe Error - $e');
    }
  }

  void disconnect() {
    try {
      unawaited(eventStreamController.stream.drain());
      unsubscribeTopics();
      _mqttHelper.disconnect();
    } catch (_) {}
  }

  void _pong() {
    IsmCallLog.info('MQTT pong');
  }

  /// onDisconnected callback, it will be called when connection is breaked
  void _onDisconnected() async {
    IsmCall.i.isMqttConnected = false;
    IsmCallLog.success('MQTT Disconnected');
  }

  /// onSubscribed callback, it will be called when connection successfully subscribes to certain topic
  void _onSubscribed(String topic) {
    IsmCallLog.success('MQTT Subscribed - $topic');
  }

  /// onUnsubscribed callback, it will be called when connection successfully unsubscribes to certain topic
  void _onUnSubscribed(String? topic) {
    IsmCallLog.success('MQTT Unsubscribed - $topic');
  }

  /// onSubscribeFailed callback, it will be called when connection fails to subscribe to certain topic
  void _onSubscribeFailed(String topic) {
    IsmCallLog.error('MQTT Subscription failed - $topic');
  }

  /// onConnected callback, it will be called when connection is established
  void _onConnected() {
    IsmCall.i.isMqttConnected = true;
    IsmCallLog.success('MQTT Connected');
  }

  void handleEvents(EventModel model) => _onEvent(model);

  void _onEvent(EventModel event) async {
    final payload = event.payload;
    if (IsmCall.i.logsEnabled) {
      IsmCallLog.highlight(event.topic);
      IsmCallLog('Event - ${IsmCallUtility.jsonEncodePretty(payload)}');
    }
    eventStreamController.add(event);
    if (event.topic.contains('User')) {
      final metaData = payload['metaData'] as Map<String, dynamic>?;
      final callType = metaData?['callType'] as String?;
      final body = jsonDecode(payload['body']) as Map<String, dynamic>;
      final id = body['reqId'] as String?;
      final meetingId = body['meetingId'] as String?;
      final userIdentifier = payload['userIdentifier'] as String? ?? '';
      final userId = payload['userId'] as String? ?? '';
      final userName = body['userName'] as String?;
      final userImage = body['userProfileImageUrl'] as String?;
      final ip = body['ip'] as String? ?? '';
      final countryFlag = body['countryFlag'] as String? ?? '';
      final countryName = body['countryName'] as String? ?? 'U';
      if (id != null && meetingId != null) {
        if (Get.currentRoute == IsmCallRoutes.call) {
          return;
        }
        if (GetPlatform.isAndroid) {
          IsmCallHelper.triggerCall(
            id: id,
            meetingId: meetingId,
            name: userName ?? countryName,
            imageUrl: userImage ?? countryFlag,
            ip: ip,
            userIdentifier: userIdentifier,
            userId: userId,
            callType: callType,
          );
        }
      }
    } else if (event.topic.contains('Status')) {
      var action = payload['action'] as String? ?? '';
      var meetingId = payload['meetingId'] as String? ?? '';
      var initiatorId = payload['userId'] as String? ??
          payload['initiatorId'] as String? ??
          '';
      var userName = payload['userName'] as String?;
      switch (action) {
        case 'memberLeave':
          break;
        case 'meetingEndedDueToNoUserPublishing':
          var ids = (payload['callDurations'] as List? ?? [])
              .map((e) => e['memberId']);
          if (ids.contains(userId)) {
            unawaited(IsmCallHelper.endCall());
          }
          break;
        case 'publishingStarted':
          if (initiatorId != userId) {
            IsmCallHelper.pickedByOther();
          }
          break;
        case 'meetingEndedByHost':
          var missedMembers = payload['missedByMembers'] as List? ?? [];
          if (missedMembers.contains(userId)) {
            IsmCallHelper.callMissed(meetingId);
          }
          if (initiatorId != userId) {
            IsmCallHelper.callEndByHost(meetingId);
          }
          break;

        case 'joinRequestAccept':
          if (initiatorId != userId) {
            if (Get.isRegistered<IsmCallController>()) {
              final controller = Get.find<IsmCallController>();
              controller.startStreamTimer();
              unawaited(IsmCallUtility.stopAudio());
            }
          }
          break;
        case 'joinRequestReject':
          if (initiatorId != userId) {
            unawaited(IsmCallUtility.stopAudio());
          }
          break;
        case 'meetingEndedDueToRejectionByAll':
          if (initiatorId != userId) {
            unawaited(IsmCallUtility.stopAudio());
          }
          break;
        case 'recordingStarted':
          if (initiatorId != userId) {
            IsmCall.i.onRecording?.call(true, payload);
            if (Get.isRegistered<IsmCallController>()) {
              Get.find<IsmCallController>().toggleRecording(
                true,
                triggerAPI: false,
                name: userName,
              );
            }
          }
          break;
        case 'recordingStopped':
          if (initiatorId != userId) {
            IsmCall.i.onRecording?.call(false, payload);
            if (Get.isRegistered<IsmCallController>()) {
              Get.find<IsmCallController>().toggleRecording(
                false,
                triggerAPI: false,
              );
            }
          }
          break;
        default:
          break;
      }
    }
  }
}
