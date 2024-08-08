import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallHelper {
  const IsmCallHelper._();

  static Map<String, IsmNativeCallModel> incomingCalls = {};

  static IsmNativeCallModel? ongoingCall;

  static bool actionTriggered = false;

  static bool hasCall = false;

  static final IsmCallDebouncer _ringingDebouncer =
      IsmCallDebouncer(milliseconds: 500);

  static final IsmCallDebouncer _debouncer =
      IsmCallDebouncer(milliseconds: 500);

  static final IsmCallDebouncer _onEndCallDebouncer =
      IsmCallDebouncer(milliseconds: 500);

  static String? get callId => ongoingCall?.id;

  static String? get ongoingMeetingId => ongoingCall?.extra.meetingId;

  static final _callTriggerStatusStream =
      StreamController<IsmCallTriggerModel>.broadcast();

  static final _callTriggerListeners = <IsmCallTriggerFunction>[];

  static IsmCallTriggerStreamSubscription addCallTriggerListener(
    IsmCallTriggerFunction listener,
  ) =>
      _callTriggerStatusStream.stream.listen(listener);

  static Future<void> removeCallTriggerListener(
    IsmCallTriggerFunction listener,
  ) async {
    _callTriggerListeners.remove(listener);
    await _callTriggerStatusStream.stream.drain();
    for (var listener in _callTriggerListeners) {
      _callTriggerStatusStream.stream.listen(listener);
    }
  }

  static IsmCallController get _controller {
    if (!Get.isRegistered<IsmCallController>()) {
      IsmCallBinding().dependencies();
    }
    return Get.find();
  }

  static void triggerCall({
    required String id,
    required String meetingId,
    required String userIdentifier,
    required String userId,
    String? name,
    String? imageUrl,
    String? ip,
    String? callType,
  }) async {
    IsmCallLog('Here ');
    if (callId != null) {
      await endCall();
    }
    var callKitParams = CallKitParams(
      id: callId,
      nameCaller: name,
      appName: 'CallQwik',
      avatar: imageUrl,
      handle: ip,
      type: 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      duration: 1000,
      extra: <String, dynamic>{
        'id': id,
        'meetingId': meetingId,
        'name': name,
        'imageUrl': imageUrl,
        'ip': ip,
        'userIdentifier': userIdentifier,
        'userId': userId,
        'callType': callType ?? 'audio',
        'platform': 'flutter',
      },
      android: AndroidParams(
        isCustomNotification: false,
        isShowLogo: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: IsmCallColors.background.hexCode,
        backgroundUrl: imageUrl,
        actionColor: IsmCallColors.primary.hexCode,
        textColor: IsmCallColors.white.hexCode,
        incomingCallNotificationChannelName: 'Incoming Call',
        isShowCallID: false,
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }

  static void requestNotification() {
    FlutterCallkitIncoming.requestNotificationPermission({
      'rationaleMessagePermission':
          'Notification permission is required, to show notification.',
      'postNotificationMessageRequired':
          'Notification permission is required, Please allow notification permission from setting.'
    });
  }

  static void listenCallEvents() {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      if (event == null) {
        return;
      }
      var call = IsmNativeCallModel.fromMap(event.body as Map<String, dynamic>);
      try {
        IsmCallLog.highlight(
            'NativeCallEvent - ${event.event}\n${call.toJson()}');
      } catch (e, st) {
        IsmCallLog.error(e, st);
      }
      switch (event.event) {
        case Event.actionCallIncoming:
          startRinging(call);
          break;
        case Event.actionCallStart:
          _handleCallStarted();
          break;
        case Event.actionCallAccept:
          $answerCall(call, true);
          break;
        case Event.actionCallDecline:
          $answerCall(call, false);
          break;
        case Event.actionCallEnded:
          onEndCall(call);
          break;
        case Event.actionCallTimeout:
          unawaited(IsmCallChannelHandler.handleTimeout(call.extra.uid));
          _callTriggerStatusStream.add((
            status: IsmCallStatus.callMissed,
            meetingId: call.id,
          ));
          break;
        case Event.actionCallCallback:
          // only Android - click action `Call back` from missed call notification
          break;
        case Event.actionCallToggleHold:
          // only iOS
          break;
        case Event.actionCallToggleMute:
          _controller.toggleMic(
            value: !call.isMuted,
            fromPushKit: true,
          );
          break;
        case Event.actionCallToggleDmtf:
          // only iOS
          break;
        case Event.actionCallToggleGroup:
          // only iOS
          break;
        case Event.actionCallToggleAudioSession:
          // only iOS
          break;
        case Event.actionDidUpdateDevicePushTokenVoip:
          if (GetPlatform.isIOS) {
            var token = await getPushToken();
            unawaited(_controller.updatePushToken(token));
          }
          break;
        case Event.actionCallCustom:
          break;
        default:
          IsmCallLog.error(event);
      }
    });
  }

  static Future<dynamic> getPushToken() =>
      FlutterCallkitIncoming.getDevicePushTokenVoIP();

  static void startRinging(IsmNativeCallModel call) {
    _ringingDebouncer.run(() => _startRinging(call));
  }

  static void _startRinging(IsmNativeCallModel call) {
    if (Get.context == null) {
      IsmCallUtility.updateLater(() {
        incomingCalls[call.extra.meetingId] = call;
      });
    } else {
      incomingCalls[call.extra.meetingId] = call;
    }
    // IsmCallRouteManagement.goToIncomingCall(
    //   IsmIncomingCallArgument(
    //     id: data['id'] as String? ?? '',
    //     meetingId: data['meetingId'] as String? ?? '',
    //     imageUrl: data['imageUrl'] as String? ?? '',
    //     name: data['name'] as String? ?? '',
    //     ip: data['ip'] as String? ?? '',
    //     isAudioOnly: false,
    //   ),
    // );
  }

  static void startCall() {
    // FlutterCallkitIncoming.startCall(params);
  }

  static Future<void> toggleMic(bool value) => FlutterCallkitIncoming.muteCall(
        callId ?? '',
        isMuted: !value,
      );

  static Future<void> pickCall() =>
      FlutterCallkitIncoming.setCallConnected(callId ?? '');

  static void pickedByOther() {
    endCall();
  }

  static void callMissed(String meetingId) {
    final showMissCall = Get.context?.properties?.showMissCall ?? true;
    if (showMissCall) {
      final misscalled =
          Get.context?.translations?.misscalled ?? IsmCallStrings.youMissedCall;
      unawaited(IsmCallUtility.showToast(
        misscalled,
        color: Colors.orange,
      ));
    }
    incomingCalls.remove(meetingId);
    unawaited(FlutterCallkitIncoming.endCall(meetingId));
    unawaited(IsmCallChannelHandler.handleCallEnd(meetingId));

    _callTriggerStatusStream.add((
      status: IsmCallStatus.callMissed,
      meetingId: meetingId,
    ));
  }

  static void callEndByHost(String meetingId) {
    if (ongoingMeetingId != meetingId) {
      return;
    }
    final showOpponentCallEnded =
        Get.context?.properties?.showOpponentCallEnded ?? true;
    if (showOpponentCallEnded) {
      final opponentCallEnded = Get.context?.translations?.opponentCallEnded ??
          IsmCallStrings.meetingEndedHost;
      unawaited(IsmCallUtility.showToast(opponentCallEnded));
    }
    _endAllCalls();
  }

  static Future<void> endCall({
    String? meetingId,
    bool isMissed = false,
  }) async {
    _debouncer.run(() => _endCall(
          meetingId: meetingId,
          isMissed: isMissed,
        ));
  }

  static Future<void> _endCall({
    String? meetingId,
    bool isMissed = false,
  }) async {
    var $callId = callId;
    if (ongoingMeetingId != meetingId) {
      var call = incomingCalls.values.cast<IsmNativeCallModel?>().firstWhere(
            (e) => e?.extra.meetingId == meetingId,
            orElse: () => null,
          );
      if (call != null) {
        $callId = call.uuid;
      }
    }
    if ($callId.isNullOrEmpty) {
      return;
    }

    if (!isMissed) {
      unawaited(FlutterCallkitIncoming.endCall($callId ?? ''));
      unawaited(IsmCallChannelHandler.handleCallEnd($callId ?? ''));
      IsmCallHelper.ongoingCall = null;
    }
  }

  static Future<void> _endAllCalls() => FlutterCallkitIncoming.endAllCalls();

  static void onEndCall(IsmNativeCallModel call) async {
    _onEndCallDebouncer.run(() => _onEndCall(call));
  }

  static void _onEndCall(IsmNativeCallModel call) async {
    if (!hasCall) {
      return;
    }
    hasCall = false;

    final id = call.extra.meetingId;
    if (!incomingCalls.containsKey(id)) {
      return;
    }

    unawaited(IsmCallChannelHandler.handleCallEnd(id));
    incomingCalls.remove(id);
    IsmCallHelper.ongoingCall = null;
    _controller.disconnectCall(
      meetingId: id,
      fromPushKit: true,
    );
    _callTriggerStatusStream.add((
      status: IsmCallStatus.callEnded,
      meetingId: id,
    ));
  }

  static void $answerCall(
    IsmNativeCallModel call,
    bool isAccepted,
  ) {
    final id = call.extra.meetingId;
    if (!incomingCalls.containsKey(id)) {
      return;
    }
    if (Get.context == null) {
      IsmCallUtility.updateLater(() {
        _answerCall(call, isAccepted);
      });
    } else {
      _answerCall(call, isAccepted);
    }
  }

  static void _answerCall(
    IsmNativeCallModel call,
    bool isAccepted,
  ) async {
    try {
      hasCall = true;

      if (isAccepted) {
        ongoingCall = call;
        unawaited(IsmCallChannelHandler.handleCallStarted(call.id));
      } else {
        unawaited(IsmCallChannelHandler.handleCallDeclined(call.id));
      }

      var meetingId = call.extra.meetingId;
      if (meetingId.isEmpty) {
        unawaited(IsmCallUtility.showToast(
          'Call not found',
          color: IsmCallColors.red,
        ));
        unawaited(_endAllCalls());
        return;
      }

      if (isAccepted) {
        final callModel =
            await (IsmCall.i.acceptCall ?? _controller.acceptCall).call(
          meetingId,
          IsmCall.i.config?.projectConfig.deviceId ?? '',
        );
        if (callModel == null) {
          _callTriggerStatusStream.add((
            status: IsmCallStatus.acceptError,
            meetingId: meetingId,
          ));
          unawaited(IsmCallHelper.endCall());
        } else {
          _callTriggerStatusStream.add((
            status: IsmCallStatus.acceptSuccess,
            meetingId: meetingId,
          ));

          var userInfo = IsmCallUserInfoModel.fromMap(call.extra.toMap());

          unawaited(_controller.joinCall(
            meetingId: meetingId,
            call: callModel,
            userInfo: userInfo,
            callType: call.type,
          ));
        }
      } else {
        final isDeclined =
            await (IsmCall.i.declineCall ?? _controller.declineCall).call(
          meetingId,
        );
        if (isDeclined) {
          _callTriggerStatusStream.add((
            status: IsmCallStatus.rejectSuccess,
            meetingId: meetingId,
          ));
        } else {
          _callTriggerStatusStream.add((
            status: IsmCallStatus.rejectError,
            meetingId: meetingId,
          ));
        }
      }
    } catch (e) {
      unawaited(_endAllCalls());
      unawaited(IsmCallUtility.showToast(
        'Error: Answering - $e',
        color: IsmCallColors.red,
      ));
    }
  }

  static void _handleCallStarted() {
    _endAllCalls();
  }
}
