import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' show Client;

import 'isometrik_call_flutter.dart';
import 'isometrik_call_flutter_platform_interface.dart';

export 'package:mqtt_helper/mqtt_helper.dart';

export 'src/controllers/controllers.dart';
export 'src/data/data.dart';
export 'src/models/models.dart';
export 'src/repositories/repositories.dart';
export 'src/res/res.dart';
export 'src/utils/utils.dart';
export 'src/view_models/view_models.dart';
export 'src/views/views.dart';
export 'src/widget/widget.dart';

part 'isometrik_call_flutter_delegate.dart';

class IsmCall {
  Future<String?> getPlatformVersion() =>
      IsometrikCallFlutterPlatform.instance.getPlatformVersion();

  factory IsmCall() => instance;

  const IsmCall._(this._delegate);

  final IsmCallDelegate _delegate;

  static IsmCall i = const IsmCall._(IsmCallDelegate());

  static IsmCall instance = i;

  static bool _initialized = false;

  static const String _initializedError =
      'IsmCall is not initialized. Initialize it using IsmCall.instance.initialize(config) or IsmCall.i.initialize(config) or  IsmCall().initialize(config)';

  bool get isInitialized => _initialized;

  IsmCallConfig? get config {
    assert(_initialized, _initializedError);
    return _delegate.config;
  }

  Widget? get logo => _delegate.logo;

  bool get logsEnabled => _delegate.enableLogs;

  bool get mqttLogsEnabled => _delegate.enableMqttLogs;

  bool get isMqttConnected => _delegate.isMqttConnected;
  set isMqttConnected(bool value) => _delegate.isMqttConnected = value;

  Future Function()? get logout => _delegate.logout;

  IsmCallAcceptTrigger? get acceptCall => _delegate.acceptCall;

  IsmCallDeclineTrigger? get declineCall => _delegate.declineCall;

  IsmCallEndTrigger? get endCall => _delegate.endCall;

  IsmCallOnRecording? get onRecording => _delegate.onRecording;

  IsmCallRefreshCallback? get refreshToken => _delegate.refreshToken;

  Iterable<LocalizationsDelegate> get localizationDelegates =>
      _delegate.localizationDelegates;

  void Function(bool)? get onConnectionChange => _delegate.onConnectionChange;

  List<Widget>? get callActions => _delegate.callActions;

  void setup() {
    _delegate.setup();
  }

  Future<void> initialize(
    IsmCallConfig config, {
    Widget? appLogo,
    bool enableLogs = true,
    bool enableMqttLogs = true,
    bool shouldInitializeMqtt = true,
    List<String>? topics,
    List<String>? topicChannels,
    Future Function()? onLogout,
    IsmCallRefreshCallback? onRefreshToken,
    IsmCallAcceptTrigger? onAcceptCall,
    IsmCallDeclineTrigger? onDeclineCall,
    IsmCallEndTrigger? onEndCall,
    IsmCallOnRecording? onRecording,
  }) async {
    await Future.wait([
      _delegate.initialize(
        config,
        logo: appLogo,
        enableLogs: enableLogs,
        enableMqttLogs: enableMqttLogs,
        shouldInitializeMqtt: shouldInitializeMqtt,
        topics: topics,
        topicChannels: topicChannels,
        onLogout: onLogout,
        onAcceptCall: onAcceptCall,
        onDeclineCall: onDeclineCall,
        onEndCall: onEndCall,
        onRefreshToken: onRefreshToken,
        onRecording: onRecording,
      ),
    ]);

    _initialized = true;
  }

  IsmCallTriggerStreamSubscription addCallTriggerListener(
    IsmCallTriggerFunction listener,
  ) {
    assert(_initialized, _initializedError);
    return _delegate.addCallTriggerListener(listener);
  }

  Future<void> removeCallTriggerListener(IsmCallTriggerFunction listener) =>
      _delegate.removeCallTriggerListener(listener);

  EventStreamSubscription addEventListener(IsmCallEventFunction listener) {
    assert(_initialized, _initializedError);
    return _delegate.addEventListener(listener);
  }

  Future<void> removeListener(IsmCallMapFunction listener) =>
      _delegate.removeListener(listener);

  void handleMqttEvent(EventModel event) {
    assert(_initialized, _initializedError);
    _delegate.handleMqttEvent(event);
  }

  void startCall({
    required String meetingId,
    required IsmAcceptCallModel call,
    required IsmCallUserInfoModel userInfo,
    IsmCallType callType = IsmCallType.audio,
    List<Widget>? callActions,
    String? imageUrl,
    bool hdBroadcast = false,
    bool callingOutSide = false,
  }) {
    assert(_initialized, _initializedError);
    _delegate.startCall(
        meetingId: meetingId,
        call: call,
        userInfo: userInfo,
        callType: callType,
        callActions: callActions,
        imageUrl: imageUrl,
        hdBroadcast: hdBroadcast,
        callingOutSide: callingOutSide);
  }

  void disconnectCall() {
    assert(_initialized, _initializedError);
  }

  Future<bool> updateConfig(IsmCallConfig config) =>
      _delegate.updateConfig(config);

  void onConnectivityChange(
    Function(bool) onChange,
  ) =>
      _delegate.onConnectivityChange(onChange);

  Future<void> dispose() async {
    await _delegate.dispose();
    _initialized = false;
  }
}
