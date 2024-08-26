import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      IsmCallController(
        IsmCallViewModel(
          IsmCallRepository(
            IsmCallApiWrapper(
              Client(),
            ),
          ),
        ),
      ),
    );
  }
}
