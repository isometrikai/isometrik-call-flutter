import 'dart:convert';

import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallDBWrapper {
  factory IsmCallDBWrapper() => instance;

  const IsmCallDBWrapper._();

  static const IsmCallDBWrapper instance = i;

  static const IsmCallDBWrapper i = IsmCallDBWrapper._();

  final _flutterSecureStorage = const FlutterSecureStorageManager();

  /// Get data from secure storage
  Future<String> getSecuredValue(String key, {String defaultValue = ''}) async {
    try {
      return await _flutterSecureStorage.getSecuredValue(key);
    } catch (error) {
      return defaultValue;
    }
  }

  /// Save data in secure storage
  Future<bool> saveValueSecurely(String key, String value) async =>
      await _flutterSecureStorage.saveValueSecurely(key, value);

  /// Delete data from secure storage
  Future<void> deleteSecuredValue(String key) async =>
      _flutterSecureStorage.deleteSecuredValue(key);

  /// Delete all data from secure storage
  Future<void> deleteAllSecuredValues() async =>
      _flutterSecureStorage.deleteAllSecuredValues();

  Future<bool> updatePushToken(String token) async =>
      await saveValueSecurely(IsmCallLocalKeys.apnsToken, token);

  Future<bool> addConfig(IsmCallConfig config) async {
    return await saveValueSecurely(
        IsmCallLocalKeys.config, jsonEncode(config.toJson()));
  }
}
