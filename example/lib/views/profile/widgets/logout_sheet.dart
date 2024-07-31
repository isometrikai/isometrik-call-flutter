import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class LogoutSheet extends StatelessWidget {
  const LogoutSheet({
    super.key,
    this.onLogout,
    this.onCancel,
  });

  final VoidCallback? onLogout;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.appBarTheme.backgroundColor,
        ),
        child: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: Dimens.edgeInsets16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Logout',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Are you Sure?',
                  style: context.textTheme.bodyLarge,
                ),
                Dimens.boxHeight16,
                Row(
                  children: [
                    Flexible(
                      child: IsmCallButton(
                        label: 'Logout',
                        onTap: onLogout,
                      ),
                    ),
                    Dimens.boxWidth16,
                    Flexible(
                      child: IsmCallButton.secondary(
                        label: 'Cancel',
                        onTap: onCancel,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
