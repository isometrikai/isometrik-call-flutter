import 'dart:math';

import 'package:custom_will_pop_scope/custom_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:pip_view/pip_view.dart';

class IsmCallView extends StatefulWidget {
  const IsmCallView({
    super.key,
    this.meetingId,
    this.audioOnly,
    this.userInfo,
  });

  static const String route = IsmCallRoutes.call;

  static const String updateId = 'isometrik-call-view';

  final String? meetingId;
  final bool? audioOnly;
  final IsmCallUserInfoModel? userInfo;

  @override
  State<IsmCallView> createState() => IsmCallViewState();
}

class IsmCallViewState extends State<IsmCallView> {
  late final AppLifecycleListener _listener;
  IsmCallController get _controller => Get.find();

  final collapsedKey = GlobalKey<IsmCallControlSheetState>();

  late BuildContext _buildContext;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onDetach: () {
        _controller.disconnectCall(meetingId: _controller.meetingId);
      },
      onHide: () {
        IsmCallLog.success('onHide');
      },
      onInactive: () {
        IsmCallLog.success('onInactive');
      },
      onPause: () {
        IsmCallLog.success('onPause');
      },
      onRestart: () {
        IsmCallLog.success('onRestart');
      },
      onResume: () {
        IsmCallLog.success('onResume');
      },
      onShow: () {
        IsmCallLog.success('onShow');
      },
    );

    if (!Get.isRegistered<IsmCallController>()) {
      IsmCallBinding().dependencies();
    }
    _controller.isAudioOnly =
        widget.audioOnly ?? Get.arguments['audioOnly'] as bool? ?? true;
    _controller.userInfoModel =
        widget.userInfo ?? IsmCallUserInfoModel.fromMap(Get.arguments);
    _controller.meetingId =
        widget.meetingId ?? Get.arguments['meetingId'] as String? ?? '';
    _controller.isRecording = false;
    _controller.isMicOn = true;
    _controller.showFullVideo = true;
    _controller.isFrontCamera = true;
    _controller.setUpListeners(_controller.meetingId);
    _controller.sortParticipants();
    _controller.videoPositionX = 20;
    _controller.videoPositionY = 20;
  }

  bool get sharingMyScreen => _controller.room?.sharingMyScreen ?? false;

  bool get _isScreenShared =>
      sharingMyScreen || _controller.participantTracks.length > 2;

  IsmCallParticipantTrack get _largeVideoTrack => _controller.isRemoteVideoLarge
      ? _controller.participantTracks.last
      : _controller.participantTracks.first;

  List<IsmCallParticipantTrack> get _smallVideoTrack =>
      _controller.isRemoteVideoLarge
          ? _controller.participantTracks
              .sublist(0, _controller.participantTracks.length - 1)
              .toList()
          : _controller.participantTracks.skip(1).toList();

  final Rx<Size?> _pipSize = Rx<Size?>(null);
  Size? get pipSize => _pipSize.value;
  set pipSize(Size? value) {
    if (value == pipSize) {
      return;
    }
    _pipSize.value = value;
  }

  void _calculateSize(BuildContext context) {
    const min = 120.0;
    late Size size;
    try {
      size = context.size ?? const Size(9, 16);
    } catch (e) {
      size = const Size(9, 16);
    } finally {
      var aspectRatio = size.width / size.height;
      var max = min * 1 / aspectRatio;
      if (_controller.showFullVideo) {
        pipSize = Size(max, min);
      } else {
        pipSize = Size(min, max);
      }
    }
    IsmCallLog.error('pip size $size');
    IsmCallLog.error('pip pipSize $pipSize');
  }

  void startPip() {
    if (!(_buildContext.properties?.enablePip ?? false)) {
      return;
    }

    _calculateSize(_buildContext);
    IsmCallLog.error(
        'pip Builder ${_buildContext.properties?.pipBuilder?.call(_buildContext)}');
    PIPView.of(_buildContext)?.presentBelow(
        _buildContext.properties?.pipBuilder?.call(_buildContext) ??
            const SizedBox());
  }

  void _startPip(BuildContext context) {
    if (!(context.properties?.enablePip ?? false)) {
      return;
    }

    _calculateSize(context);
    IsmCallLog.error(
        'pip Builder ${context.properties?.pipBuilder?.call(_buildContext)}');
    PIPView.of(context)?.presentBelow(
        context.properties?.pipBuilder?.call(context) ?? const SizedBox());
  }

  bool get isControlsBottom {
    final alignment = context.properties?.controlsPosition.alignment ??
        Alignment.bottomCenter;
    return alignment == Alignment.bottomCenter;
  }

  void _closeControlsSheet() {
    if (!isControlsBottom) return;
    collapsedKey.currentState?.toggleCollapse(false);
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Obx(
      () => PIPView(
        avoidKeyboard: true,
        initialCorner: PIPViewCorner.bottomRight,
        floatingHeight: pipSize?.height,
        floatingWidth: pipSize?.width,
        builder: (context, isFloating) => CustomWillPopScope(
          onWillPop: () async {
            // startPip(context);
            return false;
          },
          canReturn: false,
          child: GetX<IsmCallController>(
              builder: (controller) => IsmCallTapHandler(
                    onTap: _closeControlsSheet,
                    child: Scaffold(
                      backgroundColor: controller.participantTracks.isEmpty
                          ? context.theme.scaffoldBackgroundColor
                          : IsmCallColors.black,
                      extendBody: true,
                      extendBodyBehindAppBar: true,
                      appBar: isFloating
                          ? null
                          : AppBar(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              centerTitle: true,
                              automaticallyImplyLeading: false,
                              title: Text(
                                'End-to-end Encrypted',
                                style: context.textTheme.bodyMedium,
                              ),
                              leading: IconButton(
                                onPressed: () {
                                  _startPip(context);
                                },
                                icon: const Icon(Icons.arrow_back_ios_rounded),
                              ),
                              bottom: PreferredSize(
                                preferredSize: Size(
                                    double.maxFinite, IsmCallDimens.twenty),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.callDuration.inSeconds < 1
                                          ? Get.context?.translations
                                                  ?.joining ??
                                              IsmCallStrings.joining
                                          : controller.callDuration.formatTime,
                                    ),
                                    if (controller.isRecording) ...[
                                      IsmCallDimens.boxWidth8,
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              IsmCallDimens.fifty),
                                          color: context.theme.cardColor,
                                        ),
                                        child: Padding(
                                          padding: IsmCallDimens.edgeInsets12_4,
                                          child: Text(
                                            controller.recordingText,
                                            style: context.textTheme.labelSmall,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              actions: IsmCall.i.callActions,
                            ),
                      body: Stack(
                        children: [
                          controller.participantTracks.isEmpty
                              ? Center(
                                  child: IsmCallNoVideoWidget(
                                    name: controller.userInfoModel?.userName ??
                                        '',
                                    imageUrl:
                                        controller.userInfoModel?.imageUrl ??
                                            '',
                                    isLargeVideo: true,
                                  ),
                                )
                              : Positioned.fill(
                                  child: sharingMyScreen
                                      ? IsmCallScreenShared(
                                          onStop: () => controller
                                              .toggleScreenShare(false),
                                        )
                                      : InteractiveViewer(
                                          maxScale: _isScreenShared ? 3 : 1,
                                          panEnabled: _isScreenShared,
                                          scaleEnabled: _isScreenShared,
                                          child: IsmCallTapHandler(
                                            onDoubleTap: (context.properties
                                                        ?.enableVideoFitChange ??
                                                    false)
                                                ? () {
                                                    if (controller
                                                        .isRemoteVideoLarge) {
                                                      _controller
                                                              .showFullVideo =
                                                          !_controller
                                                              .showFullVideo;
                                                    }
                                                  }
                                                : null,
                                            child: IsmCallParticipantView(
                                              _largeVideoTrack,
                                              imageUrl:
                                                  controller.isRemoteVideoLarge
                                                      ? null
                                                      : IsmCall
                                                          .i
                                                          .config
                                                          ?.userConfig
                                                          .userProfile,
                                              videoFit: context
                                                  .properties?.videoFit?.rtcFit,
                                              showFullVideo:
                                                  _controller.showFullVideo ||
                                                      _isScreenShared,
                                              backgroundColor: context.callTheme
                                                      ?.videoBackgroundColor ??
                                                  IsmCallColors.black,
                                              videoOffBackgroundColor: context
                                                      .callTheme
                                                      ?.videoOffBackgroundColor ??
                                                  IsmCallColors.background,
                                              isLargeVideo: true,
                                            ),
                                          ),
                                        ),
                                ),
                          if (!isFloating &&
                              context.properties?.allowedCallActions
                                      .isNotEmpty ==
                                  true)
                            Builder(
                              builder: (context) {
                                final alignment = context.properties
                                        ?.controlsPosition.alignment ??
                                    Alignment.bottomCenter;
                                return Align(
                                  alignment: alignment,
                                  child: IsmCallControlSheet(
                                    key: collapsedKey,
                                    isControlsBottom: isControlsBottom,
                                    controls: [
                                      if (context.properties
                                              ?.callControlsBuilder !=
                                          null) ...[
                                        ...context
                                                .properties?.callControlsBuilder
                                                ?.call(context) ??
                                            []
                                      ],
                                      ...ismCallControlFeatures(),
                                    ],
                                    collapseIndexOrder: const [6, 3, 1, 2, 5],
                                  ),
                                );
                              },
                            ),
                          if (!isFloating &&
                              controller.participantTracks.length > 1)
                            Positioned(
                              left: controller.videoPositionX,
                              top: controller.videoPositionY,
                              child: GestureDetector(
                                onPanUpdate: controller.onVideoPan,
                                onTap: _isScreenShared
                                    ? null
                                    : controller.toggleLargeVideo,
                                child: SafeArea(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        IsmCallDimens.eight),
                                    child: SizedBox(
                                      height: min(Get.height * 0.25,
                                          IsmCallDimens.oneHundredSeventy),
                                      child: ListView.builder(
                                        itemCount: _smallVideoTrack.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (_, index) {
                                          final participant =
                                              _smallVideoTrack[index];
                                          return AspectRatio(
                                            aspectRatio: 9 / 16,
                                            child: IsmCallParticipantView(
                                              participant,
                                              isLargeVideo: false,
                                              imageUrl: participant.participant
                                                      is LocalParticipant
                                                  ? IsmCall.i.config?.userConfig
                                                      .userProfile
                                                  : null,
                                              videoOffBackgroundColor: context
                                                      .callTheme
                                                      ?.videoOffCardColor ??
                                                  IsmCallColors.card,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  List<Widget> ismCallControlFeatures() {
    final controller = Get.find<IsmCallController>();
    final features = <Widget>[];
    final allowedCallActions = context.properties?.allowedCallActions ?? [];
    final controlProperties = context.properties?.controlProperties;
    for (final feature in allowedCallActions) {
      if (feature == IsmCallControl.record) {
        features.add(
          controlProperties?.recordingControl ??
              RecordControl(
                onChange: controller.toggleRecording,
                isActive: controller.isRecording,
              ),
        );
      }
      if (feature == IsmCallControl.video) {
        features.add(
          controlProperties?.videoControl ??
              VideoControl(
                onChange: controller.toggleVideo,
                isActive: controller.isVideoOn,
              ),
        );
      }
      if (feature == IsmCallControl.mic) {
        features.add(
          controlProperties?.micControl ??
              MicControl(
                onChange: (value) {
                  controller.toggleMic(value: value);
                },
                isActive: controller.isMicOn,
              ),
        );
      }
      if (feature == IsmCallControl.speaker) {
        features.add(
          controlProperties?.speakerControl ??
              SpeakerControl(
                onChange: controller.toggleSpeaker,
                isActive: controller.isSpeakerOn,
              ),
        );
      }
      if (feature == IsmCallControl.screenShare) {
        features.add(
          controlProperties?.screenShareControl ??
              ScreenShareControl(
                onChange: controller.toggleScreenShare,
                isActive: controller.isScreenSharing,
              ),
        );
      }
      if (feature == IsmCallControl.filpCamera) {
        features.add(
          controlProperties?.cameraControl ??
              FilpCameraControl(
                onChange: controller.isVideoOn
                    ? (_) => _controller.flipCamera()
                    : null,
                isActive: controller.isVideoOn,
              ),
        );
      }
      if (feature == IsmCallControl.callEnd) {
        features.add(
          controlProperties?.callEndControl ??
              EndCallControl(
                onChange: (_) {
                  controller.disconnectCall(
                    meetingId: _controller.meetingId,
                  );
                },
              ),
        );
      }
    }
    return features;
  }
}
