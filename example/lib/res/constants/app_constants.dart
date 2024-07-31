import 'package:call_qwik_example/main.dart';

/// `AppConstants` is a singleton class with all static variables.
///
/// It contains all constants that are to be used within the project
class AppConstants {
  const AppConstants._();

  static const String appName = 'Appscrip CallQwik Example';

  static const String packageName = 'isometrik_call_flutter';

  static const String clientName = '66220ba203a522df24b270bc';
  static const String projectId = '370b5b2b-8cd3-454e-bd5b-d94352118c67';

  static const String mqttHost = 'connections.isometrik.io';
  static const int mqttPort = 2052;

  static const Duration animationDuration = Duration(milliseconds: 300);

  static const Duration timeOutDuration = Duration(seconds: 120);

  static double imageHeight = Dimens.twentyFive;

  static const int keepAlivePeriod = 60;

  static const int counterTime = 3;

  static const int animationTime = 7;

  static const int giftTime = 3;
}
