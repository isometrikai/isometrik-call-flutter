import 'package:call_qwik_example/main.dart';

class LogsViewModel {
  LogsViewModel(this._repository);
  final LogsRepository _repository;

  Future<LogsList?> getCallLogs({
    int limit = 20,
    int skip = 0,
    bool isOpportunities = false,
    String? userId,
  }) async {
    try {
      var res = await _repository.getCallLogs(
        limit: limit,
        skip: skip,
        userId: userId,
        isOpportunities: isOpportunities,
      );

      if (res.hasError) {
        return null;
      }
      if (res.statusCode == 204) {
        return [];
      }
      var data = res.bodyList;

      return data
          .map((e) => CallLogsModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      CallLog.error('get logs $e, $st');
      return null;
    }
  }

  LogsGroupList parseLogs(LogsList logs) {
    var result = <DateTime, List<CallLogsModel>>{};
    for (var log in logs) {
      var date = log.timestamp.dateOnly;
      if (!result.keys.contains(date)) {
        result[date] = [log];
      } else {
        result[date]!.add(log);
      }
    }
    return result.values.toList();
  }
}
