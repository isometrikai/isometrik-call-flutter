import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoteTile extends StatelessWidget {
  const NoteTile(this.note,
      {super.key, this.showFullNote = false, this.userId = ''});

  final NoteModel note;
  final String userId;
  final bool showFullNote;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.maxFinite,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.appBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(Dimens.sixteen),
          ),
          child: Padding(
            padding: Dimens.edgeInsets16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showFullNote) ...[
                  Text(
                    note.note.trim(),
                    style: context.textTheme.bodyLarge,
                  ),
                ] else ...[
                  ReadMoreText(
                    note.note.trim(),
                    style: context.textTheme.bodyLarge,
                    shouldToggle: false,
                    onTap: () => RouteManagement.goToSingleNote(
                      userId: userId,
                      note: note,
                    ),
                  ),
                ],
                Dimens.boxHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      note.userFullName,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.theme.disabledColor,
                      ),
                    ),
                    Text(
                      note.timestamp.formatDateTime,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.theme.disabledColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
