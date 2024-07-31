import 'dart:async';

import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class AuthViewModel {
  AuthViewModel(this._repository);
  final AuthRepository _repository;

  DBWrapper get _dbWrapper => Get.find<DBWrapper>();

  Future<AgentDetailsModel?> verifyOtp(
    AgentModel payload,
  ) async {
    try {
      var res = await _repository.verifyOtp(payload.toMap());

      if (res.hasError) {
        return null;
      }
      var val = res.decode();
      var data = AgentDetailsModel.fromMap(val['data']);

      await Future.wait([
        _dbWrapper.saveValueSecurely(LocalKeys.agent, data.toJson()),
        _dbWrapper.saveValue(LocalKeys.isLoggedIn, true),
      ]);

      return data;
    } catch (e, st) {
      CallLog.error('agent Login $e', st);
      return null;
    }
  }

  Future<AgentDetailsModel?> emailLogin({
    String? clientName,
    String? projectId,
    required String email,
    required String password,
  }) async {
    try {
      var res = await _repository.emailLogin({
        'clientName': clientName,
        'createdUnderProjectId': projectId,
        'email': email,
        'password': password,
      });

      if (res.hasError) {
        return null;
      }

      var data = AgentDetailsModel.fromMap(res.body);

      await Future.wait([
        _dbWrapper.saveValueSecurely(LocalKeys.agent, data.toJson()),
        if (!data.isFirstTimeLogin && data.clientNames.isEmpty) ...[
          _dbWrapper.saveValue(LocalKeys.isLoggedIn, true),
        ],
      ]);

      return data;
    } catch (e, st) {
      CallLog.error('Email Login $e', st);
      return null;
    }
  }

  Future<bool> resetPassword({
    required String clientName,
    required String projectId,
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      var res = await _repository.resetPassword({
        'clientName': clientName,
        'createdUnderProjectId': projectId,
        'email': email,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });

      if (res.hasError) {
        return false;
      }

      await Future.wait([
        _dbWrapper.saveValue(LocalKeys.isLoggedIn, true),
      ]);

      return true;
    } catch (e, st) {
      CallLog.error('Email Login $e', st);
      return false;
    }
  }

  Future<bool> forgotPassword({
    required String email,
    required String clientName,
    required String projectId,
  }) async {
    try {
      var res = await _repository.forgotPassword({
        'email': email,
        'clientName': clientName,
        'createdUnderProjectId': projectId,
      });

      return !res.hasError;
    } catch (e, st) {
      CallLog.error('Email Login $e', st);
      return false;
    }
  }
}
