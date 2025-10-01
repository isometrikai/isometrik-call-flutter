import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class MediaProjectionHelper {
  static const MethodChannel _channel = MethodChannel('isometrik_call_flutter');

  static Future<bool> startMediaProjectionService() async {
    try {
      if (GetPlatform.isAndroid) {
        final result =
            await _channel.invokeMethod('startMediaProjectionService');
        return result == true;
      }
      return true; // iOS doesn't need this
    } catch (e) {
      IsmCallLog.error('Error starting media projection service: $e');
      return false;
    }
  }

  static Future<bool> stopMediaProjectionService() async {
    try {
      if (GetPlatform.isAndroid) {
        final result =
            await _channel.invokeMethod('stopMediaProjectionService');
        return result == true;
      }
      return true; // iOS doesn't need this
    } catch (e) {
      IsmCallLog.error('Error stopping media projection service: $e');
      return false;
    }
  }

  static Future<bool> isServiceRunning() async {
    try {
      if (GetPlatform.isAndroid) {
        final result =
            await _channel.invokeMethod('isMediaProjectionServiceRunning');
        return result == true;
      }
      return false; // iOS doesn't have this service
    } catch (e) {
      IsmCallLog.error('Error checking media projection service status: $e');
      return false;
    }
  }

  static Future<bool> isScreenSharingActive() async {
    try {
      if (GetPlatform.isAndroid) {
        final result = await _channel.invokeMethod('isScreenSharingActive');
        return result == true;
      }
      return false; // iOS doesn't have this service
    } catch (e) {
      IsmCallLog.error('Error checking screen sharing status: $e');
      return false;
    }
  }

  static Future<bool> startMediaProjectionMonitoring() async {
    try {
      if (GetPlatform.isAndroid) {
        final result =
            await _channel.invokeMethod('startMediaProjectionMonitoring');
        return result == true;
      }
      return true; // iOS doesn't need this
    } catch (e) {
      IsmCallLog.error('Error starting media projection monitoring: $e');
      return false;
    }
  }

  static Future<bool> showPermissionDialog() async {
    try {
      if (GetPlatform.isAndroid) {
        final result = await _channel.invokeMethod('showPermissionDialog');
        return result == true;
      }
      return true; // iOS doesn't need this
    } catch (e) {
      IsmCallLog.error('Error showing permission dialog: $e');
      return false;
    }
  }

  static Future<bool> ensureForegroundService() async {
    try {
      if (GetPlatform.isAndroid) {
        final result = await _channel.invokeMethod('ensureForegroundService');
        return result == true;
      }
      return true; // iOS doesn't need this
    } catch (e) {
      IsmCallLog.error('Error ensuring foreground service: $e');
      return false;
    }
  }
}
