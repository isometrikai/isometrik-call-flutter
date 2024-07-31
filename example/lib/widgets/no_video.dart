import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoVideoWidget extends StatelessWidget {
  const NoVideoWidget({
    super.key,
    required this.imageUrl,
    this.name = 'U',
    this.isLargeVideo = false,
  }) : assert(name.length > 0, 'Length of the name should be atleast 1');
  final String name;
  final String imageUrl;
  final bool isLargeVideo;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImage.network(
              imageUrl,
              name: name,
              isProfileImage: true,
              dimensions: isLargeVideo ? Dimens.hundred : Dimens.fifty,
              showError: false,
            ),
            Dimens.boxHeight10,
            Text(
              name,
              style: isLargeVideo
                  ? context.textTheme.titleMedium
                  : context.textTheme.bodySmall,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
}
