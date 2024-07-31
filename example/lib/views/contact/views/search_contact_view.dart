import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchContactView extends StatelessWidget {
  const SearchContactView({super.key});

  static const String route = Routes.searchContact;

  static const String updateId = 'ism-call-search-contact';

  @override
  Widget build(BuildContext context) => GetBuilder<ContactController>(
        id: updateId,
        initState: (_) {
          Get.find<ContactController>()
            ..searchTEC.clear()
            ..searchList.clear();
        },
        builder: (controller) => Scaffold(
          appBar: AppBar(
            title: CustomInputField(
              controller: controller.searchTEC,
              autofocus: true,
              contentPadding: Dimens.edgeInsets0_16,
              hintText: 'Search Contacts',
              filled: false,
              showBorder: false,
              onchange: (_) => controller.searchContacts(),
              suffixIcon: controller.hasQuery
                  ? Obx(
                      () => controller.isSearching
                          ? const SizedBox.shrink()
                          : IconButton(
                              onPressed: controller.searchTEC.clear,
                              icon: const Icon(
                                Icons.clear_rounded,
                              ),
                            ),
                    )
                  : null,
            ),
            backgroundColor: Colors.transparent,
            titleSpacing: 0,
          ),
          body: SmartRefresher(
            controller: controller.searchController,
            enablePullDown: false,
            enableTwoLevel: false,
            enablePullUp: true,
            footer: const LoadWidget(),
            onLoading: () => controller.searchContacts(true),
            child: !controller.hasQuery
                ? const EmptyPlaceholder(CallEmpty.searchContacts)
                : Obx(
                    () => controller.isSearching
                        ? const Loader()
                        : controller.searchList.isEmpty
                            ? const EmptyPlaceholder(CallEmpty.contacts)
                            : ListView.separated(
                                itemCount: controller.searchList.length,
                                padding: Dimens.edgeInsets16,
                                separatorBuilder: (_, __) => Dimens.boxHeight10,
                                itemBuilder: (_, index) {
                                  final contacts = controller.searchList[
                                      index % controller.searchList.length];
                                  return IsmContactGroup(contacts: contacts);
                                },
                              ),
                  ),
          ),
        ),
      );
}
