import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

enum IsmCallRequestType {
  get,
  post,
  put,
  patch,
  delete,
  upload;
}

enum IsmCallButtonType {
  primary,
  secondary,
  outlined,
  icon;
}

enum IsmCallImageType {
  asset,
  svg,
  file,
  network;
}

enum IsmCallControl {
  record(
    IsmCallAssets.record,
    IsmCallAssets.record,
  ),
  video(
    IsmCallAssets.video,
    IsmCallAssets.videoOff,
  ),
  mic(
    IsmCallAssets.mic,
    IsmCallAssets.micOff,
  ),
  chat(
    IsmCallAssets.message,
    IsmCallAssets.message,
  ),
  speaker(
    IsmCallAssets.speaker,
    IsmCallAssets.speakerOff,
  ),
  screenShare(
    IsmCallAssets.stopScreenShare,
    IsmCallAssets.screenShare,
  ),
  filpCamera(
    IsmCallAssets.flipCamera,
    IsmCallAssets.flipCamera,
  );

  const IsmCallControl(
    this.icon,
    this.iconOff,
  );
  final String icon;
  final String iconOff;
}

enum IsmCallType {
  audio(0),
  video(1);

  factory IsmCallType.fromName(String data) =>
      {
        IsmCallType.audio.name: IsmCallType.audio,
        IsmCallType.video.name: IsmCallType.video,
      }[data] ??
      IsmCallType.audio;

  factory IsmCallType.fromValue(int data) =>
      {
        IsmCallType.audio.value: IsmCallType.audio,
        IsmCallType.video.value: IsmCallType.video,
      }[data] ??
      IsmCallType.audio;

  const IsmCallType(this.value);
  final int value;

  bool get isVideo => this == video;

  IsmCallTrackType get trackType => switch (this) {
        audio => IsmCallTrackType.audio,
        video => IsmCallTrackType.both,
      };
}

enum IsmCallTrackType {
  audio,
  video,
  both;

  bool get hasVideo => [video, both].contains(this);

  bool get hasAudio => [audio, both].contains(this);
}

enum IsmCallVideoFit {
  contain,
  cover;

  RTCVideoViewObjectFit get rtcFit => switch (this) {
        IsmCallVideoFit.contain =>
          RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
        IsmCallVideoFit.cover =>
          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      };
}

enum IsmCallStatus {
  callMissed,
  callEnded,
  acceptSuccess,
  acceptError,
  rejectSuccess,
  rejectError,
}

enum IsmControlPosition {
  left,
  right,
  bottom;

  AlignmentGeometry get alignment => switch (this) {
        IsmControlPosition.left => Alignment.bottomLeft,
        IsmControlPosition.right => Alignment.bottomRight,
        IsmControlPosition.bottom => Alignment.bottomCenter,
      };
}
