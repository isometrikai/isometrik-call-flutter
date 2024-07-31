import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class ContactDetailSheet extends StatelessWidget {
  const ContactDetailSheet(
    this.contact, {
    super.key,
  });

  final ContactsModel contact;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.appBarTheme.backgroundColor,
        ),
        child: Padding(
          padding: Dimens.edgeInsets16,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const IconButton(
                      onPressed: null,
                      icon: Dimens.box0,
                    ),
                    Text(
                      'Contact Information',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),
                Dimens.boxHeight16,
                CustomImage.network(
                  contact.userProfileUrl,
                  name: contact.name,
                  isProfileImage: true,
                  dimensions: Dimens.hundred,
                ),
                Dimens.boxHeight16,
                Text(
                  contact.name,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Dimens.boxHeight4,
                Text(
                  contact.phoneNumber,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: CallColors.unselected,
                  ),
                ),
                Dimens.boxHeight4,
                Text(
                  contact.email,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: CallColors.unselected,
                  ),
                ),
                if (contact.notes.trim().isNotEmpty) ...[
                  const Divider(),
                  Dimens.boxHeight8,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Notes:',
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      contact.notes,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: CallColors.unselected,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
                Dimens.boxHeight20,
                Row(
                  children: [
                    Flexible(
                      child: IsmCallButton(
                        label: 'Call',
                        onTap: () => Utility.launchURL('tel:${contact.phone}'),
                      ),
                    ),
                    Dimens.boxWidth16,
                    Flexible(
                      child: IsmCallButton.secondary(
                        label: 'Message',
                        onTap: () => Utility.launchURL('sms:${contact.phone}'),
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
