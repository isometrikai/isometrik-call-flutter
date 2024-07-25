import 'package:flutter_test/flutter_test.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter_platform_interface.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIsometrikCallFlutterPlatform
    with MockPlatformInterfaceMixin
    implements IsometrikCallFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IsometrikCallFlutterPlatform initialPlatform = IsometrikCallFlutterPlatform.instance;

  test('$MethodChannelIsometrikCallFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIsometrikCallFlutter>());
  });

  test('getPlatformVersion', () async {
    IsometrikCallFlutter isometrikCallFlutterPlugin = IsometrikCallFlutter();
    MockIsometrikCallFlutterPlatform fakePlatform = MockIsometrikCallFlutterPlatform();
    IsometrikCallFlutterPlatform.instance = fakePlatform;

    expect(await isometrikCallFlutterPlugin.getPlatformVersion(), '42');
  });
}
