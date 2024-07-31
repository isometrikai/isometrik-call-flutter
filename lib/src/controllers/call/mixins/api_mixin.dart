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
    if (token.trim().isEmpty) {
      token =
          await IsmCallDBWrapper.i.getSecuredValue(IsmCallLocalKeys.apnsToken);
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

  // TODO: Implement this API call in plugin
  Future<IsmAcceptCallModel?> startCall({
    required String imageUrl,
    required String userId,
    required String conversationId,
    required bool audioOnly,
  }) =>
      _controller._viewModel.startCall(
        imageUrl: imageUrl,
        userId: userId,
        conversationId: conversationId,
        deviceId: IsmCall.i.config?.projectConfig.deviceId ?? '',
        audioOnly: audioOnly,
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
