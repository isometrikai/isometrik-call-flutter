import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  static const String route = Routes.forgotPassword;

  @override
  Widget build(BuildContext context) => GetBuilder<AuthController>(
        builder: (controller) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: Dimens.edgeInsets16,
            child: Form(
              key: controller.forgotPasswordKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'Forgot Password',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Dimens.boxHeight20,
                  Padding(
                    padding: Dimens.edgeInsets20_0,
                    child: Text(
                      'Please enter the registered email with CallQwik to receive verification code.',
                      style: context.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Dimens.boxHeight32,
                  CustomInputField.email(
                    controller: controller.emailTEC,
                    hintText: 'Enter Email',
                    validator: CallValidators.emailValidator,
                  ),
                  const Spacer(),
                  IsmCallButton(
                    label: 'Proceed',
                    onTap: controller.onForgotPassword,
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
