import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class LogTile extends StatelessWidget {
  const LogTile(
    this.log, {
    super.key,
    this.isOpportunities = false,
  });

  final CallLogsModel log;
  final bool isOpportunities;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          CustomImage.network(
            log.imageUrl,
            name: log.name,
            isProfileImage: true,
            dimensions: Dimens.forty,
          ),
          Dimens.boxWidth8,
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        log.name,
                        style: context.textTheme.bodyMedium?.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        log.ip,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: CallColors.unselected,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        log.state,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: log.color,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        (isOpportunities ? log.timestamp : log.startTime)
                            .formatTime,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: CallColors.unselected,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
