part of '../call_controller.dart';

mixin IsmCallJoinMixin {
  IsmCallController get _controller => Get.find();

  // Join a stream
  Future<void> joinCall({
    required String meetingId,
    required IsmAcceptCallModel call,
    required IsmCallUserInfoModel userInfo,
    required IsmCallType callType,
    String? imageUrl,
    bool hdBroadcast = false,
    bool shouldAudioPlay = false,
    bool isAccepted = false,
    IsmCallCanJoinCallback? canJoinCallForWeb,
  }) async {
    // Get the token for the stream based on whether the user is a host or not

    var startTime = call.joinTime == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(call.joinTime ?? 0);
    var now = DateTime.now();
    _controller.callDuration = now.difference(startTime);

    // Connect to the stream
    await _connectStream(
      meetingId: meetingId,
      call: call,
      imageUrl: imageUrl,
      hdBroadcast: hdBroadcast,
      userInfo: userInfo,
      callType: callType,
      shouldAudioPlay: shouldAudioPlay,
      isAccepted: isAccepted,
      canJoinCallForWeb: canJoinCallForWeb,
    );
  }

  Future<void> _initializeTracks(
    Room room, {
    required IsmCallType callType,
    required String meetingId,
    bool shouldAudioPlay = false,
  }) async {
    room.localParticipant?.setTrackSubscriptionPermissions(
      allParticipantsAllowed: true,
      trackPermissions: [
        const ParticipantTrackPermission(
          'allowed-identity',
          true,
          null,
        ),
      ],
    );

    unawaited(
      publishTracks(callType.trackType).then(
        (_) {
          if (shouldAudioPlay) startCallingTimer(meetingId);
          _enableTracks(callType.trackType);
          _controller.toggleSpeaker(callType == IsmCallType.video);
        },
      ),
    );
  }

  // Enable the user's video
  Future<void> publishTracks(IsmCallTrackType trackType) async {
    // Add small delay before camera initialization
    await Future.delayed(const Duration(milliseconds: 500));

    final tracks = await Future.wait([
      if (trackType.hasAudio) ...[
        LocalAudioTrack.create(),
      ],
      if (trackType.hasVideo) ...[
        LocalVideoTrack.createCameraTrack(),
      ],
    ]);

    LocalAudioTrack? localAudio;
    LocalVideoTrack? localVideo;

    if (trackType.hasAudio) {
      localAudio = tracks[0] as LocalAudioTrack;
    }
    if (trackType.hasVideo) {
      var index = trackType.hasAudio ? 1 : 0;
      localVideo = tracks[index] as LocalVideoTrack;
    }

    await Future.wait<dynamic>([
      if (trackType.hasAudio) ...[
        _controller.room!.localParticipant!.publishAudioTrack(localAudio!),
      ],
      if (trackType.hasVideo && localVideo != null) ...[
        _controller.room!.localParticipant!.publishVideoTrack(localVideo),
      ],
    ]);
  }

  Future<void> _enableTracks(IsmCallTrackType trackType) async {
    await Future.wait<dynamic>([
      if (trackType.hasVideo) ...[
        _controller.room!.localParticipant!.setCameraEnabled(true),
      ],
      if (trackType.hasAudio) ...[
        _controller.room!.localParticipant!.setMicrophoneEnabled(true),
      ],
    ]);
  }

  // Connect to the stream
  Future<void> _connectStream({
    required String meetingId,
    required IsmAcceptCallModel call,
    required IsmCallUserInfoModel userInfo,
    required IsmCallType callType,
    String? imageUrl,
    bool hdBroadcast = false,
    bool shouldAudioPlay = false,
    bool isAccepted = false,
    IsmCallCanJoinCallback? canJoinCallForWeb,
  }) async {
    final message =
        Get.context?.translations?.joining ?? IsmCallStrings.joining;
    IsmCallUtility.showLoader(message);

    if (shouldAudioPlay && !isAccepted) {
      startWaitingTimer();
      unawaited(IsmCallUtility.playAudioFromAssets(IsmCallAssets.callingMp3));
    } else {
      startWaitingTimer();
    }

    try {
      final videoQuality = hdBroadcast
          ? const VideoParameters(
              dimensions: VideoDimensions(
                720,
                1280,
              ),
              encoding: VideoEncoding(
                maxBitrate: 2000 * 1000,
                maxFramerate: 30,
              ),
            ) // VideoParametersPresets.h720_169

          : VideoParametersPresets.h540_169;
      var room = Room(
        roomOptions: RoomOptions(
          defaultCameraCaptureOptions: CameraCaptureOptions(
            cameraPosition: CameraPosition.front,
            params: videoQuality,
            deviceId: IsmCall.i.config?.projectConfig.deviceId ?? '',
          ),
          defaultAudioCaptureOptions: const AudioCaptureOptions(
            noiseSuppression: true,
            echoCancellation: true,
            autoGainControl: true,
            highPassFilter: true,
            typingNoiseDetection: true,
          ),
          defaultVideoPublishOptions: VideoPublishOptions(
            videoEncoding: videoQuality.encoding,
            simulcast: false,
          ),
          defaultAudioPublishOptions: const AudioPublishOptions(
            dtx: true,
          ),
        ),
        // connectOptions: ConnectOptions(
        //   timeouts: Timeouts.defaultTimeouts.ismCallCopyWith(
        //     connection: const Duration(seconds: 30),
        //     peerConnection: const Duration(seconds: 30),
        //     publish: const Duration(seconds: 30),
        //     iceRestart: const Duration(seconds: 30),
        //   ),
        // ),
      );

      _controller.room = room;

      // Create a Listener before connecting
      _controller.listener = room.createListener();

      // Try to connect to the room
      try {
        unawaited(
          room
              .connect(
                IsmCallEndpoints.wsUrl,
                call.rtcToken,
              )
              .then(
                (_) => _initializeTracks(
                  room,
                  callType: callType,
                  shouldAudioPlay: shouldAudioPlay,
                  meetingId: meetingId,
                ),
              ),
        );
      } catch (e, st) {
        IsmCallLog.error(e, st);
        IsmCallUtility.closeLoader();
        return;
      }

      _controller.isVideoOn = callType.isVideo;

      IsmCallUtility.closeLoader();

      _controller.isRemoteVideoLarge = true;
      if (canJoinCallForWeb != null) {
        canJoinCallForWeb.call(
          userInfo: userInfo,
          meetingId: meetingId,
          audioOnly: !callType.isVideo,
          isAccepted: isAccepted,
        );
      } else {
        unawaited(
          IsmCallRouteManagement.goToCall(
            userInfo: userInfo,
            audioOnly: !callType.isVideo,
            meetingId: meetingId,
            isAccepted: isAccepted,
          ),
        );
      }
    } catch (e, st) {
      IsmCallLog.error(e, st);
    }
  }

  void startStreamTimer() {
    _controller.$callStreamTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_controller.ismDelegate.reverseTimer) {
          _controller.callDuration -= const Duration(
            seconds: 1,
          );
        } else {
          _controller.callDuration += const Duration(
            seconds: 1,
          );
        }
        _controller.timerStreamController.add(_controller.callDuration);
      },
    );
  }

  void startWaitingTimer() {
    _controller._waitingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_controller.participantTracks.length > 1) {
          timer.cancel();
          startStreamTimer();
        }
      },
    );
  }

  void startCallingTimer(String meetingId) {
    _controller._ringingTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == 31) {
        _checkParticipants(meetingId);
        _controller._ringingTimer?.cancel();
      }
    });
  }

  void _checkParticipants(String meetingId) {
    final localParticipant = _controller.room?.localParticipant;
    if (_controller.participantTracks.length == 1) {
      final track = _controller.participantTracks.first;

      if (localParticipant?.sid == track.id) {
        _controller.disconnectCall(
          meetingId: meetingId,
        );
        IsmCallUtility.showToast(
          'No Answer',
        );
      }
    }
  }

  // Function to set up event listeners
  void setUpListeners(String meetingId) => _controller.listener
    ?..on<RoomDisconnectedEvent>((event) async {
      IsmCallLog.highlight('RoomDisconnectedEvent: $event');
      if (event.reason == DisconnectReason.roomDeleted) {
        IsmCallLog.success('Room Deleted');
      }
    })
    ..on<ParticipantEvent>((event) {
      IsmCallLog.highlight('ParticipantEvent: $event');
      sortParticipants();
    })
    ..on<ParticipantDisconnectedEvent>((event) {
      IsmCallLog.highlight('ParticipantDisconnectedEvent: $event');
      final showOpponentLeft =
          Get.context?.properties?.showOpponentLeft ?? true;
      if (showOpponentLeft) {
        final opponentLeft = Get.context?.translations?.opponentLeft ??
            IsmCallStrings.opponentLeft;
        IsmCallUtility.showToast(
          opponentLeft,
          color: Colors.orange,
        );
      }
      _controller.disconnectCall(
        meetingId: meetingId,
      );
    });

  Future<void> sortParticipants() async {
    _controller._participantDebouncer.run(_sortParticipants);
  }

  Future<void> _sortParticipants() async {
    var userMediaTracks = <IsmCallParticipantTrack>[];

    final localTracks = <TrackPublication>[
      ...?_controller.room?.localParticipant?.videoTrackPublications,
      ...?_controller.room?.localParticipant?.audioTrackPublications,
    ];
    for (final participant in _controller.room!.remoteParticipants.values) {
      localTracks.addAll([
        ...participant.videoTrackPublications,
        ...participant.audioTrackPublications,
      ]);
    }

    var screenTracks = <IsmCallParticipantTrack>[];

    for (var track in localTracks) {
      final sid = track.participant.sid;
      if (userMediaTracks.any((e) => e.id == sid) && !track.isScreenShare) {
        var index = userMediaTracks.indexWhere((e) => e.id == sid);
        var mediaTrack = userMediaTracks[index];
        userMediaTracks[index] = mediaTrack.copyWith(
          tracks: track.track != null
              ? [...mediaTrack.tracks!, track.track!]
              : null,
        );
      } else {
        final screen = IsmCallParticipantTrack(
          id: sid,
          participant: track.participant,
          tracks: track.track != null ? [track.track!] : [],
          isScreenShare: track.isScreenShare,
        );
        if (track.isScreenShare) {
          screenTracks.add(screen);
        } else {
          userMediaTracks.add(screen);
        }
      }
    }
    userMediaTracks.addAll(screenTracks);

    if (_controller.participantTracks.length != userMediaTracks.length) {
      _controller.showFullVideo = userMediaTracks.length != 1;
      _controller.isRemoteVideoLarge = userMediaTracks.length >= 2;
    }

    _controller.participantTracks = [...userMediaTracks];

    _controller.update([IsmCallView.updateId]);
  }
}
