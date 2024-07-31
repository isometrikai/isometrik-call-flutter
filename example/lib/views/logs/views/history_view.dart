import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  static const String route = Routes.history;

  static const String updateId = 'isometrik-history-view';

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late CallLogsModel log;

  @override
  void initState() {
    super.initState();
    log = CallLogsModel.fromMap(Get.arguments as Map<String, dynamic>? ?? {});
    Get.find<HomeController>().clearContactFields();
  }

  void _onGetContacts() {
    var contact = Get.find<ContactController>()
        .contacts
        .flat
        .cast<ContactsModel?>()
        .firstWhere((e) => e!.isometrikUserId == log.isometrikUserId,
            orElse: () => null);

    CallLog.success('contacts $contact');
    if (contact == null) {
      return;
    }
    log = log.copyWith(
      contactImage: contact.userProfileUrl,
      contactName: contact.name,
    );
    Get.find<LogsController>().update([HistoryView.updateId]);
  }

  @override
  Widget build(BuildContext context) => GetBuilder<LogsController>(
        id: HistoryView.updateId,
        initState: (_) {
          var controller = Get.find<LogsController>();
          if (!controller.history.containsKey(log.isometrikUserId) ||
              controller.history[log.isometrikUserId]!.isEmpty) {
            Utility.updateLater(() {
              controller.getCallHistory(
                log.isometrikUserId,
              );
            });
          }
        },
        builder: (controller) => Scaffold(
          appBar: CustomAppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImage.network(
                  log.imageUrl,
                  name: log.name,
                  isProfileImage: true,
                  dimensions: Dimens.forty,
                ),
                Dimens.boxWidth10,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        log.name,
                        style: context.textTheme.titleMedium,
                      ),
                      Text(
                        log.ip,
                        style: context.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              if (log.isContactSaved) ...[
                const SizedBox.shrink(),
              ] else ...[
                IconButton(
                  onPressed: () {
                    Utility.openBottomSheet(
                      CreateContactSheet(
                        userIdentifier: log.userIdentifier,
                        onGetContacts: _onGetContacts,
                      ),
                      isScrollControlled: true,
                    );
                  },
                  color: CallColors.white,
                  icon: const Icon(
                    Icons.person_add_alt_1_rounded,
                  ),
                ),
              ],
            ],
          ),
          body: Builder(
            builder: (_) {
              var history = controller.history[log.isometrikUserId] ?? [];
              if (history.isEmpty) {
                return Center(
                  child: Text(
                    'No History found',
                    style: context.textTheme.titleLarge,
                  ),
                );
              }
              return Padding(
                padding: Dimens.edgeInsets16.copyWith(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'History',
                      style: context.textTheme.titleLarge,
                    ),
                    Dimens.boxHeight16,
                    Expanded(
                      child: SmartRefresher(
                        controller: controller.historyLogsController,
                        enablePullDown: true,
                        enableTwoLevel: false,
                        enablePullUp: true,
                        footer: const LoadWidget(),
                        onRefresh: () => controller.getCallHistory(
                          log.isometrikUserId,
                        ),
                        onLoading: () => controller.getCallHistory(
                          log.isometrikUserId,
                          forPagination: true,
                        ),
                        child: history.isEmpty
                            ? Center(
                                child: Text(
                                  'No History found',
                                  style: context.textTheme.titleLarge,
                                ),
                              )
                            : DecoratedBox(
                                decoration: BoxDecoration(
                                  color: context.theme.canvasColor,
                                  borderRadius:
                                      BorderRadius.circular(Dimens.sixteen),
                                ),
                                child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: history.length,
                                  padding: Dimens.edgeInsets12,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (_, index) => HistoryTile(
                                    history[index % history.length],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}
