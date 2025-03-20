import 'package:flutter_test/flutter_test.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter_method_channel.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIsometrikCallFlutterPlatform
    with MockPlatformInterfaceMixin
    implements IsometrikCallFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final initialPlatform = IsometrikCallFlutterPlatform.instance;

  test('$MethodChannelIsometrikCallFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIsometrikCallFlutter>());
  });

  test('getPlatformVersion', () async {
    var ismCallPlugin = IsmCall();
    var fakePlatform = MockIsometrikCallFlutterPlatform();
    IsometrikCallFlutterPlatform.instance = fakePlatform;

    expect(await ismCallPlugin.getPlatformVersion(), '42');
  });
}
