import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  static const String route = Routes.contact;

  static const String updateId = 'isometrik-contacts-view';

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ContactController>()) {
      ContactBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          label: 'Contacts',
          actions: [
            const IconButton(
              onPressed: RouteManagement.goToSearchContact,
              icon: Icon(
                Icons.search_rounded,
              ),
            ),
            Dimens.boxWidth8,
          ],
        ),
        body: GetBuilder<ContactController>(
          id: ContactView.updateId,
          builder: (controller) => SmartRefresher(
            controller: controller.contactsController,
            enablePullDown: true,
            enableTwoLevel: false,
            enablePullUp: true,
            footer: const LoadWidget(),
            onRefresh: () => controller.getContacts(),
            onLoading: () => controller.getContacts(true),
            child: controller.isLoading
                ? const Loader()
                : controller.contacts.isEmpty
                    ? const EmptyPlaceholder(CallEmpty.contacts)
                    : Obx(
                        () => ListView.separated(
                          primary: false,
                          itemCount: controller.contacts.length,
                          padding: Dimens.edgeInsets16,
                          separatorBuilder: (_, __) => Dimens.boxHeight10,
                          itemBuilder: (_, index) {
                            final contacts = controller
                                .contacts[index % controller.contacts.length];
                            return IsmContactGroup(contacts: contacts);
                          },
                        ),
                      ),
          ),
        ),
      );
}
