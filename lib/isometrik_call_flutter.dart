
import 'isometrik_call_flutter_platform_interface.dart';

class IsometrikCallFlutter {
  Future<String?> getPlatformVersion() {
    return IsometrikCallFlutterPlatform.instance.getPlatformVersion();
  }
}
