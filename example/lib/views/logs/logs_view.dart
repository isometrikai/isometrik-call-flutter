import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LogsView extends StatefulWidget {
  const LogsView({super.key});

  static const String route = Routes.logs;

  static const String updateId = 'isometrik-logs-view';

  @override
  State<LogsView> createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<LogsController>()) {
      LogsBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          label: 'Calls',
          actions: [
            GetX<HomeController>(
              builder: (controller) => AvailabilitySwitch(
                value: controller.isAvailable.value,
                onChanged: (value) => controller.toggleAvailability(
                  ActivityStatus.fromValue(value),
                ),
              ),
            ),
            // IconButton(
            //   onPressed: () async {},
            //   icon: const Icon(Icons.tune_rounded),
            // ),
            Dimens.boxWidth16,
          ],
        ),
        body: GetBuilder<LogsController>(
          id: LogsView.updateId,
          builder: (controller) => DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  padding: Dimens.edgeInsets16,
                  tabAlignment: TabAlignment.fill,
                  indicator: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(Dimens.fifty),
                  ),
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CallColors.white,
                  ),
                  unselectedLabelStyle: context.textTheme.labelLarge?.copyWith(
                    color: CallColors.unselected,
                  ),
                  splashBorderRadius: BorderRadius.circular(Dimens.fifty),
                  tabs: const [
                    Tab(text: 'Calls'),
                    Tab(text: 'Missed Opportunities'),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      _LostList(false),
                      _LostList(true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _LostList extends StatelessWidget {
  const _LostList(this.isOpportunities);

  final bool isOpportunities;

  @override
  Widget build(BuildContext context) => GetBuilder<LogsController>(
        id: LogsView.updateId,
        initState: (_) {
          var controller = Get.find<LogsController>();
          var data =
              isOpportunities ? controller.opportunities : controller.logs;
          if (data.isEmpty) {
            Utility.updateLater(() {
              controller.getCallLogs(
                isOpportunities: isOpportunities,
                // showLoader: true,
              );
            });
          }
        },
        builder: (controller) {
          var data =
              isOpportunities ? controller.opportunities : controller.logs;
          return SmartRefresher(
            controller: isOpportunities
                ? controller.opportunityController
                : controller.callLogsController,
            enablePullDown: true,
            enableTwoLevel: false,
            enablePullUp: true,
            footer: const LoadWidget(),
            onRefresh: () => controller.getCallLogs(
              isOpportunities: isOpportunities,
            ),
            onLoading: () => controller.getCallLogs(
              forPagination: true,
              isOpportunities: isOpportunities,
            ),
            child: controller.isLoading(isOpportunities)
                ? const Loader()
                : data.isEmpty
                    ? isOpportunities
                        ? const EmptyPlaceholder(CallEmpty.missedOpprtunity)
                        : const EmptyPlaceholder(CallEmpty.logs)
                    : Obx(
                        () => ListView.separated(
                          padding: Dimens.edgeInsets16_0,
                          primary: false,
                          shrinkWrap: true,
                          itemCount: data.length,
                          separatorBuilder: (_, __) => Dimens.boxHeight10,
                          itemBuilder: (_, index) => LogsGroup(
                            logs: data[index % data.length],
                            isOpportunities: isOpportunities,
                          ),
                        ),
                      ),
          );
        },
      );
}
