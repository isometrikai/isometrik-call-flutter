import 'package:isometrik_call_flutter/isometrik_call_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class IsometrikCallFlutterPlatform extends PlatformInterface {
  /// Constructs a IsometrikCallFlutterPlatform.
  IsometrikCallFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static IsometrikCallFlutterPlatform _instance =
      MethodChannelIsometrikCallFlutter();

  /// The default instance of [IsometrikCallFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelIsometrikCallFlutter].
  static IsometrikCallFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IsometrikCallFlutterPlatform] when
  /// they register themselves.
  static set instance(IsometrikCallFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
