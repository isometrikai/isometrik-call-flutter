import 'package:call_qwik_example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LogsController extends GetxController {
  LogsController(this._viewModel);

  final LogsViewModel _viewModel;

  var callLogsController = RefreshController(initialRefresh: false);
  var opportunityController = RefreshController(initialRefresh: false);

  var historyLogsController = RefreshController(initialRefresh: false);
  var historyOpportunityController = RefreshController(initialRefresh: false);

  RefreshController _logsController(bool isOpportunities) =>
      isOpportunities ? opportunityController : callLogsController;

  RefreshController historyController(bool isOpportunities) =>
      isOpportunities ? historyOpportunityController : historyLogsController;

  bool isLogsLoading = true;
  bool isOpportunityLoading = true;

  bool isLoading(bool isOpportunities) =>
      isOpportunities ? isOpportunityLoading : isLogsLoading;

  final logsLimit = 20;
  var logsSkip = 0;
  var logsTotalCount = 0;

  final opportunitiesLimit = 20;
  var opportunitiesSkip = 0;
  var opportunitiesTotalCount = 0;

  final historyLimit = 20;
  var historySkip = 0;
  var historyTotalCount = 0;

  final historyOpportunitiesLimit = 20;
  var historyOpportunitiesSkip = 0;
  var historyOpportunitiesTotalCount = 0;

  bool isHistoryLoading = true;
  bool isHistoryOpportunityLoading = true;

  bool isHistoryLogsLoading(bool isOpportunities) =>
      isOpportunities ? isHistoryOpportunityLoading : isHistoryLoading;

  final RxList<LogsList> _logs = <LogsList>[].obs;
  LogsGroupList get logs => _logs;
  set logs(LogsGroupList value) {
    if (listEquals(value, _logs)) {
      return;
    }
    _logs.value = value;
  }

  final RxList<LogsList> _opportunities = <LogsList>[].obs;
  LogsGroupList get opportunities => _opportunities;
  set opportunities(LogsGroupList value) {
    if (listEquals(value, _opportunities)) {
      return;
    }
    _opportunities.value = value;
  }

  Map<String, List<CallLogsModel>> history = {};
  Map<String, List<CallLogsModel>> historyOpportunities = {};

  Map<String, List<CallLogsModel>> historyLogs(bool isOpportunities) =>
      isOpportunities ? historyOpportunities : history;

  bool hasHistory(bool isOpportunities, String userId) =>
      historyLogs(isOpportunities).containsKey(userId);

  Future<void>? refreshLogs() => getCallLogs();

  Future<void> getCallLogs({
    bool forPagination = false,
    bool isOpportunities = false,
  }) async {
    if (isOpportunities) {
      opportunitiesSkip = forPagination
          ? (opportunitiesSkip + opportunitiesLimit) > opportunitiesTotalCount
              ? opportunitiesTotalCount
              : opportunitiesSkip + opportunitiesLimit
          : 0;
    } else {
      logsSkip = forPagination
          ? (logsSkip + logsLimit) > logsTotalCount
              ? logsTotalCount
              : logsSkip + logsLimit
          : 0;
    }
    var data = await _getCallLogs(
      limit: isOpportunities ? opportunitiesLimit : logsLimit,
      skip: isOpportunities ? opportunitiesSkip : logsSkip,
      isOpportunities: isOpportunities,
    );
    if (data == null) {
      if (forPagination) {
        _logsController(isOpportunities).loadFailed();
      } else {
        _logsController(isOpportunities).refreshFailed();
      }
      return;
    }

    var tempLogs = [...(isOpportunities ? opportunities : logs).flat];

    if (data.isNotEmpty) {
      if (forPagination) {
        tempLogs.addAll(data);
      } else {
        tempLogs = data;
      }

      if (isOpportunities) {
        opportunities = _viewModel.parseLogs(tempLogs);
        opportunitiesTotalCount = opportunities.totalCount;
      } else {
        logs = _viewModel.parseLogs(tempLogs);
        logsTotalCount = logs.totalCount;
      }

      if (forPagination) {
        _logsController(isOpportunities).loadComplete();
      } else {
        _logsController(isOpportunities).refreshCompleted();
        _logsController(isOpportunities).resetNoData();
      }
    } else {
      _logsController(isOpportunities).loadNoData();
      _logsController(isOpportunities).refreshToIdle();
    }
    if (isOpportunities) {
      if (isOpportunityLoading) {
        isOpportunityLoading = false;
      }
    } else {
      if (isLogsLoading) {
        isLogsLoading = false;
      }
    }
    update([LogsView.updateId]);
  }

  Future<void> getCallHistory(
    String userId, {
    bool forPagination = false,
    bool isOpportunities = false,
    bool isFirstLoad = false,
  }) async {
    if (isOpportunities) {
      historyOpportunitiesSkip = forPagination
          ? (historyOpportunitiesSkip + historyOpportunitiesLimit) >
                  historyOpportunitiesTotalCount
              ? historyOpportunitiesTotalCount
              : historyOpportunitiesSkip + historyOpportunitiesLimit
          : 0;
    } else {
      historySkip = forPagination
          ? (historySkip + historyLimit) > historyTotalCount
              ? historyTotalCount
              : historySkip + historyLimit
          : 0;
    }
    if (!forPagination && isFirstLoad) {
      if (isOpportunities) {
        isHistoryOpportunityLoading = true;
      } else {
        isHistoryLoading = true;
      }
    }
    update([HistoryView.updateId, LogsAndOpportunity.updateId]);

    var data = await _getCallLogs(
      userId: userId,
      isOpportunities: isOpportunities,
      limit: isOpportunities ? historyOpportunitiesLimit : historyLimit,
      skip: isOpportunities ? historyOpportunitiesSkip : historySkip,
    );
    if (data == null) {
      if (forPagination) {
        historyController(isOpportunities).loadFailed();
      } else {
        historyController(isOpportunities).refreshFailed();
      }
      return;
    }
    if (!historyLogs(isOpportunities).keys.contains(userId)) {
      historyLogs(isOpportunities)[userId] = [];
    }
    var tempLogs = [...historyLogs(isOpportunities)[userId]!];
    if (data.isNotEmpty) {
      if (forPagination) {
        tempLogs.addAll(data);
      } else {
        tempLogs = data;
      }
      historyLogs(isOpportunities)[userId] = [...tempLogs];
      if (isOpportunities) {
        historyOpportunitiesTotalCount =
            historyLogs(isOpportunities)[userId]!.length;
      } else {
        historyTotalCount = historyLogs(isOpportunities)[userId]!.length;
      }
      if (forPagination) {
        historyController(isOpportunities).loadComplete();
      } else {
        historyController(isOpportunities).refreshCompleted();
        historyController(isOpportunities).resetNoData();
      }
    } else {
      historyController(isOpportunities).loadNoData();
      historyController(isOpportunities).refreshToIdle();
    }
    if (isOpportunities) {
      isHistoryOpportunityLoading = false;
    } else {
      isHistoryLoading = false;
    }
    update([
      HistoryView.updateId,
      LogsAndOpportunity.updateId,
      ContactDetailsView.updateId,
    ]);
  }

  Future<LogsList?> _getCallLogs({
    bool isOpportunities = false,
    int limit = 20,
    int skip = 0,
    String? userId,
  }) =>
      _viewModel.getCallLogs(
        limit: limit,
        skip: skip,
        userId: userId,
        isOpportunities: isOpportunities,
      );
}
