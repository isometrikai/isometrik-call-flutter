import 'package:call_qwik_example/main.dart';
import 'package:flutter/services.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class HomeRepository {
  HomeRepository(this._apiWrapper);
  final ApiWrapper _apiWrapper;

  Future<Map<String, String>> get _tokenHeader async {
    final config = await Utility.callConfig();
    return config.tokenHeader;
  }

  Future<Map<String, String>> get _authHeader async {
    final config = await Utility.callConfig();
    return config.authHeader;
  }

  Future<Map<String, String>> get _projectHeader async {
    final config = await Utility.callConfig();
    return config.projectHeader;
  }

  Future<Map<String, String>> _awsHeader(
      String contentType, String host) async {
    final config = await Utility.callConfig();
    return config.awsHeader(contentType, host);
  }

  Future<ResponseModel> refreshToken({
    required String refreshToken,
    required String clientName,
  }) =>
      _apiWrapper.makeRequest(
        Endpoints.refreshToken,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.get,
        headers: {
          'ClientName': clientName,
          'Authorization': refreshToken,
        },
        showLoader: false,
        showDialog: true,
        message: 'Refreshing token',
      );

  Future<ResponseModel> getPresignedUrl({
    required bool showLoader,
    required Map<String, dynamic> payload,
  }) async =>
      _apiWrapper.makeRequest(
        Endpoints.presignedurl,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.post,
        headers: await _tokenHeader,
        payload: payload,
        showLoader: showLoader,
      );

  Future<ResponseModel> editProfile(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.editProfile,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.patch,
        payload: payload,
        headers: await _projectHeader,
        showLoader: true,
      );

  Future<ResponseModel> answerCall(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.answerCall,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.post,
        payload: payload,
        headers: await _projectHeader,
        showLoader: true,
        showDialog: true,
      );

  Future<ResponseModel> endCall(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.endCall,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.put,
        payload: payload,
        headers: await _authHeader,
        showLoader: false,
        showDialog: true,
      );

  Future<ResponseModel> getStatus() async => _apiWrapper.makeRequest(
        Endpoints.status,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.get,
        headers: await _authHeader,
        showLoader: false,
        showDialog: false,
      );

  Future<ResponseModel> updateStatus(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.status,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.patch,
        payload: payload,
        headers: {
          ...await _tokenHeader,
          'Authorization': IsmCall.i.config?.userConfig.accessToken ?? '',
        },
        showLoader: true,
        showDialog: true,
      );

  Future<ResponseModel> heartbeat() async => _apiWrapper.makeRequest(
        Endpoints.heartbeat,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.patch,
        headers: {
          ...await _tokenHeader,
          'Authorization': IsmCall.i.config?.userConfig.accessToken ?? '',
        },
        showLoader: false,
        showDialog: false,
      );

  Future<ResponseModel> updateContact({
    required bool isNewContact,
    required Map<String, dynamic> payload,
  }) async =>
      _apiWrapper.makeRequest(
        Endpoints.contact,
        baseUrl: Endpoints.adminBaseUrl,
        type: isNewContact ? RequestType.post : RequestType.patch,
        payload: payload,
        headers: await _authHeader,
        showLoader: true,
      );

  Future<ResponseModel> deleteContact(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        '${Endpoints.contact}?${payload.makeQuery()}',
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.delete,
        headers: await _authHeader,
        showLoader: true,
      );

  Future<ResponseModel> getConfig() async => _apiWrapper.makeRequest(
        Endpoints.config,
        type: RequestType.get,
        baseUrl: Endpoints.adminBaseUrl,
        headers: await _authHeader,
      );

  Future<ResponseModel> getNotes({
    required Map<String, dynamic> query,
    bool? showLoader,
  }) async =>
      _apiWrapper.makeRequest(
        '${Endpoints.notes}?${query.makeQuery()}',
        type: RequestType.get,
        baseUrl: Endpoints.adminBaseUrl,
        headers: await _authHeader,
        showLoader: showLoader ?? false,
      );

  Future<ResponseModel> addNote(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.notes,
        type: RequestType.post,
        baseUrl: Endpoints.adminBaseUrl,
        payload: payload,
        headers: await _authHeader,
        showLoader: true,
      );

  Future<ResponseModel> getRecordings(
    Map<String, dynamic> query,
  ) async =>
      _apiWrapper.makeRequest(
        '${Endpoints.getRecordings}?${query.makeQuery()}',
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.get,
        headers: await _authHeader,
      );

  Future<ResponseModel> getContact({
    // required String teamId,
    required String userId,
  }) async {
    var payload = {
      // 'teamId': teamId,
      'id': userId,
      'limit': 10,
      'skip': 0,
    };
    return _apiWrapper.makeRequest(
      '${Endpoints.contact}?${payload.makeQuery()}',
      baseUrl: Endpoints.adminBaseUrl,
      type: RequestType.get,
      headers: {
        'Authorization': IsmCall.i.config?.userConfig.accessToken ?? '',
      },
    );
  }

  Future<ResponseModel> blockOrUnblock(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.block,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.patch,
        showLoader: true,
        payload: payload,
        headers: await _authHeader,
      );

  Future<ResponseModel> updatePresignedUrl({
    required String presignedUrl,
    required Uint8List file,
    required String contentType,
    required String host,
  }) async =>
      _apiWrapper.makeRequest(
        presignedUrl,
        baseUrl: '',
        type: RequestType.put,
        payload: file,
        headers: await _awsHeader(contentType, host),
        showLoader: false,
        shouldEncodePayload: false,
      );

  Future<ResponseModel> startRecording(
    String meetingId,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.startRecording,
        type: RequestType.post,
        payload: {'meetingId': meetingId},
        headers: await _tokenHeader,
      );

  Future<ResponseModel> stopRecording(
    String meetingId,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.stopRecording,
        type: RequestType.post,
        payload: {'meetingId': meetingId},
        headers: await _tokenHeader,
      );

  Future<ResponseModel> updatePushToken(
    Map<String, dynamic> payload,
  ) async =>
      _apiWrapper.makeRequest(
        Endpoints.user,
        type: RequestType.patch,
        payload: payload,
        headers: await _authHeader,
      );
}
