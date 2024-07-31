import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class FlutterSecureStorageManager {
  const FlutterSecureStorageManager();

  /// initialize flutter secure storage
  final flutterSecureStorage = const FlutterSecureStorage();

  /// Get data from secure storage
  Future<String> getSecuredValue(String key) async {
    try {
      var value = await flutterSecureStorage.read(key: key);
      if (value == null || value.isEmpty) {
        value = '';
      }
      return value;
    } catch (error) {
      return '';
    }
  }

  /// Save data in secure storage
  Future<bool> saveValueSecurely(String key, String value) async {
    try {
      await flutterSecureStorage.write(key: key, value: value);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Delete data from secure storage
  void deleteSecuredValue(String key) {
    flutterSecureStorage.delete(key: key);
  }

  /// Delete all data from secure storage
  void deleteAllSecuredValues() {
    flutterSecureStorage.deleteAll();
  }

  /// Method For Delete & Override from Secure Storage
  void deleteSaveSecureValue(String key, String value) async {
    try {
      await flutterSecureStorage.delete(key: key);
      await flutterSecureStorage.write(key: key, value: value);
    } catch (e, st) {
      IsmCallLog.error(e, st);
    }
  }
}
