import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallViewModel {
  IsmCallViewModel(this._repository);
  final IsmCallRepository _repository;

  Future<bool> updatePushToken({
    required bool add,
    required String token,
  }) async {
    try {
      var res = await _repository.updatePushToken({
        'addApnsDeviceToken': add,
        'apnsDeviceToken': token,
      });
      return !res.hasError;
    } catch (e, st) {
      IsmCallLog.error(e, st);
      return false;
    }
  }

  Future<bool> startRecording(
    String meetingId,
  ) async {
    try {
      var res = await _repository.startRecording(
        meetingId,
      );
      return !res.hasError;
    } catch (e, st) {
      IsmCallLog.error(e, st);
      return false;
    }
  }

  Future<bool> stopRecording(
    String meetingId,
  ) async {
    try {
      var res = await _repository.stopRecording(
        meetingId,
      );
      return !res.hasError;
    } catch (e, st) {
      IsmCallLog.error(e, st);
      return false;
    }
  }

  Future<bool> endCall(String meetingId) async {
    try {
      final res = await _repository.endCall({'meetingId': meetingId});
      return !res.hasError;
    } catch (_) {
      return false;
    }
  }

  Future<IsmAcceptCallModel?> acceptCall(
      String meetingId, String deviceId) async {
    try {
      final res = await _repository.acceptCall({
        'meetingId': meetingId,
        'deviceId': deviceId,
      });
      if (res.hasError) {
        return null;
      }
      return IsmAcceptCallModel.fromJson(res.data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> declineCall(String meetingId) async {
    try {
      final res = await _repository.declineCall({'meetingId': meetingId});
      return !res.hasError;
    } catch (_) {
      return false;
    }
  }
}
