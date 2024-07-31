import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  const ContactTile(
    this.contact, {
    super.key,
    this.onTap,
  });

  final ContactsModel contact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: Dimens.edgeInsets0,
        onTap: onTap,
        leading: CustomImage.network(
          contact.userProfileUrl,
          name: contact.name,
          isProfileImage: true,
          dimensions: Dimens.forty,
        ),
        title: Text(contact.name),
      );
}
