import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SplashController.new);
  }
}
