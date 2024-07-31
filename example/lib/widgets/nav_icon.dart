import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';

class NavIcon extends StatelessWidget {
  const NavIcon(
    this.item, {
    super.key,
    required this.isSelected,
    required this.agent,
  });

  final NavItem item;
  final bool isSelected;
  final AgentDetailsModel? agent;

  @override
  Widget build(BuildContext context) {
    if (item != NavItem.profile) {
      return _SvgIcon(
        item,
        isSelected: isSelected,
      );
    }
    // if (agentDetail == null || config!.userConfig.userProfile.isNullOrEmpty) {
    //   return _SvgIcon(
    //     item,
    //     isSelected: isSelected,
    //   );
    // }
    return CustomImage.network(
      agent?.userProfileUrl ?? '',
      name: agent?.name ?? '',
      isProfileImage: true,
      dimensions: Dimens.twentyFour,
      padding: Dimens.edgeInsets2,
      border: isSelected
          ? Border.all(
              color: CallColors.white,
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            )
          : null,
    );
  }
}

class _SvgIcon extends StatelessWidget {
  const _SvgIcon(
    this.item, {
    required this.isSelected,
  });

  final NavItem item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => CustomImage.svg(
        isSelected ? item.activeIcon : item.icon,
        fromPackage: false,
      );
}
