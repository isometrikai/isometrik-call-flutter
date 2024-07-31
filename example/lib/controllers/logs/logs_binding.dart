import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class LogsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      LogsController(
        LogsViewModel(
          LogsRepository(
            Get.find(),
          ),
        ),
      ),
    );
  }
}
