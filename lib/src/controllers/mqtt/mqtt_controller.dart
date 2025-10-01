import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallMqttController extends GetxController {
  final _mqttHelper = MqttHelper();

  String? userId;

  late String deviceId;

  final List<String> _topics = [];

  final eventStreamController = StreamController<EventModel>.broadcast();

  var eventListeners = <IsmCallEventFunction>[];

  String _topicPrefix = '';

  IsmCallConfig? _config;

  // ----------------- Functions -----------------------

  Future<void> setup({
    IsmCallConfig? config,
    List<String>? topics,
    List<String>? topicChannels,
    bool shouldInitialize = true,
  }) async {
    _config = config ?? IsmCall.i.config;

    userId = _config?.userConfig.userId ?? '';

    if (!shouldInitialize) return;

    _topicPrefix =
        '/${_config?.projectConfig.accountId ?? ''}/${_config?.projectConfig.projectId ?? ''}';

    deviceId = _config?.projectConfig.deviceId ?? '';

    final userTopic = '$_topicPrefix/User/$userId';
    final statusTopic = '$_topicPrefix/Status/$userId';
    final messageTopic = '$_topicPrefix/Message/$userId';

    var channelTopics =
        topicChannels?.map((e) => '$_topicPrefix/$e/$userId').toList();

    _topics.addAll({
      ...?topics,
      ...?channelTopics,
      userTopic,
      statusTopic,
      messageTopic,
    });

    await _mqttHelper.initialize(
      MqttConfig(
        serverConfig: ServerConfig.fromMap(_config?.mqttConfig.toMap() ?? {}),
        projectConfig: ProjectConfig(
          deviceId: _config?.projectConfig.deviceId ?? '',
          userIdentifier: userId ?? '',
          username: _config?.username ?? '',
          password: _config?.password ?? '',
        ),
        enableLogging: IsmCall.i.mqttLogsEnabled,
        webSocketConfig: _config?.socketConfig != null
            ? WebSocketConfig.fromMap(
                _config?.socketConfig?.toMap() ?? {},
              )
            : null,
        secure: _config?.secure ?? false,
        autoReconnect: _config?.autoReconnect ?? true,
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

  void listenMqttEvent(EventModel model) => _onEvent(model);

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
      // final body = payload['body'] != null
      //     ? jsonDecode(payload['body']) as Map<String, dynamic>? ?? {}
      //     : {};
      // final countryFlag = body['countryFlag'] as String? ?? '';
      // final countryName = body['countryName'] as String? ?? 'U';
      // final id = body['reqId'] as String?;
      // final ip = body['ip'] as String? ?? '';
      // final meetingId =
      //     payload['messageId'] as String? ?? body['meetingId'] as String?;
      final countryFlag = metaData?['countryFlag'] as String? ?? '';
      final countryName = metaData?['countryName'] as String? ?? 'U';
      final id = metaData?['reqId'] as String?;
      final ip = metaData?['ip'] as String? ?? '';
      final meetingId = metaData?['meetingId'] as String?;
      final userIdentifier = payload['userIdentifier'] as String? ?? '';
      final userId = payload['userId'] as String? ?? '';
      final userName = payload['userName'] as String? ?? countryName;
      final userImage =
          payload['userProfileImageUrl'] as String? ?? countryFlag;

      if (id != null && meetingId != null) {
        if (Get.currentRoute == IsmCallRoutes.call) {
          return;
        }
        if (GetPlatform.isAndroid) {
          IsmCallHelper.triggerCall(
            id: id,
            meetingId: meetingId,
            name: userName,
            imageUrl: userImage,
            ip: ip,
            userIdentifier: userIdentifier,
            userId: userId,
            callType: callType,
            countryName: countryName,
          );
        }
      }
    } else if (event.topic.contains('Status')) {
      var action = payload['action'] as String? ?? '';
      var meetingId = payload['meetingId'] as String? ?? '';
      var initiatorId = payload['userId'] as String? ??
          payload['initiatorId'] as String? ??
          '';
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
          break;
        case 'joinRequestReject':
          if (initiatorId != userId) {
            Get.find<IsmCallController>().disconnectCall(
              meetingId: meetingId,
              fromMqtt: true,
            );
            IsmCallHelper.callEndByHost(meetingId);
          }
          break;
        case 'meetingEndedDueToRejectionByAll':
          break;
        case 'recordingStarted':
          if (initiatorId != userId) {
            final userName = IsmCall.i.onRecording?.call(true, payload);
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
