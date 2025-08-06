import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallMqttBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(IsmCallMqttController(), permanent: true);
  }
}
