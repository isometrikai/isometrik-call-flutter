part of 'isometrik_call_flutter.dart';

class IsmCallDelegate {
  const IsmCallDelegate();

  static IsmCallConfig? _config;
  IsmCallConfig? get config => _config;

  static Widget? _logo;
  Widget? get logo => _logo;

  static bool _enableLogs = true;
  bool get enableLogs => _enableLogs;

  static bool _enableMqttLogs = true;
  bool get enableMqttLogs => _enableMqttLogs;

  static bool _reverseTimer = false;
  bool get reverseTimer => _reverseTimer;

  static void Function(bool)? _onConnectionChange;
  void Function(bool)? get onConnectionChange => _onConnectionChange;

  static List<Widget>? _callActions;
  List<Widget>? get callActions => _callActions;

  static IsmCallRefreshCallback? _refreshToken;
  IsmCallRefreshCallback? get refreshToken => _refreshToken;

  static Future Function()? _logout;
  Future Function()? get logout => _logout;

  static IsmCallLoggedIn? _isUserLogedIn;
  IsmCallLoggedIn? get isUserLogedIn => _isUserLogedIn;

  static IsmCallAcceptTrigger? _acceptCall;
  IsmCallAcceptTrigger? get acceptCall => _acceptCall;

  static IsmCallDeclineTrigger? _declineCall;
  IsmCallDeclineTrigger? get declineCall => _declineCall;

  static IsmCallEndTrigger? _endCall;
  IsmCallEndTrigger? get endCall => _endCall;

  static IsmCallOnRecording? _onRecording;
  IsmCallOnRecording? get onRecording => _onRecording;

  static final Iterable<LocalizationsDelegate> _localizationDelegates = [];
  Iterable<LocalizationsDelegate> get localizationDelegates =>
      _localizationDelegates;

  static final RxBool _isMqttConnected = false.obs;
  bool get isMqttConnected => _isMqttConnected.value;
  set isMqttConnected(bool value) {
    if (isMqttConnected == value) {
      return;
    }
    _isMqttConnected.value = value;
  }

  IsmCallDBWrapper get _db => IsmCallDBWrapper.instance;

  static final callKey = GlobalKey<IsmCallViewState>();

  static bool _mqttInitialized = false;

  void setup() async {
    IsmCallChannelHandler.initialize();
    if (!Get.isRegistered<IsmCallApiWrapper>()) {
      Get.put(IsmCallApiWrapper(Client()));
    }
  }

  Future<void> initialize(
    IsmCallConfig config, {
    bool enableLogs = true,
    bool enableMqttLogs = true,
    bool shouldInitializeMqtt = true,
    Widget? logo,
    Future Function()? onLogout,
    List<String>? topics,
    List<String>? topicChannels,
    IsmCallRefreshCallback? onRefreshToken,
    IsmCallAcceptTrigger? onAcceptCall,
    IsmCallDeclineTrigger? onDeclineCall,
    IsmCallEndTrigger? onEndCall,
    IsmCallOnRecording? onRecording,
    IsmCallLoggedIn? isUserLogedIn,
  }) async {
    _config = config;
    setup();
    _isUserLogedIn = isUserLogedIn;
    _logo = logo;
    _enableLogs = enableLogs;
    _enableMqttLogs = enableMqttLogs;
    _logout = onLogout;
    _acceptCall = onAcceptCall;
    _declineCall = onDeclineCall;
    _endCall = onEndCall;
    _onRecording = onRecording;
    _refreshToken = onRefreshToken;
    IsmCallHelper.requestNotification();
    IsmCallHelper.listenCallEvents();
    unawaited(
      Future.wait([
        _connectMqtt(
          shouldInitialize: shouldInitializeMqtt,
          config: config,
          topics: topics,
          topicChannels: topicChannels,
        ),
        _checkPushToken(),
        _db.addConfig(config),
      ]),
    );
  }

  Future<void> _connectMqtt({
    bool shouldInitialize = true,
    IsmCallConfig? config,
    List<String>? topics,
    List<String>? topicChannels,
  }) async {
    if (!Get.isRegistered<IsmCallMqttController>()) {
      IsmCallMqttBinding().dependencies();
    }
    await Get.find<IsmCallMqttController>().setup(
      config: config,
      topics: topics,
      topicChannels: topicChannels,
      shouldInitialize: shouldInitialize,
    );
    if (shouldInitialize) {
      _mqttInitialized = true;
    }
  }

  IsmCallTriggerStreamSubscription addCallTriggerListener(
    IsmCallTriggerFunction listener,
  ) =>
      IsmCallHelper.addCallTriggerListener(listener);

  Future<void> removeCallTriggerListener(
    IsmCallTriggerFunction listener,
  ) async =>
      IsmCallHelper.removeCallTriggerListener(listener);

  EventStreamSubscription addEventListener(IsmCallEventFunction listener) {
    // assert(
    //   _mqttInitialized,
    //   'Mqtt is not initialized',
    // );
    var mqttController = Get.find<IsmCallMqttController>();
    return mqttController.eventStreamController.stream.listen(listener);
  }

  Future<void> removeListener(IsmCallMapFunction listener) async {
    // assert(
    //   _mqttInitialized,
    //   'Mqtt is not initialized',
    // );
    var mqttController = Get.find<IsmCallMqttController>();
    mqttController.eventListeners.remove(listener);
    await mqttController.eventStreamController.stream.drain();
    for (var listener in mqttController.eventListeners) {
      mqttController.eventStreamController.stream.listen(listener);
    }
  }

  void listenMqttEvent(EventModel event) {
    if (Get.isRegistered<IsmCallMqttController>()) {
      Get.find<IsmCallMqttController>().listenMqttEvent(event);
    }
  }

  void startCall({
    required String meetingId,
    required IsmAcceptCallModel call,
    required IsmCallUserInfoModel userInfo,
    required IsmCallType callType,
    List<Widget>? callActions,
    String? imageUrl,
    bool hdBroadcast = false,
    bool shouldAudioPlay = true,
    bool isAccepted = false,
  }) {
    if (!Get.isRegistered<IsmCallApiWrapper>()) {
      Get.put(IsmCallApiWrapper(Client()));
    }
    if (!Get.isRegistered<IsmCallController>()) {
      IsmCallBinding().dependencies();
    }
    _callActions = callActions;
    Get.find<IsmCallController>().joinCall(
      meetingId: meetingId,
      call: call,
      userInfo: userInfo,
      callType: callType,
      imageUrl: imageUrl,
      hdBroadcast: hdBroadcast,
      shouldAudioPlay: shouldAudioPlay,
      isAccepted: isAccepted,
    );
  }

  void callAnsDecined({
    required IsmNativeCallModel call,
    bool isAccepted = true,
  }) {
    if (!Get.isRegistered<IsmCallApiWrapper>()) {
      Get.put(IsmCallApiWrapper(Client()));
    }
    if (!Get.isRegistered<IsmCallController>()) {
      IsmCallBinding().dependencies();
    }
    IsmCallHelper.incomingCalls[call.extra.meetingId] = call;
    IsmCallHelper.$answerCall(call, isAccepted);
  }

  Future<void> _checkPushToken() async {
    if (!GetPlatform.isIOS) {
      return;
    }
    var token = await getToken();
    var pushToken = await IsmCallHelper.getPushToken() as String;
    if (pushToken.isNullOrEmpty) {
      return;
    }

    while (!Get.isRegistered<IsmCallController>()) {
      IsmCallBinding().dependencies();
    }
    if (token.isNullOrEmpty) {
      await Get.find<IsmCallController>().updatePushToken(pushToken);
    } else if (pushToken != token) {
      await Get.find<IsmCallController>().updatePushToken(pushToken, token);
    }
  }

  Future<String> getToken() async =>
      await _db.getSecuredValue(IsmCallLocalKeys.apnsToken);

  Future<bool> updateConfig(IsmCallConfig config) async {
    _config = config;
    return await _db.addConfig(config);
  }

  void onConnectivityChange(
    Function(bool) onChange,
  ) =>
      _onConnectionChange = onChange;

  void disconnectCall(String meetingId) {
    if (Get.isRegistered<IsmCallController>()) {
      Get.find<IsmCallController>().disconnectCall(
        meetingId: meetingId,
      );
    }
  }

  Future<void> dispose() async {
    Get.find<IsmCallMqttController>().disconnect();
    await Future.wait([
      _db.deleteAllSecuredValues(),
      Get.delete<IsmCallMqttController>(force: true),
      IsmCallHelper.endCall(),
      if (Get.isRegistered<IsmCallController>()) ...[
        if (GetPlatform.isIOS) ...[
          Get.find<IsmCallController>().removePushToken(true),
        ],
      ],
    ]);
  }

  void reversedTime({bool reversedTime = false}) {
    _reverseTimer = reversedTime;
  }

  void addDuration(int timeStamp) {
    if (Get.isRegistered<IsmCallController>()) {
      final controller = Get.find<IsmCallController>();
      var newTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      var now = DateTime.now();
      controller.callDuration = newTime.difference(now);
    }
  }

  void startPip() {
    callKey.currentState?.startPip();
  }

  void closePip(BuildContext? context) {
    callKey.currentState?.closePip(context);
  }

  TimerStreamSubscription addTimerListener(IsmCallDuration listener) {
    if (!Get.isRegistered<IsmCallController>()) {
      IsmCallBinding().dependencies();
    }
    var callController = Get.find<IsmCallController>();
    return callController.timerStreamController.stream.listen(listener);
  }

  Future<void> removeTimerListener(IsmCallDuration listener) async {
    if (!Get.isRegistered<IsmCallController>()) {
      IsmCallBinding().dependencies();
    }
    var callController = Get.find<IsmCallController>();
    callController.timerListeners.remove(listener);
    await callController.timerStreamController.stream.drain();
    for (var listener in callController.timerListeners) {
      callController.timerStreamController.stream.listen(listener);
    }
  }

  Future<String> getDevicePushTokenVoIP() async {
    var pushToken = await IsmCallHelper.getPushToken() as String;
    return pushToken;
  }

  void getIsUserLogedIn(
    IsmCallLoggedIn isUserLogedIn,
  ) {
    _isUserLogedIn = isUserLogedIn;
  }
}
