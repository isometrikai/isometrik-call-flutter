import 'package:call_qwik_example/main.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class AuthRepository {
  AuthRepository(this._apiWrapper);
  final ApiWrapper _apiWrapper;

  Future<ResponseModel> verifyOtp(
    Map<String, dynamic> payload,
  ) =>
      _apiWrapper.makeRequest(
        Endpoints.verifyOtp,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.patch,
        payload: payload.removeNullValues(),
        headers: {},
        showLoader: true,
        showDialog: true,
      );

  Future<ResponseModel> emailLogin(
    Map<String, dynamic> payload,
  ) =>
      _apiWrapper.makeRequest(
        Endpoints.emailLogin,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.post,
        payload: payload.removeNullValues(),
        headers: {},
        showLoader: true,
        showDialog: true,
        shouldAutoRedirect: false,
      );

  Future<ResponseModel> resetPassword(
    Map<String, dynamic> payload,
  ) =>
      _apiWrapper.makeRequest(
        Endpoints.resetPassword,
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.patch,
        payload: payload.removeNullValues(),
        headers: {},
        showLoader: true,
        showDialog: true,
      );

  Future<ResponseModel> forgotPassword(
    Map<String, dynamic> payload,
  ) =>
      _apiWrapper.makeRequest(
        '${Endpoints.forgotPassword}?${payload.removeNullValues().makeQuery()}',
        baseUrl: Endpoints.adminBaseUrl,
        type: RequestType.get,
        headers: {},
        showLoader: true,
        showDialog: true,
      );
}
