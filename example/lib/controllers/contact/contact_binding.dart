import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class ContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      ContactController(
        ContactViewModel(
          ContactRepository(
            Get.find(),
          ),
        ),
      ),
    );
  }
}
