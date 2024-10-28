import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

part 'routes.dart';

class IsmCallPages {
  static const transitionDuration = Duration(milliseconds: 300);

  static const String initialRoute = '';

  static final pages = [
    GetPage<IsmCallView>(
      name: IsmCallView.route,
      page: () => IsmCallView(key: IsmCallDelegate.callKey),
      bindings: [
        IsmCallBinding(),
        IsmCallMqttBinding(),
      ],
    ),
  ];
}
