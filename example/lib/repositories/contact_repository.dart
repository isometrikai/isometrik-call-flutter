import 'package:call_qwik_example/main.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class ContactRepository {
  ContactRepository(this._apiWrapper);
  final ApiWrapper _apiWrapper;

  Future<ResponseModel> getContacts({
    required String teamId,
    int limit = 10,
    int skip = 0,
    String? query,
  }) async {
    var payload = {
      'teamId': teamId,
      'limit': limit,
      'skip': skip,
      if (query != null && query.trim().isNotEmpty) ...{
        'q': query,
      },
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
}
