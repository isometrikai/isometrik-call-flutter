import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class EmailLoginView extends StatelessWidget {
  const EmailLoginView({super.key});

  static const String route = Routes.emailLogin;

  @override
  Widget build(BuildContext context) => GetBuilder<AuthController>(
        builder: (controller) => Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: Dimens.edgeInsets16,
              child: Form(
                key: controller.emailLoginKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // const Spacer(),
                    Text(
                      'Enter Your Email',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Dimens.boxHeight20,
                    Text(
                      'CallQwik will need to verify your account.',
                      style: context.textTheme.bodySmall,
                    ),
                    Dimens.boxHeight8,
                    Text(
                      'What\'s your email id?',
                      style: context.textTheme.bodyMedium,
                    ),
                    Dimens.boxHeight32,
                    CustomInputField.email(
                      controller: controller.emailTEC,
                      hintText: 'Enter Email',
                      validator: CallValidators.emailValidator,
                    ),
                    Dimens.boxHeight16,
                    Obx(
                      () => CustomInputField.password(
                        controller: controller.passwordTEC,
                        hintText: 'Password',
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
                    Dimens.boxHeight32,
                    TapHandler(
                      onTap: RouteManagement.goToForgotPassword,
                      child: Padding(
                        padding: Dimens.edgeInsets4,
                        child: Text(
                          'Forgot Password?',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    // const Spacer(),
                    IsmCallButton(
                      label: 'Login',
                      onTap: controller.emailLogin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
