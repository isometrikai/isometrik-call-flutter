import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.body,
    this.successLabel,
    this.onSuccess,
  });

  final String title;
  final String body;
  final String? successLabel;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(),
        child: SizedBox(
          width: Get.width,
          child: Padding(
            padding: Dimens.edgeInsets8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: SizedBox.square(dimension: Dimens.twentyFour),
                    ),
                    Text(
                      title,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                Dimens.boxHeight16,
                Text(
                  body,
                  style: context.textTheme.bodyMedium,
                ),
                Dimens.boxHeight16,
                Row(
                  children: [
                    Flexible(
                      child: IsmCallButton(
                        label: successLabel ?? 'Ok',
                        onTap: () {
                          Get.back();
                          onSuccess?.call();
                        },
                      ),
                    ),
                    Dimens.boxWidth16,
                    Flexible(
                      child: IsmCallButton.outlined(
                        label: 'Cancel',
                        onTap: Get.back,
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
