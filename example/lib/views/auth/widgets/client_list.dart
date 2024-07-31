import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientList extends StatelessWidget {
  const ClientList({
    super.key,
    required this.clients,
    this.onTap,
    this.nameBuilder,
  });

  final String Function(ApplicationModel)? nameBuilder;
  final List<ApplicationModel> clients;
  final void Function(ApplicationModel)? onTap;

  @override
  Widget build(BuildContext context) => ListView.separated(
        itemCount: clients.length,
        padding: Dimens.edgeInsets16,
        separatorBuilder: (_, __) => Dimens.boxHeight10,
        itemBuilder: (_, index) {
          var client = clients[index];
          return DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(Dimens.eight),
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.eight),
              ),
              contentPadding: Dimens.edgeInsets16_8,
              onTap: () => onTap?.call(client),
              title: Text(nameBuilder?.call(client) ?? client.name),
              leading: CustomImage.network(
                client.accountlogourl,
                name: nameBuilder?.call(client) ?? client.name,
                isProfileImage: true,
                dimensions: Dimens.forty,
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          );
        },
      );
}
