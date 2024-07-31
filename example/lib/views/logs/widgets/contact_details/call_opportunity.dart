import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LogsAndOpportunity extends StatelessWidget {
  const LogsAndOpportunity({
    super.key,
    required this.isOpportunities,
    required this.userId,
  });

  final bool isOpportunities;
  final String userId;

  static const String updateId = 'isometrik-logs-opportunity';

  @override
  Widget build(BuildContext context) => GetBuilder<LogsController>(
        id: updateId,
        initState: (_) {
          var controller = Get.find<LogsController>();
          if (!controller.hasHistory(isOpportunities, userId)) {
            Utility.updateLater(() {
              controller.getCallHistory(
                userId,
                isOpportunities: isOpportunities,
                isFirstLoad: true,
              );
            });
          }
        },
        builder: (controller) {
          if (controller.isHistoryLogsLoading(isOpportunities)) {
            return const Loader();
          }
          var logs = controller.historyLogs(isOpportunities)[userId] ?? [];
          return SmartRefresher(
            controller: controller.historyController(isOpportunities),
            enablePullDown: true,
            enableTwoLevel: false,
            enablePullUp: true,
            footer: const LoadWidget(),
            onRefresh: () => controller.getCallHistory(
              userId,
              isOpportunities: isOpportunities,
            ),
            onLoading: () => controller.getCallHistory(
              userId,
              isOpportunities: isOpportunities,
              forPagination: true,
            ),
            child: logs.isEmpty
                ? isOpportunities
                    ? const EmptyPlaceholder(CallEmpty.missedOpprtunity)
                    : const EmptyPlaceholder(CallEmpty.logs)
                : CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: Dimens.edgeInsets16,
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) {
                              if (index.isOdd) {
                                return const Divider(height: 1, thickness: 1);
                              }
                              var itemIndex = index ~/ 2;
                              return DetailTile(
                                logs[itemIndex % logs.length],
                              );
                            },
                            childCount: logs.length * 2 - 1,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
}
