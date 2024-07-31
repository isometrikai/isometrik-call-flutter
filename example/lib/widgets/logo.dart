import 'package:call_qwik_example/res/res.dart';
import 'package:call_qwik_example/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) => const CustomImage.svg(
        AssetConstants.appIconSvg,
        fromPackage: false,
      );
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) => const CustomImage.svg(
        AssetConstants.logoSvg,
        fromPackage: false,
      );
}
