import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickImageSheet extends StatelessWidget {
  const PickImageSheet({
    super.key,
    this.onPickImage,
  });

  final void Function(ImageSource)? onPickImage;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.theme.appBarTheme.backgroundColor,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: Dimens.edgeInsets0,
              onTap: () {
                Get.back<void>();
                onPickImage?.call(ImageSource.camera);
              },
              leading: SizedBox.square(
                dimension: Dimens.forty,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Text(
                'Camera',
              ),
            ),
            ListTile(
              contentPadding: Dimens.edgeInsets0,
              onTap: () {
                Get.back<void>();
                onPickImage?.call(ImageSource.gallery);
              },
              leading: SizedBox.square(
                dimension: Dimens.forty,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purpleAccent,
                  ),
                  child: Icon(
                    Icons.photo_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Text(
                'Gallery',
              ),
            ),
          ],
        ),
      );
}
