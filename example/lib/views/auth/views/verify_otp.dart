import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({super.key});

  static const String route = Routes.verifyOtp;

  @override
  Widget build(BuildContext context) => GetBuilder<AuthController>(
        initState: (_) {
          Get.find<AuthController>().startTimer();
        },
        builder: (controller) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: Dimens.edgeInsets16,
              child: Form(
                key: controller.otpFormKey,
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      'Enter Verification Code',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Dimens.boxHeight20,
                    Text(
                      'Enter the verification code sent to ${controller.phoneTEC.text.mask}',
                      style: context.textTheme.bodySmall,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    Dimens.boxHeight20,
                    Text(
                      'Enter 6 Digit Code',
                      style: context.textTheme.bodyMedium,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    Dimens.boxHeight20,
                    Padding(
                      padding: Dimens.edgeInsets16_0,
                      child: PinCodeTextField(
                        enableActiveFill: true,
                        enablePinAutofill: false,
                        autoFocus: true,
                        autoUnfocus: true,
                        autoDismissKeyboard: true,
                        autoDisposeControllers: false,
                        controller: controller.otpTEC,
                        appContext: context,
                        keyboardType: TextInputType.phone,
                        length: 6,
                        onCompleted: (value) {
                          controller.agentLogin();
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(20),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: CallColors.background,
                          activeColor: CallColors.secondary,
                          selectedColor: CallColors.primary,
                          inactiveColor: CallColors.grey,
                          selectedFillColor: CallColors.background,
                          inactiveFillColor: CallColors.background,
                        ),
                      ),
                    ),
                    Dimens.boxHeight20,
                    Text(
                      'Didn\'t receive code?',
                      style: context.textTheme.bodySmall,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    Obx(
                      () => Text(
                        'You may request a new code in ${controller.time.formatTime}',
                        style: context.textTheme.bodySmall,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    IsmCallButton(
                      label: 'Verify',
                      onTap: controller.agentLogin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
