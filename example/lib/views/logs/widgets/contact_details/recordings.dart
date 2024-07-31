import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactRecordings extends StatelessWidget {
  const ContactRecordings({
    super.key,
    required this.userId,
  });

  final String userId;

  static const String updateId = 'isometrik-contact-recordings';

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        id: updateId,
        initState: (_) {
          var controller = Get.find<HomeController>();
          if (!controller.hasRecording(userId)) {
            Utility.updateLater(() {
              controller.getRecordings(
                userId: userId,
                firstLoad: true,
              );
            });
          }
        },
        builder: (controller) {
          if (controller.isRecordingsLoading) {
            return const Loader();
          }
          var recording = controller.allRecordings[userId] ?? [];
          return SmartRefresher(
            controller: controller.recordingsController,
            enablePullDown: true,
            enableTwoLevel: false,
            enablePullUp: true,
            footer: const LoadWidget(),
            onRefresh: () => controller.getRecordings(
              userId: userId,
            ),
            onLoading: () => controller.getRecordings(
              userId: userId,
              forPagination: true,
            ),
            child: recording.isEmpty
                ? const EmptyPlaceholder(CallEmpty.recordings)
                : CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: Dimens.edgeInsets12,
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) {
                              if (index.isOdd) {
                                return const Divider();
                              }
                              var itemIndex = index ~/ 2;
                              return RecordingCard(
                                recording[itemIndex % recording.length],
                              );
                            },
                            childCount: recording.length * 2 - 1,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
}
