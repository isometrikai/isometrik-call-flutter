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
    this.isAccepted,
    this.userInfo,
  });

  static const String route = IsmCallRoutes.call;

  static const String updateId = 'isometrik-call-view';

  final String? meetingId;
  final bool? audioOnly;
  final bool? isAccepted;
  final IsmCallUserInfoModel? userInfo;

  @override
  State<IsmCallView> createState() => IsmCallViewState();
}

class IsmCallViewState extends State<IsmCallView> {
  late final AppLifecycleListener _listener;
  IsmCallController get _controller => Get.find();

  final collapsedKey = GlobalKey<IsmCallControlSheetState>();

  late BuildContext _buildContext;

  late bool isAccepted;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onDetach: () {
        IsmCallLog.success('onDetach');
        _controller.disconnectCall(meetingId: _controller.meetingId);
      },
    );

    if (!Get.isRegistered<IsmCallController>()) {
      IsmCallBinding().dependencies();
    }
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    isAccepted = widget.isAccepted ?? arguments['isAccepted'] as bool? ?? false;
    _controller.isAudioOnly =
        widget.audioOnly ?? arguments['audioOnly'] as bool? ?? true;
    _controller.userInfoModel =
        widget.userInfo ?? IsmCallUserInfoModel.fromMap(arguments);
    _controller.meetingId =
        widget.meetingId ?? arguments['meetingId'] as String? ?? '';
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
  }

  void startPip() {
    if (!(_buildContext.properties?.enablePip ?? false)) {
      return;
    }
    _calculateSize(_buildContext);
    PIPView.of(_buildContext)?.presentBelow(
      _buildContext.properties?.pipBuilder?.call(_buildContext) ??
          const SizedBox(),
    );
  }

  void closePip(BuildContext? context) {
    if (context != null) {
      _buildContext = context;
    }

    if (!(_buildContext.properties?.enablePip ?? false)) {
      return;
    }
    PIPView.of(_buildContext)?.stopFloating();
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
  Widget build(BuildContext context) => Obx(
        () => PIPView(
          avoidKeyboard: true,
          initialCorner: PIPViewCorner.bottomRight,
          floatingHeight: pipSize?.height,
          floatingWidth: pipSize?.width,
          builder: (context, isFloating) {
            _buildContext = context;
            final isMobile = MediaQuery.of(context).size.width < 800;
            return CustomWillPopScope(
              onWillPop: () async {
                if (_buildContext.properties?.startPipOuter == false) {
                  startPip();
                }
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
                              'End-to-end encrypted',
                              style: context.textTheme.bodyMedium,
                            ),
                            leading: isMobile &&
                                    _buildContext.properties?.startPipOuter ==
                                        false
                                ? IconButton(
                                    onPressed: startPip,
                                    icon: const Icon(
                                      Icons.arrow_back_ios_rounded,
                                    ),
                                  )
                                : null,
                            bottom: PreferredSize(
                              preferredSize: Size(
                                double.maxFinite,
                                IsmCallDimens.twenty,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.participantTracks.isEmpty ||
                                            controller
                                                    .participantTracks.length ==
                                                1
                                        ? isAccepted
                                            ? Get.context?.translations
                                                    ?.joining ??
                                                IsmCallStrings.joining
                                            : Get.context?.translations
                                                    ?.ringing ??
                                                IsmCallStrings.ringing
                                        : controller.callDuration.formatTime,
                                  ),
                                  if (controller.isRecording) ...[
                                    IsmCallDimens.boxWidth8,
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          IsmCallDimens.fifty,
                                        ),
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
                                  name:
                                      controller.userInfoModel?.userName ?? '',
                                  imageUrl:
                                      controller.userInfoModel?.imageUrl ?? '',
                                  isLargeVideo: true,
                                ),
                              )
                            : Positioned.fill(
                                child: sharingMyScreen
                                    ? IsmCallScreenShared(
                                        onStop: () =>
                                            controller.toggleScreenShare(false),
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
                                                    _controller.showFullVideo =
                                                        !_controller
                                                            .showFullVideo;
                                                  }
                                                }
                                              : null,
                                          child: IsmCallParticipantView(
                                            _largeVideoTrack,
                                            name: controller.isRemoteVideoLarge
                                                ? controller.userInfoModel
                                                        ?.userName ??
                                                    ''
                                                : IsmCall.i.config?.userConfig
                                                        .fullName ??
                                                    '',
                                            imageUrl:
                                                controller.isRemoteVideoLarge
                                                    ? controller.userInfoModel
                                                            ?.imageUrl ??
                                                        ''
                                                    : IsmCall
                                                            .i
                                                            .config
                                                            ?.userConfig
                                                            .userProfile ??
                                                        '',
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
                            context.properties?.allowedCallActions.isNotEmpty ==
                                true) ...[
                          Builder(
                            builder: (context) {
                              final alignment = context
                                      .properties?.controlsPosition.alignment ??
                                  Alignment.bottomCenter;

                              // First build the controls list
                              final controls = <Widget>[
                                if (context.properties?.callControlsBuilder !=
                                    null) ...[
                                  ...context.properties?.callControlsBuilder
                                          ?.call(context) ??
                                      [],
                                ],
                                ...ismCallControlFeatures(),
                              ];

                              // Then generate dynamic collapseIndexOrder based on controls length
                              final collapseIndexOrder = _generateCollapseOrder(
                                controls.length,
                                isMobile,
                              );
                              return Align(
                                alignment: alignment,
                                child: IsmCallControlSheet(
                                  isMobile: isMobile,
                                  key: collapsedKey,
                                  isControlsBottom: isControlsBottom,
                                  controls: controls,
                                  collapseIndexOrder: collapseIndexOrder,
                                ),
                              );
                            },
                          ),
                        ],
                        if (!isFloating &&
                            controller.participantTracks.length > 1) ...[
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
                                    IsmCallDimens.eight,
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      final size = MediaQuery.of(context).size;
                                      final isWeb = size.width > 600;
                                      final boxWidth = isWeb
                                          ? size.width * 0.20
                                          : size.width * 0.25;
                                      final boxHeight = boxWidth * (9 / 16);
                                      return SizedBox(
                                        height: boxHeight,
                                        width: boxWidth,
                                        child: ListView.builder(
                                          itemCount: _smallVideoTrack.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (_, index) =>
                                              AspectRatio(
                                            aspectRatio:
                                                isMobile ? 9 / 16 : 3 / 4,
                                            child: IsmCallParticipantView(
                                              _smallVideoTrack[index],
                                              isLargeVideo: false,
                                              imageUrl: _smallVideoTrack[index]
                                                          .participant
                                                      is LocalParticipant
                                                  ? IsmCall.i.config?.userConfig
                                                          .userProfile ??
                                                      ''
                                                  : controller.userInfoModel
                                                          ?.imageUrl ??
                                                      '',
                                              name: _smallVideoTrack[index]
                                                          .participant
                                                      is LocalParticipant
                                                  ? IsmCall.i.config?.userConfig
                                                          .fullName ??
                                                      ''
                                                  : controller.userInfoModel
                                                          ?.userName ??
                                                      '',
                                              videoOffBackgroundColor: context
                                                      .callTheme
                                                      ?.videoOffCardColor ??
                                                  IsmCallColors.card,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

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
                onChange: (_) {}, //controller.toggleRecording,
                isActive: controller.isRecording,
              ),
        );
      }
      if (feature == IsmCallControl.video) {
        features.add(
          controlProperties?.videoControl ??
              VideoControl(
                onChange: (value) {}, //controller.toggleVideo
                isActive: controller.isVideoOn,
              ),
        );
      }
      if (feature == IsmCallControl.mic) {
        features.add(
          controlProperties?.micControl ??
              MicControl(
                onChange: (value) {
                  // controller.toggleMic(value: value);
                },
                isActive: controller.isMicOn,
              ),
        );
      }
      if (feature == IsmCallControl.speaker) {
        features.add(
          controlProperties?.speakerControl ??
              SpeakerControl(
                onChange: (_) {}, // controller.toggleSpeaker,
                isActive: controller.isSpeakerOn,
              ),
        );
      }
      if (feature == IsmCallControl.screenShare) {
        features.add(
          controlProperties?.screenShareControl ??
              ScreenShareControl(
                onChange: (_) {}, // controller.toggleScreenShare,
                isActive: controller.isScreenSharing,
              ),
        );
      }
      if (feature == IsmCallControl.filpCamera) {
        features.add(
          controlProperties?.cameraControl ??
              FilpCameraControl(
                onChange: (_) {}, //_controller.flipCamera()
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

  List<int> _generateCollapseOrder(int controlsCount, bool isMobile) {
    // Base order for known controls
    final baseOrder = isMobile ? [6, 3, 1, 2, 5] : [6, 3, 1, 2, 5, 4, 0];

    // Filter out indices that don't exist in current controls
    final validOrder =
        baseOrder.where((index) => index < controlsCount).toList();

    // Add any remaining indices that weren't in base order
    for (var i = 0; i < controlsCount; i++) {
      if (!validOrder.contains(i)) validOrder.add(i);
    }

    return validOrder;
  }
}
