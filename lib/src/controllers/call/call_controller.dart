import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:livekit_client/livekit_client.dart';

part 'mixins/api_mixin.dart';
part 'mixins/join_mixin.dart';
part 'mixins/ongoing_mixin.dart';
part 'mixins/variable_mixin.dart';

class IsmCallController extends GetxController
    with
        IsmCallApiMixin,
        IsmCallJoinMixin,
        IsmCallVariableMixin,
        IsmCallOngoingMixin {
  IsmCallController(this._viewModel);

  final IsmCallViewModel _viewModel;

  double get _pipHeight =>
      min(Get.height * 0.25, IsmCallDimens.oneHundredSeventy);

  double get _pipWidth => _pipHeight * 9 / 16 * (participantTracks.length - 1);

  void onVideoPan(DragUpdateDetails details) {
    videoPositionX += details.delta.dx;
    videoPositionY += details.delta.dy;

    videoPositionX = max(0, videoPositionX);
    videoPositionY = max(0, videoPositionY);

    videoPositionX = min(videoPositionX, Get.width - _pipWidth);
    videoPositionY = min(videoPositionY, Get.height - _pipHeight);
  }

  Future<bool> updatePushToken(String token, [String? prevToken]) async {
    prevPushToken = prevToken ?? currentPushToken;
    currentPushToken = token;
    var res = await Future.wait([
      if (currentPushToken != null && currentPushToken?.isNotEmpty == true) ...[
        IsmCallDBWrapper.i.updatePushToken(currentPushToken ?? ''),
        addPushToken(),
      ],
      if (prevPushToken != null && prevPushToken?.isNotEmpty == true) ...[
        removePushToken(),
      ],
    ]);
    return res.every((e) => e);
  }
}
