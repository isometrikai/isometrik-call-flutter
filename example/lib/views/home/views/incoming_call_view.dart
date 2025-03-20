import 'dart:math';

import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class IncomingCallView extends StatefulWidget {
  IncomingCallView({
    super.key,
    IncomingCallArgument? argument,
  })  : assert(Get.arguments.runtimeType.toString().contains('Map'),
            'Only data of type Map can be passed to arguments for IsmIncomingCallView. You can check argument class `IsmIncomingCallArgument`'),
        argument = argument ??
            IncomingCallArgument.fromMap(
              Get.arguments as Map<String, dynamic>,
            );

  final IncomingCallArgument argument;

  static const String route = Routes.incomingCall;

  @override
  State<IncomingCallView> createState() => _IncomingCallViewState();
}

class _IncomingCallViewState extends State<IncomingCallView> {
  static final initialPosition = Dimens.eighty;

  static final triggerThreshold = Get.height * 0.3;

  bool actionTriggered = false;

  final RxDouble _acceptPosition = initialPosition.obs;
  double get acceptPosition => _acceptPosition.value;
  set acceptPosition(double value) {
    if (value == acceptPosition) {
      return;
    }
    _acceptPosition.value = value;
  }

  final RxDouble _rejectPosition = initialPosition.obs;
  double get rejectPosition => _rejectPosition.value;
  set rejectPosition(double value) {
    if (value == rejectPosition) {
      return;
    }
    _rejectPosition.value = value;
  }

  final RxBool _showAcceptArrow = true.obs;
  bool get showAcceptArrow => _showAcceptArrow.value;
  set showAcceptArrow(bool value) {
    if (value == showAcceptArrow) {
      return;
    }
    _showAcceptArrow.value = value;
  }

  double _position(double value) => min(
        max(
          value,
          initialPosition,
        ),
        Get.height * 0.4,
      );

  void _updateAcceptPosition(DragUpdateDetails details) {
    showAcceptArrow = false;
    acceptPosition = _position(acceptPosition - details.delta.dy);
    if (acceptPosition > triggerThreshold && !actionTriggered) {
      Get.back();
      actionTriggered = true;
      IsmCallHelper.pickCall();
    }
  }

  void _resetAccept(DragEndDetails _) {
    showAcceptArrow = true;
    acceptPosition = Dimens.eighty;
  }

  void _updateRejectPosition(DragUpdateDetails details) {
    showAcceptArrow = false;
    rejectPosition = _position(rejectPosition - details.delta.dy);
    if (rejectPosition > triggerThreshold && !actionTriggered) {
      Get.back();
      actionTriggered = true;
      IsmCallHelper.endCall();
    }
  }

  void _resetReject(DragEndDetails _) {
    showAcceptArrow = true;
    rejectPosition = Dimens.eighty;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: [
            if (!widget.argument.isAudioOnly) ...[
              Positioned.fill(
                child: CustomImage.network(
                  widget.argument.imageUrl,
                  name: widget.argument.name,
                ),
              ),
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.applyOpacity(0.8),
                ),
              ),
            ],
            SafeArea(
              child: Padding(
                padding: Dimens.edgeInsets32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Incoming Call',
                      style: context.textTheme.labelMedium,
                    ),
                    Dimens.boxHeight16,
                    CustomImage.network(
                      widget.argument.imageUrl,
                      name: widget.argument.name,
                      isProfileImage: true,
                      dimensions: Dimens.oneHundredTwenty,
                    ),
                    Dimens.boxHeight16,
                    Text(
                      widget.argument.name,
                      style: context.textTheme.titleLarge,
                    ),
                    Dimens.boxHeight8,
                    Text(
                      widget.argument.ip,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: CallColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => AnimatedPositioned(
                bottom: rejectPosition,
                left: Get.width * 0.25,
                duration: Duration.zero,
                child: GestureDetector(
                  onVerticalDragUpdate: _updateRejectPosition,
                  onVerticalDragEnd: _resetReject,
                  child: const RejectButton(),
                ),
              ),
            ),
            Obx(
              () => AnimatedPositioned(
                bottom: acceptPosition,
                right: Get.width * 0.25,
                duration: Duration.zero,
                child: GestureDetector(
                  onVerticalDragUpdate: _updateAcceptPosition,
                  onVerticalDragEnd: _resetAccept,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showAcceptArrow) ...[
                        ...List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color:
                                  Colors.white.applyOpacity(index * 0.2 + 0.2),
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                      ],
                      const AcceptButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
