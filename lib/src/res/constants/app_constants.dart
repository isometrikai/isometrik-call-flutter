import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

/// `AppConstants` is a singleton class with all static variables.
///
/// It contains all constants that are to be used within the project
///
/// If need to check the translated strings that are used in UI (Views) of the app, check TranslationKeys
class IsmCallConstants {
  const IsmCallConstants._();

  static const String name = 'IsmCall';

  static const String appName = 'IsmCall';

  static const String packageName = 'isometrik_call_flutter';

  static const Duration animationDuration = Duration(milliseconds: 300);

  static const Duration timeOutDuration = Duration(seconds: 120);

  static double imageHeight = IsmCallDimens.twentyFive;

  static const int keepAlivePeriod = 60;

  static const int counterTime = 3;

  static const int animationTime = 7;

  static const int giftTime = 3;
}
