import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.items,
    required this.iconsBuilder,
    required this.selectedIndex,
    this.onTap,
  });

  final List<NavItem> items;
  final NavIconBuilder iconsBuilder;
  final int selectedIndex;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimens.sixteen),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onTap,
          items: items.indexed
              .map(
                (e) => BottomNavigationBarItem(
                  icon: iconsBuilder(context, e.$1),
                  label: e.$2.label,
                ),
              )
              .toList(),
        ),
      );
}
