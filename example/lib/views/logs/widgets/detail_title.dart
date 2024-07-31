import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsTitle extends StatelessWidget {
  const DetailsTitle({
    super.key,
    required this.log,
    this.animationValue = 1,
    this.name = '',
  });

  final CallLogsModel? log;
  final double animationValue;
  final String name;

  int get length => (40 * animationValue).clamp(20, 60).ceil();

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImage.network(
            log?.imageUrl ?? '',
            name: log?.name ?? name,
            isProfileImage: true,
            dimensions: Dimens.forty,
          ),
          Dimens.boxWidth10,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  log?.name ?? name,
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  log?.subtitle.split('').take(length).join() ?? '',
                  style: context.textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
}
