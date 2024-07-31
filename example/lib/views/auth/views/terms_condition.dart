import 'package:call_qwik_example/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class TermsConditionView extends StatelessWidget {
  const TermsConditionView({super.key});

  static const String route = Routes.termsCondition;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets16,
            child: GetBuilder<TermsController>(
              builder: (controller) => Column(
                children: [
                  Dimens.boxHeight24,
                  const Hero(
                    key: ValueKey('AppLogo'),
                    tag: 'app-logo',
                    child: AppIcon(),
                  ),
                  const Spacer(),
                  Text(
                    'Add an account',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Dimens.boxHeight10,
                  Text.rich(
                    TextSpan(
                      text: 'Read our ',
                      children: [
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(
                            text:
                                ' Tap “Agree and continue” To accept the Termas off Service'),
                      ],
                    ),
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  Dimens.boxHeight20,
                  const _LanguageButton(),
                  const Spacer(flex: 2),
                  IsmCallButton(
                    label: 'Agree and Continue',
                    onTap: controller.goToLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.primaryColor,
          borderRadius: BorderRadius.circular(Dimens.forty),
        ),
        child: Padding(
          padding: Dimens.edgeInsets8,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded),
              Dimens.boxWidth4,
              const Text('English'),
              const Icon(Icons.keyboard_arrow_down_rounded),
            ],
          ),
        ),
      );
}
