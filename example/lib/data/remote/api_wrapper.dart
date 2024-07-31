import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:http/http.dart'
    show Client, Response, MultipartRequest, MultipartFile;
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

/// API WRAPPER to call all the CallApis and handle the status codes
class ApiWrapper {
  const ApiWrapper(this.client);

  final Client client;

  /// Method to make all the requests inside the app like GET, POST, PUT, Delete
  Future<ResponseModel> makeRequest(
    String api, {
    String? baseUrl,
    required RequestType type,
    required Map<String, String> headers,
    dynamic payload,
    String field = '',
    String filePath = '',
    bool showLoader = false,
    bool showDialog = true,
    bool shouldEncodePayload = true,
    String? message,
    bool shouldAutoRedirect = true,
  }) async {
    assert(
      type != RequestType.upload ||
          (type == RequestType.upload &&
              payload is! Map<String, String> &&
              field.isNotEmpty &&
              filePath.isNotEmpty),
      'if type is passed as [RequestType.upload] then payload must be of type Map<String, String> and field & filePath must not be empty',
    );
    assert(
      type != RequestType.get || (type == RequestType.get && payload == null),
      'if type is passed as [RequestType.get] then payload must not be passed',
    );

    /// To see whether the network is available or not
    var url = (baseUrl ?? Endpoints.baseUrl) + api;

    final uri = Uri.parse(url);

    CallLog.info('[Request] - ${type.name.toUpperCase()} - $uri\n$payload');

    if (showLoader) Utility.showLoader(message);
    if (await Utility.isNetworkAvailable) {
      try {
        // Handles API call
        var start = DateTime.now();
        var response = await _handleRequest(
          uri,
          type: type,
          headers: headers,
          payload: shouldEncodePayload ? jsonEncode(payload) : payload,
          field: field,
          filePath: filePath,
        );

        // Handles response based on status code
        var res = await _processResponse(
          response,
          showDialog: showDialog,
          startTime: start,
          shouldAutoRedirect: shouldAutoRedirect,
        );
        if (showLoader) {
          Utility.closeLoader();
        }
        if (res.statusCode != 406) {
          return res;
        }
        if (IsmCall.i.refreshToken == null) {
          return res;
        }
        if (!IsmCall.i.isInitialized) {
          return res;
        }
        final tokenHeader = await Utility.callConfig();
        var headers0 = {
          ...tokenHeader.tokenHeader,
          'Authorization': IsmCall.i.config?.userConfig.accessToken ?? '',
        };
        if (headers0['Authorization'] == headers['Authorization']) {
          return res;
        }
        if (Get.currentRoute == '/email-login') {
          return res;
        }
        return makeRequest(
          api,
          baseUrl: baseUrl,
          type: type,
          headers: headers0,
          payload: payload,
          field: field,
          filePath: filePath,
          showDialog: showDialog,
          showLoader: showLoader,
          shouldEncodePayload: shouldEncodePayload,
        );
      } on TimeoutException catch (e, st) {
        CallLog.error('TimeoutException $e, $st');
        if (showLoader) {
          Utility.closeLoader();
        }
        await Future.delayed(const Duration(milliseconds: 100));
        var res = ResponseModel.message(CallStrings.timeoutError);
        if (showDialog) {
          await Utility.showInfoDialog(
            res,
            title: 'Timeout Error',
          );
        }
        return res;
      } on SocketException catch (e, st) {
        CallLog.error('SocketException $e, $st');
        if (showLoader) {
          Utility.closeLoader();
        }
        await Future.delayed(const Duration(milliseconds: 100));
        var res = ResponseModel.message(CallStrings.socketProblem);

        if (showDialog) {
          await Utility.showInfoDialog(
            res,
            title: 'Network Error',
          );
        }
        return res;
      } on ArgumentError catch (e, st) {
        CallLog.error('ArgumentError $e, $st');
        if (showLoader) {
          Utility.closeLoader();
        }
        await Future.delayed(const Duration(milliseconds: 100));
        var res = ResponseModel.message(CallStrings.somethingWentWrong);

        if (showDialog) {
          await Utility.showInfoDialog(
            res,
            title: 'Argument Error',
          );
        }
        return res;
      } catch (e, st) {
        CallLog.error(e.runtimeType);
        CallLog.error(e, st);
        if (showLoader) {
          Utility.closeLoader();
        }
        await Future.delayed(const Duration(milliseconds: 100));
        var res = ResponseModel.message(CallStrings.somethingWentWrong);

        if (showDialog) {
          await Utility.showInfoDialog(res);
        }
        return res;
      }
    } else {
      CallLog.error('No Internet Connection', StackTrace.current);
      if (showLoader) {
        Utility.closeLoader();
      }
      await Future.delayed(const Duration(milliseconds: 100));
      var res = ResponseModel.message(CallStrings.noInternet);

      if (showDialog) {
        await Utility.showInfoDialog(
          res,
          title: 'Internet Error',
          onRetry: () => makeRequest(
            api,
            baseUrl: baseUrl,
            type: type,
            headers: headers,
            payload: payload,
            field: field,
            filePath: filePath,
            showDialog: showDialog,
            showLoader: showLoader,
            shouldEncodePayload: shouldEncodePayload,
          ),
        );
      }
      return res;
    }
  }

  Future<Response> _handleRequest(
    Uri api, {
    required RequestType type,
    required Map<String, String> headers,
    required String field,
    required String filePath,
    dynamic payload,
  }) async {
    switch (type) {
      case RequestType.get:
        return _get(api, headers: headers);
      case RequestType.post:
        return _post(api, payload: payload, headers: headers);
      case RequestType.put:
        return _put(api, payload: payload, headers: headers);
      case RequestType.patch:
        return _patch(api, payload: payload, headers: headers);
      case RequestType.delete:
        return _delete(api, payload: payload, headers: headers);
      case RequestType.upload:
        return _upload(
          api,
          payload: payload,
          headers: headers,
          field: field,
          filePath: filePath,
        );
    }
  }

  Future<Response> _get(
    Uri api, {
    required Map<String, String> headers,
  }) async =>
      await client
          .get(
            api,
            headers: headers,
          )
          .timeout(AppConstants.timeOutDuration);

  Future<Response> _post(
    Uri api, {
    required payload,
    required Map<String, String> headers,
  }) async =>
      await client
          .post(
            api,
            body: payload,
            headers: headers,
          )
          .timeout(AppConstants.timeOutDuration);

  Future<Response> _put(
    Uri api, {
    required dynamic payload,
    required Map<String, String> headers,
  }) async =>
      await client
          .put(
            api,
            body: payload,
            headers: headers,
          )
          .timeout(AppConstants.timeOutDuration);

  Future<Response> _patch(
    Uri api, {
    required dynamic payload,
    required Map<String, String> headers,
  }) async =>
      await client
          .patch(
            api,
            body: payload,
            headers: headers,
          )
          .timeout(AppConstants.timeOutDuration);

  Future<Response> _delete(
    Uri api, {
    required dynamic payload,
    required Map<String, String> headers,
  }) async =>
      await client
          .delete(
            api,
            body: payload,
            headers: headers,
          )
          .timeout(AppConstants.timeOutDuration);

  /// Method to make all the requests inside the app like GET, POST, PUT, Delete
  Future<Response> _upload(
    Uri api, {
    required Map<String, String> payload,
    required Map<String, String> headers,
    required String field,
    required String filePath,
  }) async {
    var request = MultipartRequest(
      'POST',
      api,
    )
      ..headers.addAll(headers)
      ..fields.addAll(payload)
      ..files.add(
        await MultipartFile.fromPath(field, filePath),
      );

    var response = await request.send();

    return await Response.fromStream(response);
  }

  /// Method to return the API response based upon the status code of the server
  Future<ResponseModel> _processResponse(
    Response response, {
    required bool showDialog,
    required DateTime startTime,
    bool shouldAutoRedirect = true,
  }) async {
    var diff = DateTime.now().difference(startTime).inMilliseconds / 1000;
    CallLog(
        '[Response] - ${diff}s ${response.statusCode} ${response.request?.url}\n${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 208:
        return ResponseModel(
          data: utf8.decode(response.bodyBytes),
          hasError: false,
          statusCode: response.statusCode,
        );
      case 400:
      case 401:
      case 404:
      case 406:
      case 409:
      case 410:
      case 412:
      case 413:
      case 415:
      case 416:
      case 522:
        if (response.statusCode == 401) {
          if (shouldAutoRedirect) {
            await IsmCall.i.logout?.call();
          }
        } else if (response.statusCode == 406) {
          await IsmCall.i.refreshToken?.call();
        }
        var hasError = true;
        var res = ResponseModel(
          data: utf8.decode(response.bodyBytes),
          hasError: hasError,
          statusCode: response.statusCode,
        );
        if (![406, 410].contains(response.statusCode) && showDialog) {
          if (response.statusCode == 401) {
            // unawaited(IsmCallUtility.showInfoDialog(IsmCallResponseModel.message(
            //   CallStrings.unauthorized,
            //   isSuccess: !res.hasError,
            //   statusCode: res.statusCode,
            // )));
          } else {
            await Utility.showInfoDialog(res);
          }
        }
        return res;
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        var message = '';
        try {
          var data = jsonDecode(utf8.decode(response.bodyBytes));
          message = data['message'] as String? ?? CallStrings.serverError;
        } catch (e, st) {
          message = CallStrings.serverError;
          CallLog.error(e, st);
        }
        var res = ResponseModel.message(
          message,
          statusCode: response.statusCode,
        );
        if (showDialog) {
          await Utility.showInfoDialog(res);
        }
        return res;

      default:
        return ResponseModel(
          data: utf8.decode(response.bodyBytes),
          hasError: true,
          statusCode: response.statusCode,
        );
    }
  }
}
