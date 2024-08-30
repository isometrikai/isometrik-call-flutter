import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:livekit_client/livekit_client.dart';

class IsmCallParticipantView extends StatefulWidget {
  const IsmCallParticipantView(
    this.participant, {
    super.key,
    required this.imageUrl,
    required this.name,
    this.videoFit,
    this.showFullVideo = false,
    this.backgroundColor,
    this.videoOffBackgroundColor,
    this.isLargeVideo = false,
  });

  final IsmCallParticipantTrack participant;
  final RTCVideoViewObjectFit? videoFit;
  final String imageUrl;
  final String name;

  final bool showFullVideo;
  final Color? backgroundColor;
  final Color? videoOffBackgroundColor;
  final bool isLargeVideo;

  @override
  State<StatefulWidget> createState() => _IsmCallParticipantViewState();
}

class _IsmCallParticipantViewState extends State<IsmCallParticipantView> {
  VideoTrack? get activeVideoTrack => widget.participant.videoTrack;

  @override
  void initState() {
    super.initState();
    widget.participant.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
  }

  @override
  void dispose() {
    widget.participant.participant.removeListener(_onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant IsmCallParticipantView oldWidget) {
    oldWidget.participant.participant.removeListener(_onParticipantChanged);
    widget.participant.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
    super.didUpdateWidget(oldWidget);
  }

  void _onParticipantChanged() => setState(() {});

  bool get isVideoOn => activeVideoTrack != null && !activeVideoTrack!.muted;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: (isVideoOn
                  ? widget.backgroundColor
                  : widget.videoOffBackgroundColor) ??
              context.theme.scaffoldBackgroundColor,
        ),
        child: isVideoOn
            ? VideoTrackRenderer(
                activeVideoTrack!,
                fit: widget.videoFit ??
                    (widget.showFullVideo
                        ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
                        : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
              )
            : IsmCallNoVideoWidget(
                name: widget.name, // widget.participant.participant.name,
                imageUrl: widget.imageUrl,
                isLargeVideo: widget.isLargeVideo,
              ),
      );
}
