import 'package:flutter/material.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallPropertiesData {
  const IsmCallPropertiesData({
    this.enablePip = false,
    this.pipView,
    this.enableVideoFitChange = false,
    this.videoFit,
    this.showOpponentLeft = true,
    this.showMissCall = true,
    this.showOpponentCallEnded = true,
    this.showAddNotesOnCallEnd = true,
    this.callControls,
    this.controlsPosition = IsmControlPosition.bottom,
    this.callControlFeatures = IsmCallControl.values,
  })  : assert(
          !enablePip || (enablePip && pipView != null),
          '`pipView` must be non-null, if `enablePip` is set to true',
        ),
        assert(
          (enableVideoFitChange && videoFit == null) || (!enableVideoFitChange),
          '`videoFit` must be null, if `enableVideoFitChange` is set to true',
        );

  final bool enablePip;
  final Widget? pipView;
  final bool enableVideoFitChange;
  final IsmCallVideoFit? videoFit;
  final bool showOpponentLeft;
  final bool showMissCall;
  final bool showOpponentCallEnded;
  final bool showAddNotesOnCallEnd;
  final List<IsmCallControlIcon>? callControls;
  final IsmControlPosition controlsPosition;
  final List<IsmCallControl> callControlFeatures;

  IsmCallPropertiesData lerp(covariant IsmCallPropertiesData? other, double t) {
    if (other is! IsmCallPropertiesData) {
      return this;
    }
    return IsmCallPropertiesData(
      enablePip: t < 0.5 ? enablePip : other.enablePip,
      pipView: t < 0.5 ? pipView : other.pipView,
      enableVideoFitChange:
          t < 0.5 ? enableVideoFitChange : other.enableVideoFitChange,
      videoFit: t < 0.5 ? videoFit : other.videoFit,
      showOpponentLeft: t < 0.5 ? showOpponentLeft : other.showOpponentLeft,
      showOpponentCallEnded:
          t < 0.5 ? showOpponentCallEnded : other.showOpponentCallEnded,
      showMissCall: t < 0.5 ? showMissCall : other.showMissCall,
      showAddNotesOnCallEnd:
          t < 0.5 ? showAddNotesOnCallEnd : other.showAddNotesOnCallEnd,
      callControls: t < 0.5 ? callControls : other.callControls,
      controlsPosition: t < 0.5 ? controlsPosition : other.controlsPosition,
      callControlFeatures:
          t < 0.5 ? callControlFeatures : other.callControlFeatures,
    );
  }

  IsmCallPropertiesData copyWith({
    bool? enablePip,
    Widget? pipView,
    bool? enableVideoFitChange,
    IsmCallVideoFit? videoFit,
    bool? showOpponentLeft,
    bool? showMissCallSnack,
    bool? showOpponentCallEnded,
    bool? showAddNotesOnCallEnd,
    List<IsmCallControlIcon>? callControls,
    IsmControlPosition? controlsPosition,
    final List<IsmCallControl>? callControlFeatures,
  }) =>
      IsmCallPropertiesData(
        enablePip: enablePip ?? this.enablePip,
        pipView: pipView ?? this.pipView,
        enableVideoFitChange: enableVideoFitChange ?? this.enableVideoFitChange,
        videoFit: videoFit ?? this.videoFit,
        showOpponentLeft: showOpponentLeft ?? this.showOpponentLeft,
        showMissCall: showMissCallSnack ?? showMissCall,
        showOpponentCallEnded:
            showOpponentCallEnded ?? this.showOpponentCallEnded,
        showAddNotesOnCallEnd:
            showAddNotesOnCallEnd ?? this.showAddNotesOnCallEnd,
        callControls: callControls ?? this.callControls,
        controlsPosition: controlsPosition ?? this.controlsPosition,
        callControlFeatures: callControlFeatures ?? this.callControlFeatures,
      );
}
