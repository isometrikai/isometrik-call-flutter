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
    final requested = value ?? !_controller.isMicOn;
    if (requested) {
      // Ensure permission before turning mic on
      IsmCallUtility.ensureMicrophonePermission().then((granted) {
        _controller.isMicOn = granted;
        _controller.room!.localParticipant!
            .setMicrophoneEnabled(_controller.isMicOn);
        if (!fromPushKit) {
          IsmCallHelper.toggleMic(_controller.isMicOn);
        }
      });
      return;
    }
    _controller.isMicOn = false;
    _controller.room!.localParticipant!.setMicrophoneEnabled(false);
    if (!fromPushKit) {
      IsmCallHelper.toggleMic(_controller.isMicOn);
    }
  }

  void toggleVideo([bool? value]) async {
    if (_controller.room == null) {
      return;
    }

    final requested = value ?? !_controller.isVideoOn;
    if (requested) {
      // Ensure camera permission before turning video on
      IsmCallUtility.ensureCameraPermission().then((granted) async {
        _controller.isVideoOn = granted;
        if (_controller.isVideoOn) {
          var participant = _controller.participantTracks
              .cast<IsmCallParticipantTrack?>()
              .firstWhere(
                (e) => e?.id == _controller.room?.localParticipant?.sid,
                orElse: () => null,
              );

          if (participant != null && !participant.hasVideo) {
            final enablingVideo = Get.context?.translations?.enablingVideo ??
                IsmCallStrings.enablingVideo;
            IsmCallUtility.showLoader(enablingVideo);
            await _controller.publishTracks(IsmCallTrackType.video);
            IsmCallUtility.closeLoader();
          }
        }
        unawaited(
          _controller.room!.localParticipant!
              .setCameraEnabled(_controller.isVideoOn),
        );
      });
      return;
    }

    _controller.isVideoOn = false;
    unawaited(
      _controller.room!.localParticipant!.setCameraEnabled(false),
    );
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
      final meetingId = IsmCallHelper.ongoingMeetingId ?? '';
      if (value) {
        var isStarted = await _controller._startRecording(
          meetingId.isNotEmpty ? meetingId : _controller.meetingId,
        );
        msg = 'Recording started';
        if (!isStarted) {
          msg = 'Error starting recording';
          color = IsmCallColors.red;
          _controller.isRecording = false;
        }
      } else {
        var isStopped = await _controller._stopRecording(
          meetingId.isNotEmpty ? meetingId : _controller.meetingId,
        );
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
      msg = value ? 'Recording started' : 'Recording stopped';
    }
    unawaited(
      IsmCallUtility.showToast(msg, color: color ?? IsmCallColors.green),
    );
    _controller.isProcessingRecording = false;
  }

  Timer? _screenShareMonitorTimer;
  bool _localScreenSharingState = false; // Track actual Android state

  bool get isScreenSharing => _localScreenSharingState;

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

      // For Android, ensure we have the proper permissions and service running
      if (GetPlatform.isAndroid) {
        // Start the media projection service first
        final serviceStarted =
            await MediaProjectionHelper.startMediaProjectionService();
        if (!serviceStarted) {
          IsmCallLog.error('Failed to start media projection service');
          IsmCallUtility.closeLoader();
          return;
        }

        // Ensure the service is running as a foreground service
        final isForeground =
            await MediaProjectionHelper.ensureForegroundService();
        if (!isForeground) {
          IsmCallLog.error('Failed to ensure foreground service');
          await MediaProjectionHelper.stopMediaProjectionService();
          IsmCallUtility.closeLoader();
          return;
        }

        // Wait a bit for service to start
        await Future.delayed(const Duration(milliseconds: 300));

        var isExecuting = await _requestBackgroundPermission();
        if (!isExecuting) {
          // Try again with a delay
          await Future.delayed(const Duration(milliseconds: 500));
          isExecuting = await _requestBackgroundPermission();
        }

        if (!isExecuting) {
          IsmCallLog.error(
              'Failed to get background permissions for screen sharing');
          await MediaProjectionHelper.stopMediaProjectionService();
          IsmCallUtility.closeLoader();
          return;
        }

        // Explicitly show the Android system capture permission dialog.
        // Only continue if the user accepts. If cancelled, clean up and exit without toggling UI state.
        final permissionGranted =
            await MediaProjectionHelper.showPermissionDialog();
        if (permissionGranted != true) {
          IsmCallLog.highlight('Screen share permission dialog cancelled');
          try {
            await FlutterBackground.disableBackgroundExecution();
          } catch (_) {}
          await MediaProjectionHelper.stopMediaProjectionService();
          IsmCallUtility.closeLoader();
          return;
        }

        // Start periodic check for screen sharing status
        IsmCallLog.highlight('Starting screen share monitoring');
        _startScreenShareMonitoring();

        // Start immediate monitoring for MediaProjection state changes
        IsmCallLog.highlight('Starting MediaProjection monitoring');
        await MediaProjectionHelper.startMediaProjectionMonitoring();
      }

      // Enable screen sharing
      await _controller.room!.localParticipant!.setScreenShareEnabled(
        true,
        captureScreenAudio: true,
      );

      // Verify that screen sharing actually started (especially on Android)
      bool active = true;
      if (GetPlatform.isAndroid) {
        // Allow a short delay for projection to become active
        await Future.delayed(const Duration(milliseconds: 200));
        active = await MediaProjectionHelper.isScreenSharingActive();
      }

      if (!active) {
        IsmCallLog.highlight(
            'Screen share not active after enabling, reverting');
        await _disableLiveKitScreenShare();
        _localScreenSharingState = false;
        _controller.update([IsmCallView.updateId]);
        return;
      }

      // Update local and reactive state only when confirmed active
      _localScreenSharingState = true;
      _controller.isScreenSharing = true;
      _controller.update([IsmCallView.updateId]);
    } catch (e, st) {
      IsmCallLog.error('Screen sharing error: $e', st);
      // Try to disable screen sharing if it was partially enabled
      try {
        await _controller.room!.localParticipant!.setScreenShareEnabled(false);
        if (GetPlatform.isAndroid) {
          await MediaProjectionHelper.stopMediaProjectionService();
        }
      } catch (disableError) {
        IsmCallLog.error(
            'Failed to disable screen sharing after error: $disableError');
      }
    } finally {
      IsmCallUtility.closeLoader();
    }
  }

  void _startScreenShareMonitoring() {
    _screenShareMonitorTimer?.cancel();
    IsmCallLog.highlight('Starting periodic screen share monitoring (500ms)');
    _screenShareMonitorTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!isScreenSharing) {
        IsmCallLog.highlight('Screen sharing stopped, canceling timer');
        timer.cancel();
        return;
      }

      // Check if screen sharing is actually active
      if (GetPlatform.isAndroid) {
        _checkScreenShareStatus();
      }
    });
  }

  void _checkScreenShareStatus() async {
    try {
      // Check if screen sharing is actually active
      final isActive = await MediaProjectionHelper.isScreenSharingActive();
      IsmCallLog.highlight(
          'Screen share status check: isActive=$isActive, localState=$_localScreenSharingState');

      if (!isActive && _localScreenSharingState) {
        // Screen sharing stopped by system, update state and disable LiveKit
        IsmCallLog.highlight(
            'Screen sharing stopped by system, updating state');
        _localScreenSharingState = false;
        await _disableLiveKitScreenShare();

        // Force UI update
        _controller.update([IsmCallView.updateId]);
      }
    } catch (e) {
      // If check fails, assume screen sharing stopped
      IsmCallLog.error('Error checking screen share status: $e');
      if (_localScreenSharingState) {
        _localScreenSharingState = false;
        await _disableLiveKitScreenShare();

        // Force UI update
        _controller.update([IsmCallView.updateId]);
      }
    }
  }

  Future<void> _disableLiveKitScreenShare() async {
    try {
      // Only disable LiveKit screen sharing, don't stop the monitoring
      await _controller.room!.localParticipant!.setScreenShareEnabled(false);
      if (GetPlatform.isAndroid) {
        await FlutterBackground.disableBackgroundExecution();
        await MediaProjectionHelper.stopMediaProjectionService();
      }

      // Stop the monitoring timer
      _screenShareMonitorTimer?.cancel();
      _screenShareMonitorTimer = null;

      // Ensure UI reflects stopped state
      _localScreenSharingState = false;
      _controller.isScreenSharing = false;
      _controller.update([IsmCallView.updateId]);
    } catch (e, st) {
      IsmCallLog.error('Error disabling LiveKit screen share: $e', st);
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
        await MediaProjectionHelper.stopMediaProjectionService();
      }

      // Update local state
      _localScreenSharingState = false;
      _controller.isScreenSharing = false;

      // Stop the monitoring timer
      _screenShareMonitorTimer?.cancel();
      _screenShareMonitorTimer = null;

      // Force UI update so controls reflect stopped state
      _controller.update([IsmCallView.updateId]);
    } catch (e, st) {
      IsmCallLog.error(e, st);
    } finally {
      IsmCallUtility.closeLoader();
    }
  }

  void disconnectCall({
    required String meetingId,
    bool fromPushKit = false,
    bool fromMqtt = false,
  }) {
    _controller._disconnectDebouncer.run(
      () => _disconnectCall(
        meetingId: meetingId,
        fromPushKit: fromPushKit,
        fromMqtt: fromMqtt,
      ),
    );
  }

  void _disconnectCall({
    required String meetingId,
    bool fromPushKit = false,
    bool fromMqtt = false,
  }) async {
    if (meetingId.isEmpty) {
      return;
    }

    if (Get.currentRoute == IsmCallRoutes.call) {
      Get.back();
    }

    await Future.wait([
      if (!fromPushKit) ...[
        // Pass meetingId if available so the correct native notification ends
        IsmCallHelper.endCall(meetingId: meetingId),
      ],
      (IsmCall.i.endCall ?? _controller.endCall).call(
        meetingId,
        IsmCallHelper.incomingMetaData,
      ),
      if (_controller.room != null) ...[
        _controller.room!.disconnect(),
      ],
    ]);

    IsmCallHelper.callTriggerStatusStream.add(
      (
        status:
            fromMqtt ? IsmCallStatus.rejectSuccess : IsmCallStatus.callEnded,
        meetingId: meetingId,
        data: IsmCallHelper.incomingMetaData,
      ),
    );
    _controller.$callStreamTimer?.cancel();
    _controller._waitingTimer?.cancel();
    _controller._ringingTimer?.cancel();
  }
}
