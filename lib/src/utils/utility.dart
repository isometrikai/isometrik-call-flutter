import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:just_audio/just_audio.dart';

class IsmCallUtility {
  const IsmCallUtility._();

  static final audioPlayer = AudioPlayer();

  static void updateLater(VoidCallback callback, [bool addDelay = true]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          addDelay ? const Duration(milliseconds: 10) : Duration.zero, () {
        callback();
      });
    });
  }

  static String jsonEncodePretty(Object? object) =>
      JsonEncoder.withIndent(' ' * 4).convert(object);

  /// Returns true if the internet connection is available.
  static Future<bool> get isNetworkAvailable async {
    final result = await Connectivity().checkConnectivity();
    return result.any((e) => [
          ConnectivityResult.mobile,
          ConnectivityResult.wifi,
          ConnectivityResult.ethernet,
        ].contains(e));
  }

  static Future<String?> getMimetype(String mediaExtension) async {
    final jsondata = await rootBundle
        .loadString('packages/isometrik_call_flutter/assets/mimetypes.json');
    //decode json data as list
    final response = json.decode(jsondata) as Map<String, dynamic>;

    dynamic typeList = response['mimetypes'];

    for (Map<String, dynamic> type in typeList) {
      if (type.containsKey(mediaExtension)) {
        var extensionValue = type[mediaExtension] as String;
        return Future.value(extensionValue);
      }
    }
    return null;
  }

  static Future<T?> openBottomSheet<T>(
    Widget child, {
    double? radius,
    bool isDismissible = true,
    bool? ignoreSafeArea,
    bool enableDrag = true,
    bool isScrollControlled = false,
    Color? backgroundColor,
  }) async =>
      await Get.bottomSheet<T>(
        SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              radius ?? IsmCallDimens.sixteen,
            ),
            child: child,
          ),
        ),
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        ignoreSafeArea: ignoreSafeArea,
        enableDrag: enableDrag,
        backgroundColor:
            backgroundColor ?? Get.context?.theme.scaffoldBackgroundColor,
      );

  /// Show loader
  static void showLoader([String? message]) async {
    await Get.dialog(
      IsmCallLoader(message: message),
      barrierDismissible: false,
    );
  }

  /// Close loader
  static void closeLoader() {
    closeDialog();
  }

  /// Show error dialog from response model
  static Future<void> showInfoDialog(
    IsmCallResponseModel data, {
    bool isSuccess = false,
    String? title,
    VoidCallback? onRetry,
  }) async {
    // if (Get.isDialogOpen ?? false) {
    //   return;
    // }
    final jsonData = jsonDecode(data.data);
    await Get.dialog(
      CupertinoAlertDialog(
        title: Text(
          title ?? (isSuccess ? 'Success' : 'Error'),
        ),
        content: Text(
          jsonData['message'] as String? ?? jsonData['error'] as String? ?? '',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: Get.back,
            isDefaultAction: true,
            child: const Text('Okay'),
          ),
          if (onRetry != null)
            CupertinoDialogAction(
              onPressed: () {
                Get.back();
                onRetry();
              },
              isDefaultAction: true,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  static Future<bool?> showToast(
    String msg, {
    Color color = IsmCallColors.green,
  }) =>
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 12,
      );

  /// Close any open dialog.
  static void closeDialog() {
    if (Get.isDialogOpen ?? false) Get.back<void>();
  }

  /// Close any open snackbar
  static void closeBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) Get.back<void>();
  }

  /// Close any open snackbar
  static void closeSnackbar() {
    if (Get.isSnackbarOpen) Get.back<void>();
  }

  //plays audio from assets
  static Future<void> playAudioFromAssets(String assetName) async {
    await audioPlayer.setAsset(assetName);
    await audioPlayer.setVolume(1);
    await audioPlayer.setLoopMode(LoopMode.all);
    await audioPlayer.play();
  }

  //plays audio from assets
  static Future<void> stopAudio() async {
    await audioPlayer.stop();
  }
}
