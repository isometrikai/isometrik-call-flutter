import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogsGroup extends StatelessWidget {
  const LogsGroup({
    super.key,
    required this.logs,
    this.isOpportunities = false,
  });

  final LogsList logs;
  final bool isOpportunities;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            logs.first.timestamp.relativeDate,
            style: context.textTheme.labelSmall?.copyWith(
              color: CallColors.unselected,
            ),
          ),
          Dimens.boxHeight4,
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.canvasColor,
              borderRadius: BorderRadius.circular(Dimens.sixteen),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: logs.length,
              padding: Dimens.edgeInsets8,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                var log = logs[index % logs.length];
                return TapHandler(
                  onTap: () => RouteManagement.goToContactDetails(log: log),
                  child: LogTile(
                    log,
                    isOpportunities: isOpportunities,
                  ),
                );
              },
            ),
          )
        ],
      );
}
