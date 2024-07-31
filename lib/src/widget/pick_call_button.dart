import 'package:flutter/material.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IsmCallAcceptButton extends StatelessWidget {
  const IsmCallAcceptButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => IsmCallTapHandler(
        onTap: onTap,
        child: SizedBox.square(
          dimension: IsmCallDimens.fifty,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: IsmCallColors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.call_rounded,
              color: IsmCallColors.white,
            ),
          ),
        ),
      );
}

class IsmCallRejectButton extends StatelessWidget {
  const IsmCallRejectButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => IsmCallTapHandler(
        onTap: onTap,
        child: SizedBox.square(
          dimension: IsmCallDimens.fifty,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: IsmCallColors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.call_end_rounded,
              color: IsmCallColors.white,
            ),
          ),
        ),
      );
}
