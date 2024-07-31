import 'package:call_qwik_example/main.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class LogsRepository {
  LogsRepository(this._apiWrapper);
  final ApiWrapper _apiWrapper;

  Future<Map<String, String>> get _authHeader async {
    final config = await Utility.callConfig();
    return config.authHeader;
  }

  Future<ResponseModel> getCallLogs({
    int limit = 10,
    int skip = 0,
    bool isOpportunities = false,
    String? userId,
  }) async {
    var query = {
      'limit': limit,
      'skip': skip,
      if (userId != null) ...{
        'userId': userId,
      },
      if (isOpportunities) ...{
        'callStatus': 'NoMember',
      },
    };
    return _apiWrapper.makeRequest(
      '${Endpoints.callLog}?${query.makeQuery()}',
      type: RequestType.get,
      baseUrl: Endpoints.adminBaseUrl,
      headers: await _authHeader,
      showDialog: true,
    );
  }
}
