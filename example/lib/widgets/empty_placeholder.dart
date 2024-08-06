import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder(
    this.type, {
    super.key,
  });

  final CallEmpty type;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: Dimens.edgeInsets40_0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImage.svg(
                type.icon,
                color: CallColors.unselected,
                fromPackage: false,
                dimensions: Dimens.seventy,
              ),
              Dimens.boxHeight16,
              Text(
                type.label,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.iconColor,
                ),
                textAlign: TextAlign.center,
              ),
              Dimens.boxHeight16,
              Text(
                type.description,
                style: context.textTheme.labelMedium?.copyWith(
                  color: CallColors.unselected,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
