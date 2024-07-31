import 'package:call_qwik_example/data/data.dart';
import 'package:call_qwik_example/res/res.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  DBWrapper get _dbWrapper => Get.find<DBWrapper>();

  @override
  void onReady() {
    super.onReady();
    startOnInit();
  }

  void startOnInit() async {
    await Future.delayed(const Duration(milliseconds: 500));
    var isLoggedIn = _dbWrapper.getBoolValue(LocalKeys.isLoggedIn);
    late Function route;
    if (isLoggedIn) {
      route = RouteManagement.goToHome;
    } else {
      var isFirstLogin = _dbWrapper.getBoolValue(
        LocalKeys.isFirstLogin,
        defaultValue: true,
      );
      if (isFirstLogin) {
        route = RouteManagement.goToTermsCondition;
      } else {
        route = RouteManagement.goToEmailLogin;
      }
    }
    route();
  }
}
