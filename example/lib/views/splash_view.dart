import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  static const String route = Routes.splash;

  @override
  Widget build(BuildContext context) => GetBuilder<SplashController>(
        builder: (context) => const Scaffold(
          body: Center(
            child: Hero(
              key: ValueKey('AppLogo'),
              tag: 'app-logo',
              child: AppIcon(),
            ),
          ),
        ),
      );
}
