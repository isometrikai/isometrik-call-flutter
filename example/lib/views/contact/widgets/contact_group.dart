import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmContactGroup extends StatelessWidget {
  const IsmContactGroup({
    super.key,
    required this.contacts,
  });

  final ContactsList contacts;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              contacts.first.name.split('').first.toUpperCase(),
              style: context.textTheme.labelSmall?.copyWith(
                color: CallColors.unselected,
              ),
            ),
          ),
          Dimens.boxHeight4,
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.canvasColor,
              borderRadius: BorderRadius.circular(Dimens.sixteen),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: contacts.length,
              padding: Dimens.edgeInsets8,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                var contact = contacts[index % contacts.length];
                return ContactTile(
                  contact,
                  onTap: () {
                    RouteManagement.goToContactDetails(contact: contact);
                    Utility.openBottomSheet(
                      ContactDetailSheet(contact),
                    );
                  },
                );
              },
            ),
          )
        ],
      );
}
