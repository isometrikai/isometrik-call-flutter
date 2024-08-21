part of '../call_controller.dart';

mixin IsmCallApiMixin {
  IsmCallController get _controller => Get.find();

  Future<bool> addPushToken() => _controller._viewModel.updatePushToken(
        add: true,
        token: _controller.currentPushToken ?? '',
      );

  Future<bool> removePushToken([
    bool isLoggingOut = false,
  ]) async {
    var token = (isLoggingOut
            ? _controller.currentPushToken
            : _controller.prevPushToken) ??
        '';
    if (isLoggingOut && token.isEmpty) {
      token = _controller.prevPushToken ?? '';
    }
    if (!isLoggingOut && token.isEmpty) {
      token = _controller.currentPushToken ?? '';
    }
    if (token.isEmpty) {
      token =
          await IsmCallDBWrapper.i.getSecuredValue(IsmCallLocalKeys.apnsToken);
    }
    if (token.isEmpty) {
      token = await IsmCallHelper.getPushToken();
    }
    return _controller._viewModel.updatePushToken(
      add: false,
      token: token,
    );
  }

  Future<bool> _startRecording(
    String meetingId,
  ) =>
      _controller._viewModel.startRecording(
        meetingId,
      );

  Future<bool> _stopRecording(
    String meetingId,
  ) =>
      _controller._viewModel.stopRecording(
        meetingId,
      );

  Future<bool> endCall(String meetingId) =>
      _controller._viewModel.endCall(meetingId);

  Future<IsmAcceptCallModel?> acceptCall(
    String meetingId,
    String deviceId,
  ) =>
      _controller._viewModel.acceptCall(meetingId, deviceId);

  Future<bool> declineCall(String meetingId) =>
      _controller._viewModel.declineCall(meetingId);
}
