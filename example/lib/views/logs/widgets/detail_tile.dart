import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class DetailTile extends StatelessWidget {
  const DetailTile(this.log, {super.key});

  final CallLogsModel log;

  @override
  Widget build(BuildContext context) => ExpansionTile(
        tilePadding:
            log.isExpandable ? Dimens.edgeInsets0 : Dimens.edgeInsets0_4,
        leading: DecoratedBox(
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
        title: Text(
          log.isMissed ? 'Missed' : 'Incoming',
          style: context.textTheme.bodyMedium?.copyWith(
            color: log.isMissed ? CallColors.red : null,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        subtitle: !log.isMissed
            ? Text(
                log.duration.formatDuration,
                style: context.textTheme.labelSmall?.copyWith(
                  color: CallColors.unselected,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              )
            : null,
        dense: true,
        enabled: log.isExpandable,
        childrenPadding: Dimens.edgeInsets0_10,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              log.timestamp.formatDateTime,
              style: context.textTheme.labelSmall?.copyWith(
                color: CallColors.unselected,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            if (log.isExpandable) ...[
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: CallColors.unselected,
              ),
            ],
          ],
        ),
        visualDensity: VisualDensity.compact,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(Dimens.sixteen),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (log.recordings.isNotEmpty) ...[
                    ListView.separated(
                      itemCount: log.recordings.length,
                      padding: Dimens.edgeInsets12,
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => Dimens.boxHeight10,
                      itemBuilder: (_, index) =>
                          RecordingCard(log.recordings[index]),
                    ),
                  ],
                  if (log.recordings.isNotEmpty && log.notes.isNotEmpty) ...[
                    Divider(color: context.theme.dividerColor),
                  ],
                  if (log.notes.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(
                        left: Dimens.twelve,
                        top: Dimens.twelve,
                      ),
                      child: Text(
                        'Notes:',
                        style: context.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ListView.separated(
                      itemCount: log.notes.length,
                      padding: Dimens.edgeInsets12,
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => Dimens.boxHeight10,
                      itemBuilder: (_, index) => Text(log.notes[index].note),
                    ),
                    Padding(
                      padding: Dimens.edgeInsets12.copyWith(top: 0),
                      child: Text(
                        log.notes.first.userFullName,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.theme.unselectedWidgetColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
}
