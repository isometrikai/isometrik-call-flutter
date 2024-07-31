import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String route = Routes.home;

  @override
  Widget build(BuildContext context) => GetX<HomeController>(
        builder: (controller) => Scaffold(
          body: !controller.callInitialized
              ? const Center(
                  child: Loader(),
                )
              : Obx(
                  () => NavItem.screens[controller.selectedNavIndex],
                ),
          bottomNavigationBar: Obx(
            () => NavBar(
              items: NavItem.visible,
              onTap: controller.onTapNavItam,
              selectedIndex: controller.selectedNavIndex,
              iconsBuilder: (context, index) => NavIcon(
                NavItem.visible[index],
                isSelected: index == controller.selectedNavIndex,
                agent: controller.agent,
              ),
            ),
          ),
        ),
      );
}
