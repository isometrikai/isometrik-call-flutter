import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.label,
    this.title,
    this.showLogo = false,
    this.centerTitle = false,
    this.actions,
    this.isRounded = true,
    this.bottom,
    this.applyLeading = true,
  });

  final String? label;
  final Widget? title;
  final bool showLogo;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool isRounded;
  final PreferredSizeWidget? bottom;
  final bool applyLeading;

  @override
  Size get preferredSize => Size(
        Get.width,
        Dimens.sixty + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: isRounded
            ? BorderRadius.vertical(
                bottom: Radius.circular(
                  Dimens.sixteen,
                ),
              )
            : BorderRadius.zero,
        child: AppBar(
          title: title ??
              (showLogo && IsmCall.i.logo != null
                  ? UnconstrainedBox(child: IsmCall.i.logo)
                  : Text(
                      label ?? '',
                      style: context.textTheme.titleLarge,
                    )),
          automaticallyImplyLeading: applyLeading,
          centerTitle: centerTitle,
          actions: actions,
          bottom: bottom,
        ),
      );
}
