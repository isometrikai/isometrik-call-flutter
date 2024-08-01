import 'package:flutter/services.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallChannelHandler {
  static const MethodChannel _channel = MethodChannel('com.isometrik.call');

  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'handleIncomingPush') {
        final Map<dynamic, dynamic> payload = call.arguments;
        final nativeCall =
            IsmNativeCallModel.fromMap(payload.cast<String, dynamic>());
        IsmCallHelper.startRinging(nativeCall);
      }
    });
  }

  static Future<void> handleRinging(String callId) async {
    try {
      await _channel.invokeMethod('handleRinging', {'callId': callId});
    } on PlatformException catch (e) {
      IsmCallLog.error("Failed to handle ringing: '${e.message}'.");
    }
  }

  static Future<void> handleCallDeclined(String callId) async {
    try {
      await _channel.invokeMethod('handleCallDeclined', {'callId': callId});
    } on PlatformException catch (e) {
      IsmCallLog.error("Failed to handle call declined: '${e.message}'.");
    }
  }

  static Future<void> handleCallStarted(String callId) async {
    try {
      await _channel.invokeMethod('handleCallStarted', {'callId': callId});
    } on PlatformException catch (e) {
      IsmCallLog.error("Failed to handle call started: '${e.message}'.");
    }
  }

  static Future<void> handleTimeout(String callId) async {
    try {
      await _channel.invokeMethod('handleTimeout', {'callId': callId});
    } on PlatformException catch (e) {
      IsmCallLog.error("Failed to handle timeout: '${e.message}'.");
    }
  }

  static Future<void> handleCallEnd(String callId) async {
    try {
      await _channel.invokeMethod('handleCallEnd', {'callId': callId});
    } on PlatformException catch (e) {
      IsmCallLog.error("Failed to handle call end: '${e.message}'.");
    }
  }
}
