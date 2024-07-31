import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class RecordingCard extends StatelessWidget {
  const RecordingCard(this.recording, {super.key});

  final RecordingModel recording;

  @override
  Widget build(BuildContext context) => Padding(
        padding: Dimens.edgeInsets4,
        child: TapHandler(
          onTap: () => RouteManagement.goToVideoView(recording.recordingUrl),
          child: Row(
            children: [
              SizedBox.square(
                dimension: Dimens.sixty,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.theme.canvasColor,
                    borderRadius: BorderRadius.circular(Dimens.sixteen),
                  ),
                  child: const Center(
                    child: CustomImage.svg(
                      AssetConstants.audio,
                      fromPackage: false,
                    ),
                  ),
                ),
              ),
              Dimens.boxWidth10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${recording.startedAt.recordingName}.mp4',
                      style: context.textTheme.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${recording.duration.formatTime} sec',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.theme.unselectedWidgetColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow_rounded),
            ],
          ),
        ),
      );
}
