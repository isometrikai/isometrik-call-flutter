part of '../call_controller.dart';

mixin IsmCallVariableMixin {
  String? currentPushToken;

  String? prevPushToken;

  final RxBool _isFrontCamera = true.obs;
  bool get isFrontCamera => _isFrontCamera.value;

  set isFrontCamera(bool value) {
    if (isFrontCamera == value) {
      return;
    }
    _isFrontCamera.value = value;
  }

  CameraPosition get position =>
      isFrontCamera ? CameraPosition.front : CameraPosition.back;

  Timer? $callStreamTimer;

  Timer? _waitingTimer;

  Timer? _ringingTimer;

  final Rx<Duration> _callDuration = Duration.zero.obs;
  Duration get callDuration => _callDuration.value;
  set callDuration(Duration value) {
    if (value == callDuration) {
      return;
    }
    _callDuration.value = value;
  }

  Room? room;

  IsmCallRoomListener? listener;

  final _participantDebouncer = IsmCallDebouncer();
  final _disconnectDebouncer = IsmCallDebouncer(milliseconds: 500);
  final _micDebouncer = IsmCallDebouncer();

  final ismDelegate = const IsmCallDelegate();

  final timerStreamController = StreamController<Duration>.broadcast();

  var timerListeners = <IsmCallDuration>[];

  late String meetingId;

  final RxBool _isMicOn = true.obs;
  bool get isMicOn => _isMicOn.value;
  set isMicOn(bool value) => _isMicOn.value = value;

  final RxList<IsmCallParticipantTrack> _participantTracks =
      <IsmCallParticipantTrack>[].obs;
  List<IsmCallParticipantTrack> get participantTracks => _participantTracks;
  set participantTracks(List<IsmCallParticipantTrack> value) =>
      _participantTracks.value = value;

  final RxBool _isAudioOnly = true.obs;
  bool get isAudioOnly => _isAudioOnly.value;
  set isAudioOnly(bool value) {
    if (value == isAudioOnly) {
      return;
    }
    _isAudioOnly.value = value;
  }

  final RxBool _isVideoOn = true.obs;
  bool get isVideoOn => _isVideoOn.value;
  set isVideoOn(bool value) {
    if (value == isVideoOn) {
      return;
    }
    _isVideoOn.value = value;
  }

  final RxBool _isSpeakerOn = true.obs;
  bool get isSpeakerOn => _isSpeakerOn.value;
  set isSpeakerOn(bool value) {
    if (value == isSpeakerOn) {
      return;
    }
    _isSpeakerOn.value = value;
  }

  final RxDouble _videoPositionX = 0.0.obs;
  double get videoPositionX => _videoPositionX.value;
  set videoPositionX(double value) {
    if (value == videoPositionX) {
      return;
    }
    _videoPositionX.value = value;
  }

  final RxDouble _videoPositionY = 0.0.obs;
  double get videoPositionY => _videoPositionY.value;
  set videoPositionY(double value) {
    if (value == videoPositionY) {
      return;
    }
    _videoPositionY.value = value;
  }

  final RxBool _isRemoteVideoLarge = true.obs;
  bool get isRemoteVideoLarge => _isRemoteVideoLarge.value;
  set isRemoteVideoLarge(bool value) {
    if (value == isRemoteVideoLarge) {
      return;
    }
    _isRemoteVideoLarge.value = value;
  }

  final RxBool _showFullVideo = true.obs;
  bool get showFullVideo => _showFullVideo.value;
  set showFullVideo(bool value) {
    if (value == showFullVideo) {
      return;
    }
    _showFullVideo.value = value;
  }

  final RxBool _isRecording = false.obs;
  bool get isRecording => _isRecording.value;
  set isRecording(bool value) {
    if (value == isRecording) {
      return;
    }
    _isRecording.value = value;
  }

  String recordingText = '';


  final RxBool _isProcessingRecording = false.obs;
  bool get isProcessingRecording => _isProcessingRecording.value;
  set isProcessingRecording(bool value) {
    if (value == isProcessingRecording) {
      return;
    }
    _isProcessingRecording.value = value;
  }
  

  IsmCallUserInfoModel? userInfoModel;
}
