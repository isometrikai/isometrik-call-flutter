import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  static const String route = Routes.notes;

  static const String updateId = 'notes-iew';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppBar(
          label: 'Notes',
          isRounded: false,
        ),
        body: GetBuilder<HomeController>(
          id: updateId,
          builder: (controller) => SmartRefresher(
            controller: controller.notesController,
            enablePullDown: true,
            enableTwoLevel: false,
            enablePullUp: true,
            footer: const IsmCallLoadWidget(),
            onRefresh: () => controller.getNotes(
              userId: controller.userInfoModel?.userId ?? '',
            ),
            onLoading: () => controller.getNotes(
              userId: controller.userInfoModel?.userId ?? '',
              forPagination: true,
            ),
            child: controller.notes == null || controller.notes!.isEmpty
                ? Center(
                    child: Text(
                      'No Notes found',
                      style: context.textTheme.titleLarge,
                    ),
                  )
                : ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: controller.notes!.length,
                    padding: Dimens.edgeInsets16,
                    separatorBuilder: (_, __) => Dimens.boxHeight10,
                    itemBuilder: (_, index) {
                      final note =
                          controller.notes![index % controller.notes!.length];
                      return NoteTile(note);
                    },
                  ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets16,
            child: IsmCallButton(
              label: 'Add Notes',
              onTap: () =>
                  RouteManagement.goToAddNotes(IsmCallHelper.ongoingMeetingId),
            ),
          ),
        ),
      );
}
