import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      HomeController(
        HomeViewModel(
          HomeRepository(
            Get.find(),
          ),
        ),
      ),
    );
  }
}
