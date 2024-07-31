import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  static const String route = Routes.resetPassword;

  @override
  Widget build(BuildContext context) => GetBuilder<AuthController>(
        initState: (_) {
          var controller = Get.find<AuthController>();
          Utility.updateLater(() {
            controller.hidePassword = true;
            controller.hideNewPassword = true;
          });
        },
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
              key: controller.resetPasswordKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'Create New Password',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Dimens.boxHeight20,
                  Padding(
                    padding: Dimens.edgeInsets20_0,
                    child: Text(
                      'Please enter your password sent to you on your email and create a new password',
                      style: context.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Dimens.boxHeight32,
                  Obx(
                    () => CustomInputField.email(
                      controller: controller.newPasswordTEC,
                      label: 'New Password',
                      obscureText: controller.hidePassword,
                      validator: CallValidators.passwordValidator,
                      suffixIcon: TapHandler(
                        onTap: controller.togglePasswordVisibility,
                        child: controller.hidePassword
                            ? const Icon(
                                Icons.visibility_outlined,
                              )
                            : const Icon(
                                Icons.visibility_off_outlined,
                              ),
                      ),
                    ),
                  ),
                  Dimens.boxHeight16,
                  Obx(
                    () => CustomInputField.email(
                      controller: controller.confirmPasswordTEC,
                      label: 'Confirm Password',
                      hintText: 'Confirm New Password',
                      obscureText: controller.hideNewPassword,
                      validator: (value) => CallValidators.passwordValidator(
                        value,
                        controller.passwordTEC.text,
                      ),
                      suffixIcon: TapHandler(
                        onTap: controller.toggleNewPasswordVisibility,
                        child: controller.hideNewPassword
                            ? const Icon(
                                Icons.visibility_outlined,
                              )
                            : const Icon(
                                Icons.visibility_off_outlined,
                              ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IsmCallButton(
                    label: 'Proceed',
                    onTap: controller.resetPassword,
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
