import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectApplicationView extends StatelessWidget {
  SelectApplicationView({
    super.key,
    String? clientName,
  }) : _clientName = clientName ?? Get.arguments;

  final String _clientName;

  static const String route = Routes.selectApplication;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Application',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: context.theme.scaffoldBackgroundColor,
        ),
        body: GetBuilder<AuthController>(
          builder: (controller) => ClientList(
            clients: controller.applications(_clientName),
            nameBuilder: (client) => client.projectName,
            onTap: controller.selectApplication,
          ),
        ),
      );
}
