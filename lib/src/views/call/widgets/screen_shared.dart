import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallScreenShared extends StatelessWidget {
  const IsmCallScreenShared({
    super.key,
    this.onStop,
  });

  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Padding(
            padding: IsmCallDimens.edgeInsets32,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You are sharing your screen',
                  style: context.textTheme.titleMedium,
                ),
                IsmCallDimens.boxHeight32,
                IsmCallButton(
                  label: 'Stop sharing',
                  onTap: onStop,
                ),
              ],
            ),
          ),
        ),
      );
}
