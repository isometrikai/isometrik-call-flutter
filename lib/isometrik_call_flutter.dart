import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' show Client;
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter_platform_interface.dart';

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

/// The main class for IsmCall.
///
/// This class provides methods for initializing, starting, and ending calls,
/// as well as adding and removing listeners for call triggers and events.
class IsmCall {
  /// Factory constructor for creating an instance of IsmCall.
  factory IsmCall() => instance;

  /// Private constructor for creating an instance of IsmCall.
  const IsmCall._(this._delegate);

  /// Returns the platform version.
  Future<String?> getPlatformVersion() =>
      IsometrikCallFlutterPlatform.instance.getPlatformVersion();

  /// The delegate for this instance of IsmCall.
  final IsmCallDelegate _delegate;

  /// The instance of IsmCall.
  static IsmCall i = const IsmCall._(IsmCallDelegate());

  /// The instance of IsmCall.
  static IsmCall instance = i;

  /// Whether IsmCall has been initialized.
  static bool _initialized = false;

  /// Error message for when IsmCall is not initialized.
  static const String _initializedError =
      'IsmCall is not initialized. Initialize it using IsmCall.instance.initialize(config) or IsmCall.i.initialize(config) or  IsmCall().initialize(config)';

  /// Whether IsmCall has been initialized.
  bool get isInitialized => _initialized;

  /// The configuration for this instance of IsmCall.
  IsmCallConfig? get config {
    assert(_initialized, _initializedError);
    return _delegate.config;
  }

  /// The logo for this instance of IsmCall.
  Widget? get logo => _delegate.logo;

  /// Whether logs are enabled for this instance of IsmCall.
  bool get logsEnabled => _delegate.enableLogs;

  /// Whether MQTT logs are enabled for this instance of IsmCall.
  bool get mqttLogsEnabled => _delegate.enableMqttLogs;

  /// Whether the MQTT connection is connected.
  bool get isMqttConnected => _delegate.isMqttConnected;
  set isMqttConnected(bool value) => _delegate.isMqttConnected = value;

  /// The logout function for this instance of IsmCall.
  Future Function()? get logout => _delegate.logout;

  /// The isUserLogedIn function for this instance of IsmCall.
  IsmCallLoggedIn? get isUserLogedIn => _delegate.isUserLogedIn;

  /// The accept call trigger for this instance of IsmCall.
  IsmCallAcceptTrigger? get acceptCall => _delegate.acceptCall;

  /// The decline call trigger for this instance of IsmCall.
  IsmCallDeclineTrigger? get declineCall => _delegate.declineCall;

  /// The end call trigger for this instance of IsmCall.
  IsmCallEndTrigger? get endCall => _delegate.endCall;

  /// The on recording trigger for this instance of IsmCall.
  IsmCallOnRecording? get onRecording => _delegate.onRecording;

  /// The refresh token callback for this instance of IsmCall.
  IsmCallRefreshCallback? get refreshToken => _delegate.refreshToken;

  /// The localization delegates for this instance of IsmCall.
  Iterable<LocalizationsDelegate> get localizationDelegates =>
      _delegate.localizationDelegates;

  /// The on connection change callback for this instance of IsmCall.
  void Function(bool)? get onConnectionChange => _delegate.onConnectionChange;

  /// The call actions for this instance of IsmCall.
  List<Widget>? get callActions => _delegate.callActions;

  /// Sets up this instance of IsmCall.
  void setup() {
    _delegate.setup();
  }

  /// Initializes this instance of IsmCall with the given configuration.
  ///
  /// This function initializes IsmCall with the provided configuration and sets up
  /// the necessary callbacks and triggers for call events.
  ///
  /// *  `config` is the configuration for this instance of IsmCall.
  /// *  `appLogo` is the logo for this instance of IsmCall.
  /// *  `enableLogs` is whether logs are enabled for this instance of IsmCall.
  /// *  `enableMqttLogs` is whether MQTT logs are enabled for this instance of IsmCall.
  /// *  `shouldInitializeMqtt` is whether the MQTT connection should be initialized.
  /// *  `topics` is the list of topics for this instance of IsmCall.
  /// *  `topicChannels` is the list of topic channels for this instance of IsmCall.
  /// *  `onLogout` is the logout function for this instance of IsmCall.
  /// *  `onRefreshToken` is the refresh token callback for this instance of IsmCall.
  /// *  `onAcceptCall` is the accept call trigger for this instance of IsmCall.
  /// *  `onDeclineCall` is the decline call trigger for this instance of IsmCall.
  /// *  `onEndCall` is the end call trigger for this instance of IsmCall.
  /// *  `onRecording` is the on recording trigger for this instance of IsmCall.
  ///
  /// Example:
  /// ```dart
  /// final config = IsmCallConfig(
  ///   // configuration settings
  /// );
  /// await IsmCall.i.initialize(
  ///   config,
  ///   appLogo: LogoWidget(),
  ///   enableLogs: true,
  ///   enableMqttLogs: true,
  ///   shouldInitializeMqtt: true,
  ///   topics: ['topic1', 'topic2'],
  ///   topicChannels: ['channel1', 'channel2'],
  ///   onLogout: () async {
  ///     // logout logic
  ///   },
  ///   onRefreshToken: (token) {
  ///     // refresh token logic
  ///   },
  ///   onAcceptCall: (call) {
  ///     // accept call logic
  ///   },
  ///   onDeclineCall: (call) {
  ///     // decline call logic
  ///   },
  ///   onEndCall: (call) {
  ///     // end call logic
  ///   },
  ///   onRecording: (call) {
  ///     // on recording logic
  ///   },
  /// );
  /// ```
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

  /// Adds a listener for call triggers.
  ///
  /// This function adds a listener for call triggers and returns a subscription
  /// that can be used to cancel the listener.
  ///
  /// * `listener` is the function that will be called when a call trigger is received.
  ///
  /// Example:
  /// ```dart
  /// final subscription = IsmCall.i.addCallTriggerListener((call) {
  ///   // call trigger logic
  /// });
  /// ```
  /// To cancel the listener, call `subscription.cancel()`.
  IsmCallTriggerStreamSubscription addCallTriggerListener(
    IsmCallTriggerFunction listener,
  ) {
    assert(_initialized, _initializedError);
    return _delegate.addCallTriggerListener(listener);
  }

  /// Removes a listener for call triggers.
  ///
  /// This function removes a listener for call triggers that was previously added
  /// using `addCallTriggerListener`.
  ///
  /// * `listener` is the function that was previously added as a listener.
  ///
  /// Example:
  /// ```dart
  /// final listener = (call) {
  ///   // call trigger logic
  /// };
  ///IsmCall.i.addCallTriggerListener(listener);
  /// // Later, to remove the listener
  /// await IsmCall.i.removeCallTriggerListener(listener);
  /// ```
  Future<void> removeCallTriggerListener(IsmCallTriggerFunction listener) {
    assert(_initialized, _initializedError);
    return _delegate.removeCallTriggerListener(listener);
  }

  /// Adds a listener for call events.
  ///
  /// This function adds a listener for call events and returns a subscription
  /// that can be used to cancel the listener.
  ///
  /// * `listener` is the function that will be called when a call event is received.
  ///
  /// Example:
  /// ```dart
  /// final subscription = IsmCall.i.addEventListener((event) {
  ///   // call event logic
  /// });
  /// ```
  /// To cancel the listener, call `subscription.cancel()`.
  EventStreamSubscription addEventListener(IsmCallEventFunction listener) {
    assert(_initialized, _initializedError);
    return _delegate.addEventListener(listener);
  }

  /// Removes a listener for call maps.
  ///
  /// This function removes a listener for call maps that was previously added
  /// using a function that adds a listener.
  ///
  /// * `listener` is the function that was previously added as a listener.
  ///
  /// Example:
  /// ```dart
  /// final listener = (callMap) {
  ///   // call map logic
  /// };
  /// IsmCall.i.addEventListener(listener);
  /// // Later, to remove the listener
  /// await IsmCall.i.removeListener(listener);
  /// ```
  Future<void> removeListener(IsmCallMapFunction listener) {
    assert(_initialized, _initializedError);
    return _delegate.removeListener(listener);
  }

  /// Listens to an MQTT event.
  ///
  /// This function is used to listen to an MQTT event.
  ///
  /// * `event` is the event model that contains the MQTT event data.
  ///
  /// Example:
  /// ```dart
  /// final event = EventModel(
  ///   topic: 'topic',
  ///   payload: 'payload',
  /// );
  /// IsmCall.i.listenMqttEvent(event);
  /// ```
  void listenMqttEvent(EventModel event) {
    assert(_initialized, _initializedError);
    _delegate.listenMqttEvent(event);
  }

  /// Starts a call.
  ///
  /// This function is used to start a call with the provided meeting ID, call, and user info.
  ///
  /// * `meetingId` is the ID of the meeting.
  /// * `call` is the call model that contains the call data.
  /// * `userInfo` is the user info model that contains the user data.
  /// * `callType` is the type of the call, default is `IsmCallType.audio`.
  /// * `callActions` is a list of widgets that will be displayed as call actions.
  /// * `imageUrl` is the URL of the image that will be displayed during the call.
  /// * `hdBroadcast` is a boolean that indicates whether to broadcast in high definition, default is false.
  ///
  /// Example:
  /// ```dart
  /// final meetingId = 'meetingId';
  /// final call = IsmAcceptCallModel(
  ///   callerId: 'callerId',
  ///   callerName: 'callerName',
  /// );
  /// final userInfo = IsmCallUserInfoModel(
  ///   userId: 'userId',
  ///   userName: 'userName',
  /// );
  /// IsmCall.i.startCall(
  ///   meetingId: meetingId,
  ///   call: call,
  ///   userInfo: userInfo,
  /// );
  /// ```
  void startCall({
    required String meetingId,
    required IsmAcceptCallModel call,
    required IsmCallUserInfoModel userInfo,
    IsmCallType callType = IsmCallType.audio,
    List<Widget>? callActions,
    String? imageUrl,
    bool hdBroadcast = false,
    bool shouldAudioPlay = true,
    bool isAccepted = false,
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
      shouldAudioPlay: shouldAudioPlay,
      isAccepted: isAccepted,
    );
  }

  /// Disconnects the current call with the specified meeting ID.
  ///
  /// This function is used to disconnect the current call associated with the provided meeting ID.
  ///
  /// Parameters:
  /// [meetingId] - The ID of the meeting to disconnect the call from.
  ///
  /// Example:
  /// ```dart
  /// IsmCall.i.disconnectCall('meeting-id-123');
  /// ```
  void disconnectCall(String meetingId) {
    assert(_initialized, _initializedError);
    _delegate.disconnectCall(meetingId);
  }

  /// Updates the call configuration.
  ///
  /// This function is used to update the call configuration with the provided [IsmCallConfig].
  ///
  /// [config] is the new configuration for the call.
  ///
  /// Returns a [Future] that resolves to a boolean indicating whether the configuration was updated successfully.
  ///
  /// Example:
  /// ```dart
  /// final config = IsmCallConfig(
  ///   // configuration settings
  /// );
  /// final updated = await IsmCall.i.updateConfig(config);
  /// if (updated) {
  ///   print('Configuration updated successfully');
  /// } else {
  ///   print('Failed to update configuration');
  /// }
  /// ```
  Future<bool> updateConfig(IsmCallConfig config) =>
      _delegate.updateConfig(config);

  /// Listens for changes in connectivity.
  ///
  /// This function is used to listen for changes in connectivity and calls the provided [onChange] callback with a boolean indicating whether the device is connected or not.
  ///
  /// [onChange] is a callback function that takes a boolean indicating whether the device is connected or not.
  ///
  /// Example:
  /// ```dart
  /// IsmCall.i.onConnectivityChange((connected) {
  ///   if (connected) {
  ///     print('Device is connected');
  ///   } else {
  ///     print('Device is not connected');
  ///   }
  /// });
  /// ```
  void onConnectivityChange(
    Function(bool) onChange,
  ) =>
      _delegate.onConnectivityChange(onChange);

  /// Disposes of the resources used by the [IsmCall] instance.
  ///
  /// This function is used to release any resources held by the [IsmCall] instance, such as closing any open connections.
  ///
  /// It is recommended to call this function when the [IsmCall] instance is no longer needed to free up resources.
  ///
  /// Example:
  /// ```dart
  /// await IsmCall.i.dispose();
  /// ```
  Future<void> dispose() async {
    assert(_initialized, _initializedError);
    await _delegate.dispose();
    _initialized = false;
  }

  /// Starts the Picture-in-Picture (PiP) mode during call.
  ///
  /// Example:
  /// ```dart
  /// await IsmCall.i.startPip();
  /// ```
  void startPip() {
    assert(_initialized, _initializedError);
    _delegate.startPip();
  }

  /// Closes the Picture-in-Picture (PiP) mode.
  ///
  /// The [context] parameter is optional and can be provided to handle any
  /// context-specific cleanup or operations.
  /// Example:
  /// ```dart
  /// await IsmCall.i.closePip();
  /// ```
  void closePip(BuildContext? context) {
    assert(_initialized, _initializedError);
    _delegate.closePip(context);
  }

  /// Reverses the time direction.
  ///
  /// If [reversedTime] is true, the time will move in reverse. Otherwise, it will move forward.
  ///
  /// Example:
  /// ```dart
  /// reversedTime(reversedTime: true); // Reverses the time direction
  /// ```
  ///
  /// @param [reversedTime] Whether to reverse the time direction. Defaults to false.
  void reversedTime({bool reversedTime = false}) {
    assert(_initialized, _initializedError);
    _delegate.reversedTime(reversedTime: reversedTime);
  }

  /// Adds a duration to the current time.
  ///
  /// The [timeStamp] parameter specifies the duration to add.
  ///
  /// Example:
  /// ```dart
  /// addDuration(1000); // Adds 1 second to the current time
  /// ```
  ///
  /// @param [timeStamp] The duration to add in milliseconds.
  void addDuration(int timeStamp) {
    assert(_initialized, _initializedError);
    _delegate.addDuration(timeStamp);
  }

  /// Adds a listener for call timer.
  ///
  /// This function adds a listener for call timer and returns a subscription
  /// that can be used to cancel the listener.
  ///
  /// * `listener` is the function that will be called when a call timer is received.
  ///
  /// Example:
  /// ```dart
  /// final subscription = IsmCall.i.addTimerListener((event) {
  ///   // call event logic
  /// });
  /// ```
  /// To cancel the listener, call `subscription.cancel()`.
  TimerStreamSubscription addTimerListener(IsmCallDuration listener) {
    assert(_initialized, _initializedError);
    return _delegate.addTimerListener(listener);
  }

  /// Removes a listener for call timer.
  ///
  /// This function removes a listener for call timer that was previously added
  /// using a function that adds a listener.
  ///
  /// * `listener` is the function that was previously added as a listener.
  ///
  /// Example:
  /// ```dart
  /// final listener = (callMap) {
  ///   // call map logic
  /// };
  /// IsmCall.i.addTimerListener(listener);
  /// // Later, to remove the listener
  /// await IsmCall.i.removeTimerListener(listener);
  /// ```
  Future<void> removeTimerListener(IsmCallDuration listener) {
    assert(_initialized, _initializedError);
    return _delegate.removeTimerListener(listener);
  }

  Future<String> getDevicePushTokenVoIP() async =>
      await _delegate.getDevicePushTokenVoIP();

  Future<String> getLocalToken() async => await _delegate.getToken();
  void getIsUserLogedIn(
    IsmCallLoggedIn isUserLogedIn,
  ) =>
      _delegate.getIsUserLogedIn(isUserLogedIn);
}
