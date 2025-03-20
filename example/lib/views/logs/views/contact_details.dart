import 'dart:async';

import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class ContactDetailsView extends StatefulWidget {
  const ContactDetailsView({super.key});

  static const String route = Routes.contactDetails;
  static const String updateId = 'isometrik-contact-details';

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView>
    with SingleTickerProviderStateMixin {
  CallLogsModel? _log;
  ContactsModel? _contact;
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _labelAnimation;
  late Animation<double> _iconAnimation;
  late List<MenuOption> options;

  LogsController get _logController => Get.find();

  HomeController get _callController => Get.find();

  double get expandHeight => showEmailPhone
      ? contact!.email.trim().isEmpty || contact!.phone.trim().isEmpty
          ? Dimens.twoHundredFifty
          : Dimens.threeHundred
      : Dimens.oneHundredSeventy;

  double get titlePadding => showEmailPhone
      ? contact!.email.trim().isEmpty || contact!.phone.trim().isEmpty
          ? Dimens.fiftyFive
          : Dimens.eighty
      : 0;

  CallLogsModel? get log =>
      _log ??
      _logController.historyLogs(false)[isometrikUserId]?.firstOrNull ??
      _logController.historyLogs(true)[isometrikUserId]?.firstOrNull;

  String get isometrikUserId =>
      _log?.isometrikUserId ?? _contact?.isometrikUserId ?? '';

  ContactsModel? get contact =>
      _contact ?? _callController.allContacts[isometrikUserId];

  bool get showEmailPhone =>
      (log != null && log!.isContactSaved) ||
      (contact != null &&
          (contact!.email.trim().isNotEmpty ||
              contact!.phone.trim().isNotEmpty));

  @override
  void initState() {
    super.initState();
    var logArgument = Get.arguments['log'] as Map<String, dynamic>?;
    var contactArgument = Get.arguments['contact'] as Map<String, dynamic>?;
    _log = logArgument != null ? CallLogsModel.fromMap(logArgument) : null;
    _contact =
        contactArgument != null ? ContactsModel.fromMap(contactArgument) : null;

    _callController.clearContactFields();
    initializeOptions();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _animationController = AnimationController(
      vsync: this,
      duration: AppConstants.animationDuration,
    );
    _labelAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _iconAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      final expandedHeight = expandHeight - kToolbarHeight;
      _animationController.value = (offset / expandedHeight).clamp(0.0, 1.0);
    }
  }

  void initializeOptions() {
    options = [
      MenuOption.addNote,
      if (contact == null) ...[
        MenuOption.create,
      ] else ...[
        MenuOption.edit,
        MenuOption.delete,
      ],
      if (contact == null || !contact!.isBlocked) ...[
        MenuOption.block,
      ] else ...[
        MenuOption.unblock,
      ],
    ];
    _logController.update([ContactDetailsView.updateId]);
  }

  void checkLogs() {
    if (log == null) {
      _logController.getCallHistory(
        isometrikUserId,
        isOpportunities: true,
        isFirstLoad: true,
      );
    }
  }

  Future<void> _refreshOnSuccess() async {
    await _callController.getContact(
      isometrikUserId,
      forceFetch: true,
    );
    initializeOptions();
  }

  void _onContactCreated() async {
    await Future.wait([
      _logController.getCallHistory(
        isometrikUserId,
        isOpportunities: false,
        isFirstLoad: true,
      ),
      _refreshOnSuccess(),
    ]);
    unawaited(_logController.getCallLogs());
    _log = _logController.historyLogs(false)[isometrikUserId]?.first ?? log;
    _logController.update([ContactDetailsView.updateId]);
  }

  void _onAddNote() {
    _callController.getNotes(
      userId: isometrikUserId,
      isDetails: true,
    );
    _logController.update([ContactDetailsView.updateId]);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GetBuilder<LogsController>(
        id: ContactDetailsView.updateId,
        initState: (_) {
          if (_log == null) {
            checkLogs();
          } else {
            _callController
                .getContact(isometrikUserId)
                .then((value) => initializeOptions());
          }
        },
        builder: (controller) => Scaffold(
          body: DefaultTabController(
            length: ContactDetailsType.values.length,
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (_, __) => [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  expandedHeight: expandHeight,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    background: ColoredBox(
                      color: context.theme.scaffoldBackgroundColor,
                      child: showEmailPhone
                          ? AnimatedBuilder(
                              animation: _animationController,
                              builder: (_, __) => _Background(
                                labelAnimation: _labelAnimation,
                                contact: contact!,
                              ),
                            )
                          : null,
                    ),
                    titlePadding: Dimens.edgeInsets8.copyWith(
                      bottom: Dimens.fiftyFive,
                    ),
                    collapseMode: CollapseMode.pin,
                    title: AnimatedBuilder(
                      animation: _animationController,
                      builder: (_, __) => Padding(
                        padding: EdgeInsets.only(
                          left: Dimens.fifty * (1 - _labelAnimation.value),
                          bottom: titlePadding * _labelAnimation.value,
                        ),
                        child: DetailsTitle(
                          log: log,
                          animationValue: _labelAnimation.value,
                          name: contact?.name ?? '',
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    padding: EdgeInsets.only(top: Dimens.eight),
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: context.theme.primaryColor.applyOpacity(0.3),
                      border: Border(
                        bottom: BorderSide(
                          color: context.theme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    tabs: ContactDetailsType.values
                        .map(
                          (e) => Tab(
                            text: e.label,
                          ),
                        )
                        .toList(),
                  ),
                  actions: [
                    if (showEmailPhone) ...[
                      AnimatedBuilder(
                        animation: _iconAnimation,
                        builder: (_, __) => Opacity(
                          opacity: _iconAnimation.value,
                          child: Row(
                            children: [
                              if (contact!.phone.isNotEmpty) ...[
                                IconButton(
                                  onPressed: _iconAnimation.value > 0.5
                                      ? () => Utility.launchURL(
                                          'tel:${contact?.phoneNumber}')
                                      : null,
                                  icon: const CustomImage.svg(
                                    AssetConstants.callActive,
                                    fromPackage: false,
                                  ),
                                ),
                              ],
                              if (contact!.email.isNotEmpty) ...[
                                IconButton(
                                  onPressed: _iconAnimation.value > 0.5
                                      ? () => Utility.launchURL(
                                          'mailto:${contact?.email}')
                                      : null,
                                  icon: const CustomImage.svg(
                                    AssetConstants.mail,
                                    fromPackage: false,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      offset: const Offset(0, 48),
                      color: context.theme.scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.eight),
                      ),
                      itemBuilder: (_) => options
                          .map(
                            (e) => PopupMenuItem(
                              onTap: log == null
                                  ? null
                                  : () => _callController.onItemTapped(
                                        e,
                                        log: log!,
                                        contact: contact,
                                        onSuccess: _refreshOnSuccess,
                                        onAddNote: _onAddNote,
                                        onContactCreated: _onContactCreated,
                                      ),
                              child: Text(e.label),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ],
              body: TabBarView(
                children: ContactDetailsType.values
                    .map((e) => e.body(isometrikUserId))
                    .toList(),
              ),
            ),
          ),
        ),
      );
}

class _Background extends StatelessWidget {
  const _Background({
    required this.labelAnimation,
    required this.contact,
  });

  final Animation<double> labelAnimation;
  final ContactsModel contact;

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(labelAnimation),
        child: Opacity(
          opacity: labelAnimation.value,
          alwaysIncludeSemantics: false,
          child: Padding(
            padding: Dimens.edgeInsets16_8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Dimens.boxHeight4,
                if (contact.phone.trim().isNotEmpty) ...[
                  _ContactTile(
                    contact: contact.phoneNumber,
                    label: 'Phone no.',
                  ),
                ],
                if (contact.email.trim().isNotEmpty) ...[
                  _ContactTile(
                    contact: contact.email,
                    label: 'Email ID',
                  ),
                ],
                if (contact.creatorDetails != null &&
                    contact.creatorDetails!.fullName.isNotEmpty) ...[
                  _ContactTile(
                    contact: contact.creatorDetails!.fullName,
                    label: 'Associated Agent',
                  ),
                ],
                Dimens.boxHeight8,
                Row(
                  children: [
                    if (contact.phone.isNotEmpty) ...[
                      Flexible(
                        child: IsmCallButton(
                          label: 'Call',
                          onTap: labelAnimation.value > 0.5
                              ? () => Utility.launchURL(
                                  'tel:${contact.phoneNumber}')
                              : () {},
                        ),
                      ),
                    ],
                    if (contact.email.isNotEmpty &&
                        contact.phone.isNotEmpty) ...[
                      Dimens.boxWidth16,
                    ],
                    if (contact.email.isNotEmpty) ...[
                      Flexible(
                        child: IsmCallButton.outlined(
                          label: 'Email',
                          backgroundColor:
                              context.theme.scaffoldBackgroundColor,
                          onTap: labelAnimation.value > 0.5
                              ? () =>
                                  Utility.launchURL('mailto:${contact.email}')
                              : () {},
                        ),
                      ),
                    ],
                  ],
                ),
                Dimens.boxHeight50,
              ],
            ),
          ),
        ),
      );
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.contact,
    required this.label,
  });

  final String contact;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.labelLarge,
          ),
          Text(
            contact,
            style: context.textTheme.labelLarge,
          ),
        ],
      );
}
