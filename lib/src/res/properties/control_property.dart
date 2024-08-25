import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallControlProperty {
  final MicControl? micControl;
  final VideoControl? videoControl;
  final FilpCameraControl? cameraControl;
  final SpeakerControl? speakerControl;
  final EndCallControl? callEndControl;
  final RecordControl? recordingControl;
  final ScreenShareControl? screenShareControl;

  const IsmCallControlProperty({
    this.micControl,
    this.videoControl,
    this.cameraControl,
    this.speakerControl,
    this.callEndControl,
    this.recordingControl,
    this.screenShareControl,
  });

  IsmCallControlProperty copyWith({
    MicControl? micControl,
    VideoControl? videoControl,
    FilpCameraControl? cameraControl,
    SpeakerControl? speakerControl,
    EndCallControl? callEndControl,
    RecordControl? recordingControl,
    ScreenShareControl? screenShareControl,
  }) {
    return IsmCallControlProperty(
      micControl: micControl ?? this.micControl,
      videoControl: videoControl ?? videoControl,
      cameraControl: cameraControl ?? cameraControl,
      speakerControl: speakerControl ?? speakerControl,
      callEndControl: callEndControl ?? callEndControl,
      recordingControl: recordingControl ?? recordingControl,
      screenShareControl: screenShareControl ?? screenShareControl,
    );
  }
}
