import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectAccountView extends StatelessWidget {
  const SelectAccountView({super.key});
  static const String route = Routes.selectAccount;

  @override
  Widget build(BuildContext context) => GetBuilder<AuthController>(
        builder: (controller) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Select Account',
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
          body: ClientList(
            clients: controller.accounts,
            onTap: controller.selectAccount,
          ),
        ),
      );
}
