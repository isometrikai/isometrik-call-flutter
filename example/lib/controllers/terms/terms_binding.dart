import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class TermsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(TermsController.new);
  }
}
