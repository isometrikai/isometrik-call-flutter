part of '../call_controller.dart';

mixin IsmCallOngoingMixin {
  IsmCallController get _controller => Get.find();

  void toggleMic({
    bool? value,
    bool fromPushKit = false,
  }) {
    _controller._micDebouncer.run(
      () => _toggleMic(
        value: value,
        fromPushKit: fromPushKit,
      ),
    );
  }

  void _toggleMic({
    bool? value,
    bool fromPushKit = false,
  }) {
    if (_controller.room == null) {
      return;
    }
    _controller.isMicOn = value ?? !_controller.isMicOn;
    _controller.room!.localParticipant!
        .setMicrophoneEnabled(_controller.isMicOn);
    if (!fromPushKit) {
      IsmCallHelper.toggleMic(_controller.isMicOn);
    }
  }

  void toggleVideo([bool? value]) async {
    if (_controller.room == null) {
      return;
    }
    _controller.isVideoOn = value ?? !_controller.isVideoOn;
    if (_controller.isVideoOn) {
      var participant = _controller.participantTracks
          .firstWhere((e) => e.id == _controller.room!.localParticipant!.sid);
      if (!participant.hasVideo) {
        final enablingVideo = Get.context?.translations?.enablingVideo ??
            IsmCallStrings.enablingVideo;
        IsmCallUtility.showLoader(enablingVideo);
        await _controller.publishTracks(IsmCallTrackType.video);
        IsmCallUtility.closeLoader();
      }
    }
    unawaited(_controller.room!.localParticipant!
        .setCameraEnabled(_controller.isVideoOn));
  }

  void flipCamera() {
    final participant = _controller.room?.localParticipant;
    if (participant == null) {
      return;
    }
    final track = participant.videoTrackPublications.firstOrNull?.track;
    if (track == null) return;

    try {
      _controller.isFrontCamera = !_controller.isFrontCamera;
      final newPosition = _controller.position.switched();
      track.setCameraPosition(newPosition);
    } catch (error) {
      return;
    }
  }

  void toggleSpeaker([bool? value]) {
    if (_controller.room == null) {
      return;
    }
    _controller.isSpeakerOn = value ?? !_controller.isSpeakerOn;
    _controller.room!.setSpeakerOn(_controller.isSpeakerOn);
  }

  void toggleLargeVideo() {
    _controller.isRemoteVideoLarge = !_controller.isRemoteVideoLarge;
    if (_controller.isRemoteVideoLarge) {
      _controller.showFullVideo = _controller.participantTracks.length != 1;
    } else {
      _controller.showFullVideo = false;
    }
  }

  void toggleRecording(
    bool value, {
    bool triggerAPI = true,
    String? name,
  }) async {
    if (_controller.isProcessingRecording) {
      return;
    }
    _controller.isProcessingRecording = true;
    _controller.isRecording = value;
    var msg = '';
    Color? color;
    if (triggerAPI) {
      _controller.recordingText = "You're recording";
      if (value) {
        var isStarted = await _controller
            ._startRecording(IsmCallHelper.ongoingMeetingId ?? '');
        msg = 'Recording started';
        if (!isStarted) {
          msg = 'Error starting recording';
          color = IsmCallColors.red;
          _controller.isRecording = false;
        }
      } else {
        var isStopped = await _controller
            ._stopRecording(IsmCallHelper.ongoingMeetingId ?? '');
        msg = 'Recording stopped';
        if (!isStopped) {
          color = IsmCallColors.red;
          msg = 'Error stopping recording';
          _controller.isRecording = true;
        }
      }
    } else {
      _controller.recordingText =
          name == null ? 'Recording' : '$name is recording';
    }
    unawaited(
        IsmCallUtility.showToast(msg, color: color ?? IsmCallColors.green));
    _controller.isProcessingRecording = false;
  }

  bool get isScreenSharing =>
      _controller.room?.localParticipant?.isScreenShareEnabled() ?? false;

  void toggleScreenShare([bool? value]) {
    final shouldEnable = value ?? !isScreenSharing;
    if (shouldEnable) {
      _enableScreenShare();
    } else {
      _disableScreenShare();
    }
  }

  Future<bool> _requestBackgroundPermission([bool isRetry = false]) async {
    // Required for android screenshare.
    try {
      var hasPermissions = await FlutterBackground.hasPermissions;
      if (!isRetry) {
        final appName =
            Get.context?.translations?.appName ?? IsmCallConstants.appName;
        final androidConfig = FlutterBackgroundAndroidConfig(
          notificationTitle: 'Screen Sharing',
          notificationText: '$appName is sharing the screen.',
          notificationIcon: const AndroidResource(
            name: 'ic_launcher',
            defType: 'mipmap',
          ),
        );
        hasPermissions = await FlutterBackground.initialize(
          androidConfig: androidConfig,
        );
      }
      if (hasPermissions && !FlutterBackground.isBackgroundExecutionEnabled) {
        return await FlutterBackground.enableBackgroundExecution();
      }
      return false;
    } catch (e, st) {
      if (!isRetry) {
        return await Future<bool>.delayed(
          const Duration(seconds: 1),
          () => _requestBackgroundPermission(true),
        );
      }
      IsmCallLog.error('Could not publish video: $e', st);
      return false;
    }
  }

  void _enableScreenShare() async {
    try {
      IsmCallUtility.showLoader();
      if (_controller.room == null ||
          _controller.room!.localParticipant == null) {
        return;
      }

      var isExecuting =
          GetPlatform.isIOS || await _requestBackgroundPermission();
      if (!isExecuting) {
        isExecuting = GetPlatform.isIOS || await _requestBackgroundPermission();
      }
      if (isExecuting) {
        await _controller.room!.localParticipant!.setScreenShareEnabled(
          true,
          captureScreenAudio: true,
        );
      }
    } catch (e, st) {
      IsmCallLog.error(e, st);
    } finally {
      IsmCallUtility.closeLoader();
    }
  }

  void _disableScreenShare() async {
    try {
      IsmCallUtility.showLoader();
      await _controller.room!.localParticipant!.setScreenShareEnabled(
        false,
      );
      if (GetPlatform.isAndroid) {
        await FlutterBackground.disableBackgroundExecution();
      }
    } catch (e, st) {
      IsmCallLog.error(e, st);
    } finally {
      IsmCallUtility.closeLoader();
    }
  }

  void disconnectCall({
    required String meetingId,
    bool fromPushKit = false,
  }) {
    _controller._disconnectDebouncer.run(
      () => _disconnectCall(
        meetingId: meetingId,
        fromPushKit: fromPushKit,
      ),
    );
  }

  void _disconnectCall({
    required String meetingId,
    bool fromPushKit = false,
  }) async {
    if (meetingId.isEmpty) {
      return;
    }
    unawaited(IsmCallUtility.stopAudio());

    if (Get.currentRoute == IsmCallRoutes.call) {
      Get.back();
    }
    final showNotes = (Get.context?.properties?.showAddNotesOnCallEnd ?? true);
    if (!fromPushKit && showNotes) {
      // unawaited(
      //   IsmCallUtility.openBottomSheet(
      //     IsmCallAddNoteSheet(meetingId: meetingId),
      //     isScrollControlled: true,
      //   ),
      // );
    }

    await Future.wait([
      if (!fromPushKit) ...[
        IsmCallHelper.endCall(),
      ],
      (IsmCall.i.endCall ?? _controller.endCall).call(meetingId),
      if (_controller.room != null) ...[
        _controller.room!.disconnect(),
      ],
    ]);
    // if (Get.isRegistered<IsmLogsController>()) {
    //   unawaited(Get.find<IsmLogsController>().refreshLogs());
    // }

    _controller.$callStreamTimer?.cancel();
    _controller._ringingTimer?.cancel();
  }
}
