import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class TermsController extends GetxController {
  DBWrapper get dbWrapper => Get.find<DBWrapper>();

  void goToLogin() {
    dbWrapper.saveValue(
      LocalKeys.isFirstLogin,
      false,
    );
    RouteManagement.goToEmailLogin();
  }
}
