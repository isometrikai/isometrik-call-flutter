import 'package:flutter/material.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallPropertiesData {
  const IsmCallPropertiesData({
    this.enablePip = false,
    this.startPipOuter = false,
    this.pipBuilder,
    this.enableVideoFitChange = false,
    this.videoFit,
    this.showOpponentLeft = true,
    this.showMissCall = true,
    this.showOpponentCallEnded = true,
    this.callControlsBuilder,
    this.controlsPosition = IsmControlPosition.bottom,
    this.allowedCallActions = IsmCallControl.values,
    this.controlProperties,
  })  : assert(
          !enablePip || (enablePip && pipBuilder != null),
          '`pipView` must be non-null, if `enablePip` is set to true',
        ),
        assert(
          (enableVideoFitChange && videoFit == null) || (!enableVideoFitChange),
          '`videoFit` must be null, if `enableVideoFitChange` is set to true',
        );

  final bool enablePip;
  final bool startPipOuter;
  final Widget Function(BuildContext)? pipBuilder;
  final bool enableVideoFitChange;
  final IsmCallVideoFit? videoFit;
  final bool showOpponentLeft;
  final bool showMissCall;
  final bool showOpponentCallEnded;
  final List<IsmCallUserControlWidget> Function(BuildContext)?
      callControlsBuilder;
  final IsmControlPosition controlsPosition;
  final List<IsmCallControl> allowedCallActions;
  final IsmCallControlProperty? controlProperties;

  IsmCallPropertiesData lerp(covariant IsmCallPropertiesData? other, double t) {
    if (other is! IsmCallPropertiesData) {
      return this;
    }
    return IsmCallPropertiesData(
      enablePip: t < 0.5 ? enablePip : other.enablePip,
      startPipOuter: t < 0.5 ? startPipOuter : other.startPipOuter,
      pipBuilder: t < 0.5 ? pipBuilder : other.pipBuilder,
      enableVideoFitChange:
          t < 0.5 ? enableVideoFitChange : other.enableVideoFitChange,
      videoFit: t < 0.5 ? videoFit : other.videoFit,
      showOpponentLeft: t < 0.5 ? showOpponentLeft : other.showOpponentLeft,
      showOpponentCallEnded:
          t < 0.5 ? showOpponentCallEnded : other.showOpponentCallEnded,
      showMissCall: t < 0.5 ? showMissCall : other.showMissCall,
      callControlsBuilder:
          t < 0.5 ? callControlsBuilder : other.callControlsBuilder,
      controlsPosition: t < 0.5 ? controlsPosition : other.controlsPosition,
      allowedCallActions:
          t < 0.5 ? allowedCallActions : other.allowedCallActions,
      controlProperties: t < 0.5 ? controlProperties : other.controlProperties,
    );
  }

  IsmCallPropertiesData copyWith({
    bool? enablePip,
    bool? startPipOuter,
    Widget Function(BuildContext)? pipBuilder,
    bool? enableVideoFitChange,
    IsmCallVideoFit? videoFit,
    bool? showOpponentLeft,
    bool? showMissCallSnack,
    bool? showOpponentCallEnded,
    List<IsmCallUserControlWidget> Function(BuildContext)? callControlsBuilder,
    IsmControlPosition? controlsPosition,
    final List<IsmCallControl>? allowedCallActions,
    IsmCallControlProperty? controlProperties,
  }) =>
      IsmCallPropertiesData(
        enablePip: enablePip ?? this.enablePip,
        startPipOuter: startPipOuter ?? this.startPipOuter,
        pipBuilder: pipBuilder ?? this.pipBuilder,
        enableVideoFitChange: enableVideoFitChange ?? this.enableVideoFitChange,
        videoFit: videoFit ?? this.videoFit,
        showOpponentLeft: showOpponentLeft ?? this.showOpponentLeft,
        showMissCall: showMissCallSnack ?? showMissCall,
        showOpponentCallEnded:
            showOpponentCallEnded ?? this.showOpponentCallEnded,
        callControlsBuilder: callControlsBuilder ?? this.callControlsBuilder,
        controlsPosition: controlsPosition ?? this.controlsPosition,
        allowedCallActions: allowedCallActions ?? this.allowedCallActions,
        controlProperties: controlProperties ?? this.controlProperties,
      );
}
