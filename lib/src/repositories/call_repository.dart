import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallRepository {
  IsmCallRepository(this._apiWrapper);
  final IsmCallApiWrapper _apiWrapper;

  Map<String, String> get _tokenHeader => IsmCall.i.config?.tokenHeader ?? {};

  Map<String, String> get _authHeader => IsmCall.i.config?.authHeader ?? {};

  Future<IsmCallResponseModel> startRecording(
    String meetingId,
  ) =>
      _apiWrapper.makeRequest(
        IsmCallEndpoints.startRecording,
        type: IsmCallRequestType.post,
        payload: {'meetingId': meetingId},
        headers: _tokenHeader,
        showDialog: false,
      );

  Future<IsmCallResponseModel> stopRecording(
    String meetingId,
  ) =>
      _apiWrapper.makeRequest(
        IsmCallEndpoints.stopRecording,
        type: IsmCallRequestType.post,
        payload: {'meetingId': meetingId},
        headers: _tokenHeader,
        showDialog: false,
      );

  Future<IsmCallResponseModel> updatePushToken(
    Map<String, dynamic> payload,
  ) =>
      _apiWrapper.makeRequest(
        IsmCallEndpoints.user,
        type: IsmCallRequestType.patch,
        payload: payload,
        headers: _authHeader,
        showDialog: false,
      );

  Future<IsmCallResponseModel> endCall(Map<String, dynamic> payload) async =>
      _apiWrapper.makeRequest(
        IsmCallEndpoints.call,
        baseUrl: IsmCallEndpoints.baseUrl,
        type: IsmCallRequestType.put,
        showLoader: false,
        payload: payload,
        headers: _tokenHeader,
      );

  Future<IsmCallResponseModel> acceptCall(Map<String, dynamic> payload) async =>
      _apiWrapper.makeRequest(
        IsmCallEndpoints.acceptCall,
        baseUrl: IsmCallEndpoints.baseUrl,
        type: IsmCallRequestType.post,
        showLoader: true,
        payload: payload,
        headers: _tokenHeader,
      );

  Future<IsmCallResponseModel> declineCall(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        IsmCallEndpoints.rejectCall,
        baseUrl: IsmCallEndpoints.baseUrl,
        type: IsmCallRequestType.post,
        showLoader: true,
        payload: payload,
        headers: _tokenHeader,
      );
}
