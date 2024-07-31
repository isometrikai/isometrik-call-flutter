import 'package:flutter/material.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallPropertiesData {
  const IsmCallPropertiesData({
    this.enablePip = false,
    this.pipView,
    this.enableVideoFitChange = false,
    this.videoFit,
    this.showOpponentLeft = true,
    this.showAddNotesOnCallEnd = true,
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
  final bool showAddNotesOnCallEnd;

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
      showAddNotesOnCallEnd:
          t < 0.5 ? showAddNotesOnCallEnd : other.showAddNotesOnCallEnd,
    );
  }

  IsmCallPropertiesData copyWith({
    bool? enablePip,
    Widget? pipView,
    bool? enableVideoFitChange,
    IsmCallVideoFit? videoFit,
    bool? showOpponentLeft,
    bool? showAddNotesOnCallEnd,
  }) =>
      IsmCallPropertiesData(
        enablePip: enablePip ?? this.enablePip,
        pipView: pipView ?? this.pipView,
        enableVideoFitChange: enableVideoFitChange ?? this.enableVideoFitChange,
        videoFit: videoFit ?? this.videoFit,
        showOpponentLeft: showOpponentLeft ?? this.showOpponentLeft,
        showAddNotesOnCallEnd:
            showAddNotesOnCallEnd ?? this.showAddNotesOnCallEnd,
      );
}
