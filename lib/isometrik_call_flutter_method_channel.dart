import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'isometrik_call_flutter_platform_interface.dart';

/// An implementation of [IsometrikCallFlutterPlatform] that uses method channels.
class MethodChannelIsometrikCallFlutter extends IsometrikCallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('isometrik_call_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
