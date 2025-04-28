import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

abstract class IsmCallUserControl extends StatefulWidget {
  const IsmCallUserControl({
    super.key,
    required this.activeIcon,
    this.inactiveIcon,
    this.onToggle,
    this.initiallyActive = false,
    this.shouldUpdate = true,
  });

  final Widget activeIcon;
  final Widget? inactiveIcon;
  final void Function(bool)? onToggle;
  final bool initiallyActive;
  final bool shouldUpdate;

  @override
  State<IsmCallUserControl> createState() => _IsmCallUserControlState();
}

class _IsmCallUserControlState extends State<IsmCallUserControl> {
  late bool isActive;

  @override
  void initState() {
    isActive = widget.initiallyActive;
    super.initState();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onToggle != null
            ? () {
                if (widget.shouldUpdate) {
                  isActive = !isActive;
                  update();
                }
                widget.onToggle?.call(isActive);
              }
            : null,
        child: isActive
            ? widget.activeIcon
            : (widget.inactiveIcon ?? widget.activeIcon),
      );
}

class RecordControl extends IsmCallUserControl {
  RecordControl({
    super.key,
    this.activeChild,
    this.inactiveChild,
    this.onChange,
    this.isActive = false,
  }) : super(
          activeIcon: activeChild ??
              const IsmCallControlIcon(
                IsmCallAssets.record,
              ),
          inactiveIcon: inactiveChild ??
              const IsmCallControlIcon(
                IsmCallAssets.record,
                isActive: false,
              ),
          onToggle: (value) {
            onChange?.call(value);
            Get.find<IsmCallController>().toggleRecording(value);
          },
          initiallyActive: isActive,
        );
  final Widget? activeChild;
  final Widget? inactiveChild;
  final void Function(bool)? onChange;
  final bool isActive;
}

class VideoControl extends IsmCallUserControl {
  VideoControl({
    super.key,
    this.activeChild,
    this.inactiveChild,
    this.onChange,
    this.isActive = false,
  }) : super(
          activeIcon: activeChild ??
              const IsmCallControlIcon(
                IsmCallAssets.video,
              ),
          inactiveIcon: inactiveChild ??
              const IsmCallControlIcon(
                IsmCallAssets.videoOff,
                isActive: false,
              ),
          onToggle: (value) {
            onChange?.call(value);
            Get.find<IsmCallController>().toggleVideo(value);
          },
          initiallyActive: isActive,
        );
  final Widget? activeChild;
  final Widget? inactiveChild;
  final void Function(bool)? onChange;
  final bool isActive;
}

class MicControl extends IsmCallUserControl {
  MicControl({
    super.key,
    this.activeChild,
    this.inactiveChild,
    this.onChange,
    this.isActive = false,
  }) : super(
          activeIcon: activeChild ??
              const IsmCallControlIcon(
                IsmCallAssets.mic,
              ),
          inactiveIcon: inactiveChild ??
              const IsmCallControlIcon(
                IsmCallAssets.micOff,
                isActive: false,
              ),
          onToggle: (value) {
            onChange?.call(value);
            Get.find<IsmCallController>().toggleMic(value: value);
          },
          initiallyActive: isActive,
        );
  final Widget? activeChild;
  final Widget? inactiveChild;
  final void Function(bool)? onChange;
  final bool isActive;
}

class ScreenShareControl extends IsmCallUserControl {
  ScreenShareControl({
    super.key,
    this.activeChild,
    this.inactiveChild,
    this.onChange,
    this.isActive = false,
  }) : super(
          activeIcon: activeChild ??
              const IsmCallControlIcon(
                IsmCallAssets.stopScreenShare,
              ),
          inactiveIcon: inactiveChild ??
              const IsmCallControlIcon(
                IsmCallAssets.screenShare,
                isActive: false,
              ),
          onToggle: (value) {
            onChange?.call(value);
            Get.find<IsmCallController>().toggleScreenShare(value);
          },
          initiallyActive: isActive,
        );
  final Widget? activeChild;
  final Widget? inactiveChild;
  final void Function(bool)? onChange;
  final bool isActive;
}

class FilpCameraControl extends IsmCallUserControl {
  FilpCameraControl({
    super.key,
    this.activeChild,
    this.inactiveChild,
    this.onChange,
    this.isActive = false,
  }) : super(
          activeIcon: activeChild ??
              const IsmCallControlIcon(
                IsmCallAssets.flipCamera,
              ),
          inactiveIcon: inactiveChild ??
              const IsmCallControlIcon(
                IsmCallAssets.flipCamera,
                isActive: false,
              ),
          onToggle: (value) {
            onChange?.call(value);
            final controller = Get.find<IsmCallController>();
            if (controller.isVideoOn) {
              controller.flipCamera();
            } else {
              IsmCallUtility.showToast(
                'Please turn on you camera',
                color: IsmCallColors.green,
              );
            }
          },
          shouldUpdate: Get.find<IsmCallController>().isVideoOn,
          initiallyActive: isActive,
        );
  final Widget? activeChild;
  final Widget? inactiveChild;
  final void Function(bool)? onChange;
  final bool isActive;
}

class SpeakerControl extends IsmCallUserControl {
  SpeakerControl({
    super.key,
    this.activeChild,
    this.inactiveChild,
    this.onChange,
    this.isActive = false,
  }) : super(
          activeIcon: activeChild ??
              const IsmCallControlIcon(
                IsmCallAssets.speaker,
              ),
          inactiveIcon: inactiveChild ??
              const IsmCallControlIcon(
                IsmCallAssets.speakerOff,
                isActive: false,
              ),
          onToggle: (value) {
            onChange?.call(value);
            Get.find<IsmCallController>().toggleSpeaker(value);
          },
          initiallyActive: isActive,
        );
  final Widget? activeChild;
  final Widget? inactiveChild;
  final void Function(bool)? onChange;
  final bool isActive;
}

class EndCallControl extends IsmCallUserControl {
  EndCallControl({
    super.key,
    this.activeChild,
    this.inactiveChild,
    this.onChange,
  }) : super(
          activeIcon: activeChild ?? const IsmCallEndCall(),
          inactiveIcon: inactiveChild,
          onToggle: (value) {
            onChange?.call(value);
            final controller = Get.find<IsmCallController>();
            controller.disconnectCall(
              meetingId: controller.meetingId,
            );
          },
        );

  final Widget? activeChild;
  final Widget? inactiveChild;
  final void Function(bool)? onChange;
}

class IsmCallUserControlWidget extends IsmCallUserControl {
  IsmCallUserControlWidget({
    super.key,
    this.activeChild,
    this.inactiveChild,
    this.onChange,
  }) : super(
          activeIcon: activeChild ?? const Icon(Icons.mic),
          inactiveIcon: inactiveChild ?? const Icon(Icons.mic_off),
          onToggle: (value) {
            onChange?.call(value);
          },
        );

  final Widget? activeChild;
  final Widget? inactiveChild;
  final void Function(bool)? onChange;
}
