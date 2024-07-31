import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class AddNoteView extends StatelessWidget {
  AddNoteView({super.key}) : meetingId = Get.arguments as String?;

  final String? meetingId;

  static const String route = Routes.addNotes;
  static const String updateId = 'add-notes-view';

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        builder: (controller) => Scaffold(
          appBar: const CustomAppBar(
            label: 'Add Notes',
            isRounded: false,
          ),
          body: Padding(
            padding: Dimens.edgeInsets16,
            child: Form(
              key: controller.addNoteKey,
              child: CustomInputField(
                controller: controller.notesTEC,
                label: 'Add notes',
                hintText: 'Enter notes',
                minLines: 6,
                maxLines: 10,
                validator: CallValidators.userName,
                textInputType: TextInputType.multiline,
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: Dimens.edgeInsets16,
              child: IsmCallButton(
                label: 'Save',
                onTap: () => controller.addNote(meetingId: meetingId),
              ),
            ),
          ),
        ),
      );
}

class AddNoteSheet extends StatelessWidget {
  const AddNoteSheet({
    super.key,
    this.userId,
    this.meetingId,
    this.onSuccess,
  });

  final String? userId;
  final String? meetingId;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        builder: (controller) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppBar(
              label: 'Add Notes',
              isRounded: false,
              applyLeading: false,
              actions: [
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(
                    Icons.close_rounded,
                  ),
                ),
              ],
            ),
            Padding(
              padding: Dimens.edgeInsets16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: controller.addNoteKey,
                    child: CustomInputField(
                      controller: controller.notesTEC,
                      label: 'Add notes',
                      hintText: 'Enter notes',
                      minLines: 6,
                      maxLines: 10,
                      validator: CallValidators.userName,
                      textInputType: TextInputType.multiline,
                    ),
                  ),
                  Dimens.boxHeight32,
                  IsmCallButton(
                    label: 'Save',
                    onTap: () => controller.addNote(
                      meetingId: meetingId,
                      userId: userId,
                      onSuccess: onSuccess,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
