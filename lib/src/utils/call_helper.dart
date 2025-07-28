import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallHelper {
  const IsmCallHelper._();

  static Map<String, IsmNativeCallModel> incomingCalls = {};

  static Map<String, dynamic> incomingMetaData = {};

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

  static final callTriggerStatusStream =
      StreamController<IsmCallTriggerModel>.broadcast();

  static final _callTriggerListeners = <IsmCallTriggerFunction>[];

  static IsmCallTriggerStreamSubscription addCallTriggerListener(
    IsmCallTriggerFunction listener,
  ) =>
      callTriggerStatusStream.stream.listen(listener);

  static Future<void> removeCallTriggerListener(
    IsmCallTriggerFunction listener,
  ) async {
    _callTriggerListeners.remove(listener);
    await callTriggerStatusStream.stream.drain();
    for (var listener in _callTriggerListeners) {
      callTriggerStatusStream.stream.listen(listener);
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
          'Notification permission is required, Please allow notification permission from setting.',
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
          'NativeCallEvent - ${event.event}\n${call.toJson()}',
        );
      } catch (e, st) {
        IsmCallLog.error(e, st);
      }
      switch (event.event) {
        case Event.actionCallIncoming:
          incomingMetaData = call.extra.metaData;
          startRinging(call);
          break;
        case Event.actionCallStart:
          incomingMetaData = call.extra.metaData;
          _handleCallStarted();
          break;
        case Event.actionCallAccept:
          incomingMetaData = call.extra.metaData;
          $answerCall(call, true);
          break;
        case Event.actionCallDecline:
          incomingMetaData = call.extra.metaData;
          $answerCall(call, false);
          break;
        case Event.actionCallEnded:
          incomingMetaData = call.extra.metaData;
          onEndCall(call);
          break;
        case Event.actionCallTimeout:
          unawaited(IsmCallChannelHandler.handleTimeout(call.extra.uid));
          callTriggerStatusStream.add(
            (
              status: IsmCallStatus.callMissed,
              meetingId: call.id,
              data: {},
            ),
          );
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
        case Event.actionCallConnected:
          // TODO: Handle this case.
          throw UnimplementedError();
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
      unawaited(
        IsmCallUtility.showToast(
          misscalled,
          color: Colors.orange,
        ),
      );
    }
    incomingCalls.remove(meetingId);
    unawaited(FlutterCallkitIncoming.endCall(meetingId));
    if (GetPlatform.isIOS) {
      unawaited(IsmCallChannelHandler.handleCallEnd(meetingId));
    }
    callTriggerStatusStream.add(
      (status: IsmCallStatus.callMissed, meetingId: meetingId, data: {}),
    );
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
    _debouncer.run(
      () => _endCall(
        meetingId: meetingId,
        isMissed: isMissed,
      ),
    );
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
  }

  static void $answerCall(
    IsmNativeCallModel call,
    bool isAccepted, [
    IsmCallCanJoinCallback? canJoinCallForWeb,
  ]) {
    final id = call.extra.meetingId;
    if (!incomingCalls.containsKey(id)) {
      return;
    }
    if (Get.context == null) {
      IsmCallUtility.updateLater(() {
        _answerCall(call, isAccepted, canJoinCallForWeb);
      });
    } else {
      _answerCall(call, isAccepted, canJoinCallForWeb);
    }
  }

  static void _answerCall(
    IsmNativeCallModel call,
    bool isAccepted, [
    IsmCallCanJoinCallback? canJoinCallForWeb,
  ]) async {
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
        unawaited(
          IsmCallUtility.showToast(
            'Call not found',
            color: IsmCallColors.red,
          ),
        );
        unawaited(_endAllCalls());
        return;
      }

      if (isAccepted) {
        final callModel =
            await (IsmCall.i.acceptCall ?? _controller.acceptCall).call(
          meetingId,
          IsmCall.i.config?.projectConfig.deviceId ?? '',
          call.extra.metaData,
        );
        if (callModel == null) {
          call.extra.metaData.addAll(call.extra.toMap());
          callTriggerStatusStream.add(
            (
              status: IsmCallStatus.acceptError,
              meetingId: meetingId,
              data: call.extra.metaData,
            ),
          );
          unawaited(IsmCallHelper.endCall());
        } else {
          callTriggerStatusStream.add(
            (
              status: IsmCallStatus.acceptSuccess,
              meetingId: meetingId,
              data: call.extra.metaData,
            ),
          );
          var userInfo = IsmCallUserInfoModel.fromMap(call.extra.toMap());
          unawaited(
            _controller.joinCall(
              meetingId: meetingId,
              call: callModel,
              userInfo: userInfo,
              callType: call.type,
              isAccepted: isAccepted,
              canJoinCallForWeb: canJoinCallForWeb,
            ),
          );
        }
      } else {
        final isDeclined =
            await (IsmCall.i.declineCall ?? _controller.declineCall).call(
          meetingId,
          call.extra.metaData,
        );
        if (isDeclined) {
          callTriggerStatusStream.add(
            (
              status: IsmCallStatus.rejectSuccess,
              meetingId: meetingId,
              data: call.extra.metaData,
            ),
          );
        } else {
          callTriggerStatusStream.add(
            (
              status: IsmCallStatus.rejectError,
              meetingId: meetingId,
              data: call.extra.metaData,
            ),
          );
        }
      }
    } catch (e) {
      unawaited(_endAllCalls());
      unawaited(
        IsmCallUtility.showToast(
          'Error: Answering - $e',
          color: IsmCallColors.red,
        ),
      );
    }
  }

  static void _handleCallStarted() {
    _endAllCalls();
  }
}
