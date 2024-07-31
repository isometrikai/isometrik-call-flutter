import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile(
    this.log, {
    super.key,
  });

  final CallLogsModel log;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: Dimens.edgeInsets8,
              child: log.isMissed
                  ? const Icon(
                      Icons.call_missed_rounded,
                      color: CallColors.red,
                    )
                  : const Icon(
                      Icons.call_received_rounded,
                    ),
            ),
          ),
          Dimens.boxWidth8,
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.isMissed ? 'Missed' : 'Incoming',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: log.isMissed ? CallColors.red : null,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      if (!log.isMissed) ...[
                        Text(
                          log.duration.formatDuration,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: CallColors.unselected,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        log.startTime.formatDateTime,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: CallColors.unselected,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      // const Icon(
                      //   Icons.keyboard_arrow_down_rounded,
                      //   color: CallColors.unselected,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
