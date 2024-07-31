import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallNoVideoWidget extends StatelessWidget {
  const IsmCallNoVideoWidget({
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
            IsmCallImage.network(
              imageUrl,
              name: name,
              isProfileImage: true,
              dimensions:
                  isLargeVideo ? IsmCallDimens.hundred : IsmCallDimens.fifty,
              showError: false,
            ),
            IsmCallDimens.boxHeight10,
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
