import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';

class AcceptButton extends StatelessWidget {
  const AcceptButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => TapHandler(
        onTap: onTap,
        child: SizedBox.square(
          dimension: Dimens.fifty,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: CallColors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.call_rounded,
              color: CallColors.white,
            ),
          ),
        ),
      );
}

class RejectButton extends StatelessWidget {
  const RejectButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => TapHandler(
        onTap: onTap,
        child: SizedBox.square(
          dimension: Dimens.fifty,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: CallColors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.call_end_rounded,
              color: CallColors.white,
            ),
          ),
        ),
      );
}
