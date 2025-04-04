import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallRouteManagement {
  const IsmCallRouteManagement._();

  static Future<void> goToCall({
    required IsmCallUserInfoModel userInfo,
    required String meetingId,
    required bool audioOnly,
    required bool isAccepted,
  }) async {
    await Get.toNamed(
      IsmCallRoutes.call,
      arguments: {
        'audioOnly': audioOnly,
        'meetingId': meetingId,
        'isAccepted': isAccepted,
        ...userInfo.toMap(),
      },
    );
  }
}
