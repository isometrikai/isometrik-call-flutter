import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      AuthController(
        AuthViewModel(
          AuthRepository(
            Get.find(),
          ),
        ),
      ),
    );
  }
}
