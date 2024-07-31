import 'package:call_qwik_example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.isDialog = true,
    this.message,
  });

  final bool isDialog;
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Card(
          elevation: isDialog ? null : 0,
          color: context.theme.cardColor,
          child: Padding(
            padding: isDialog && message != null
                ? Dimens.edgeInsets16
                : Dimens.edgeInsets8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: context.textTheme.labelLarge?.color,
                  strokeWidth: 3,
                ),
                if (isDialog && message != null) ...[
                  Dimens.boxWidth16,
                  Text(
                    message!,
                    style: context.textTheme.labelLarge,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
}

class LoadWidget extends StatelessWidget {
  const LoadWidget({super.key});

  @override
  Widget build(BuildContext context) => CustomFooter(
        builder: (_, mode) {
          if (mode == LoadStatus.loading) {
            return Center(
              child: Padding(
                padding: Dimens.edgeInsets16,
                child: defaultTargetPlatform == TargetPlatform.iOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
}
