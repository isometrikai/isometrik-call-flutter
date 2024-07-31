import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class CreateContactSheet extends StatelessWidget {
  const CreateContactSheet({
    super.key,
    this.contact,
    this.userIdentifier,
    this.onGetContacts,
  });

  final ContactsModel? contact;
  final String? userIdentifier;
  final VoidCallback? onGetContacts;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.appBarTheme.backgroundColor,
        ),
        child: Padding(
          padding: Dimens.edgeInsets16,
          child: GetBuilder<HomeController>(
            initState: (_) {
              if (contact != null) {
                final controller = Get.find<HomeController>();
                var name = contact!.name.split(' ');
                controller.firstNameTEC.text = name.first.trim();
                controller.lastNameTEC.text = name.last.trim();
                controller.phoneTEC.text = contact!.phone.trim();
                controller.emailTEC.text = contact!.email.trim();
              }
            },
            builder: (controller) => SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.createContactKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const IconButton(
                            onPressed: null,
                            icon: Dimens.box0,
                          ),
                          Text(
                            contact != null ? 'Edit Contact' : 'Create Contact',
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: Get.back,
                            icon: const Icon(
                              Icons.close_rounded,
                            ),
                          ),
                        ],
                      ),
                      Dimens.boxHeight16,
                      Row(
                        children: [
                          Flexible(
                            child: CustomInputField.userName(
                              controller: controller.firstNameTEC,
                              label: 'First name',
                              validator: CallValidators.userName,
                            ),
                          ),
                          Dimens.boxWidth8,
                          Flexible(
                            child: CustomInputField.userName(
                              controller: controller.lastNameTEC,
                              label: 'Last name',
                              validator: CallValidators.userName,
                            ),
                          ),
                        ],
                      ),
                      Dimens.boxHeight16,
                      CustomInputField.phone(
                        controller: controller.phoneTEC,
                        selectedCountry: controller.selectedCountry,
                        validator: (value) =>
                            CallValidators.phoneNumber(value, isOptional: true),
                        onCountryChange: (country) {
                          controller.selectedCountry = country;
                        },
                        label: 'Mobile number',
                      ),
                      Dimens.boxHeight16,
                      CustomInputField.email(
                        controller: controller.emailTEC,
                        validator: (value) => CallValidators.emailValidator(
                            value,
                            isOptinal: true),
                        label: 'Email',
                      ),
                      if (contact == null) ...[
                        Dimens.boxHeight16,
                        CustomInputField(
                          controller: controller.notesTEC,
                          label: 'Add notes',
                          hintText: 'Extra notes',
                          minLines: 4,
                          maxLines: 6,
                        ),
                      ],
                      Dimens.boxHeight16,
                      IsmCallButton(
                        label: contact == null ? 'Save' : 'Update',
                        onTap: () => controller.onUpdateContact(
                          id: contact?.isometrikUserId,
                          userIdentifier: userIdentifier,
                          onGetContacts: onGetContacts,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
