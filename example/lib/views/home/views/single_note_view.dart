import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleNoteView extends StatelessWidget {
  SingleNoteView({super.key})
      : userId = Get.arguments['userId'],
        note = NoteModel.fromMap(Get.arguments['note']);

  final String userId;
  final NoteModel note;

  static const String route = Routes.singleNote;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: DetailsTitle(
            log: Get.find<LogsController>().historyLogs(false)[userId]!.first,
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: Dimens.edgeInsets16,
          child: NoteTile(
            note,
            showFullNote: true,
          ),
        ),
      );
}
