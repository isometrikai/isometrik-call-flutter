import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactNotes extends StatelessWidget {
  const ContactNotes({
    super.key,
    required this.userId,
  });

  final String userId;

  static const String updateId = 'isometrik-contact-notes';

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        id: updateId,
        initState: (_) {
          var controller = Get.find<HomeController>();
          if (!controller.hasNotes(true, userId)) {
            Utility.updateLater(() {
              controller.getNotes(
                userId: userId,
                isDetails: true,
                firstLoad: true,
              );
            });
          }
        },
        builder: (controller) {
          if (controller.isDetailsNotesLoading) {
            return const Loader();
          }
          var notes = controller.allNotes[userId] ?? [];
          return SmartRefresher(
            controller: controller.detailsNotesController,
            enablePullDown: true,
            enableTwoLevel: false,
            enablePullUp: true,
            footer: const LoadWidget(),
            onRefresh: () => controller.getNotes(
              userId: userId,
              isDetails: true,
            ),
            onLoading: () => controller.getNotes(
              userId: userId,
              isDetails: true,
              forPagination: true,
            ),
            child: notes.isEmpty
                ? const EmptyPlaceholder(CallEmpty.notes)
                : CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: Dimens.edgeInsets16,
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, index) {
                              if (index.isOdd) {
                                return Dimens.boxHeight10;
                              }
                              var itemIndex = index ~/ 2;
                              return NoteTile(
                                notes[itemIndex % notes.length],
                                userId: userId,
                              );
                            },
                            childCount: notes.length * 2 - 1,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
}
