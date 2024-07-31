import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class CallChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      CallChatController(),
    );
  }
}
