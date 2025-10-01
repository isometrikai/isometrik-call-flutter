import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter_platform_interface.dart';
import 'package:isometrik_call_flutter/src/controllers/controllers.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

/// An implementation of [IsometrikCallFlutterPlatform] that uses method channels.
class MethodChannelIsometrikCallFlutter extends IsometrikCallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('isometrik_call_flutter');

  MethodChannelIsometrikCallFlutter() {
    IsmCallLog.highlight(
        'Flutter: MethodChannelIsometrikCallFlutter constructor called, setting up method call handler');
    methodChannel.setMethodCallHandler(_handleCallbacks);
    IsmCallLog.highlight(
        'Flutter: Method channel handler set up successfully for channel: ${methodChannel.name}');
  }

  Future<void> _handleCallbacks(MethodCall call) async {
    IsmCallLog.highlight(
        'Flutter: _handleCallbacks called with method: ${call.method}, arguments: ${call.arguments}');

    try {
      switch (call.method) {
        case 'onStopScreenSharing':
          IsmCallLog.highlight(
              'Flutter: Processing onStopScreenSharing from native side');
          if (Get.isRegistered<IsmCallController>()) {
            final c = Get.find<IsmCallController>();
            IsmCallLog.highlight(
                'Flutter: Found IsmCallController, calling toggleScreenShare(false)');
            c.toggleScreenShare(false);
            IsmCallLog.highlight(
                'Flutter: Successfully called toggleScreenShare(false)');
          } else {
            IsmCallLog.error(
                'Flutter: IsmCallController not registered. Available controllers: ${Get.isRegistered<IsmCallController>() ? "Yes" : "No"}');
          }
          break;
        case 'onOpenAppFromNotification':
          IsmCallLog.highlight(
              'Flutter: Processing onOpenAppFromNotification from native side');
          if (Get.isRegistered<IsmCallController>()) {
            final c = Get.find<IsmCallController>();
            IsmCallLog.highlight(
                'Flutter: Found IsmCallController, navigating to call view');
            // Navigate to call view to show stop screen sharing option
            Get.toNamed('/call');
            IsmCallLog.highlight(
                'Flutter: Successfully navigated to call view');
          } else {
            IsmCallLog.error(
                'Flutter: IsmCallController not registered. Available controllers: ${Get.isRegistered<IsmCallController>() ? "Yes" : "No"}');
          }
          break;
        case 'showPermissionDialog':
          IsmCallLog.highlight(
              'Flutter: Processing showPermissionDialog from native side');
          _showPermissionDialog(call.arguments);
          IsmCallLog.highlight(
              'Flutter: Successfully processed showPermissionDialog');
          break;
        default:
          IsmCallLog.info('Flutter: Unknown method received: ${call.method}');
          break;
      }
    } catch (e, stackTrace) {
      IsmCallLog.error(
          'Flutter: Error processing callback method ${call.method}: $e\n$stackTrace');
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  void _showPermissionDialog(dynamic arguments) {
    try {
      if (arguments is Map) {
        final title = arguments['title'] ?? 'Permission Required';
        final message =
            arguments['message'] ?? 'Permission is required for this feature.';
        final settingsButton = arguments['settingsButton'] ?? 'Open Settings';
        final cancelButton = arguments['cancelButton'] ?? 'Cancel';

        // Show a dialog using Get.dialog
        Get.dialog(
          AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                },
                child: Text(cancelButton),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  // Open app settings
                  _openAppSettings();
                },
                child: Text(settingsButton),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      IsmCallLog.error('Error showing permission dialog: $e');
    }
  }

  void _openAppSettings() {
    try {
      // Use url_launcher to open app settings
      // This will open the app's permission settings page
      final packageName =
          'com.appscrip.call_qwik_example'; // Replace with your actual package name
      final settingsUrl = 'package:$packageName';

      // You can use url_launcher here if you have it in your dependencies
      // For now, we'll just log that we want to open settings
      IsmCallLog.highlight('Opening app settings: $settingsUrl');

      // You can implement actual settings opening logic here
      // For example, using url_launcher or other methods
    } catch (e) {
      IsmCallLog.error('Error opening app settings: $e');
    }
  }
}
