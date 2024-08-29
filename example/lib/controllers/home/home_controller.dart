import 'dart:async';
import 'dart:io';

import 'package:call_qwik_example/main.dart';
import 'package:call_qwik_example/utils/device_config.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'mixins/api_mixin.dart';
part 'mixins/ongoing_mixin.dart';
part 'mixins/profile_mixin.dart';
part 'mixins/variable_mixin.dart';

class HomeController extends GetxController
    with ApiMixin, VariableMixin, OngoingMixin, ProfileMixin {
  HomeController(this._viewModel);

  final HomeViewModel _viewModel;

  DBWrapper get _dbWrapper => Get.find<DBWrapper>();

  final RxBool _callInitialized = false.obs;
  bool get callInitialized => _callInitialized.value;
  set callInitialized(bool value) => _callInitialized.value = value;

  AgentDetailsModel? agent;

  @override
  void onReady() async {
    super.onReady();
    Utility.updateLater(_onInitLater);
  }

  @override
  void onInit() {
    super.onInit();
    _onInit();
  }

  void _onInitLater() async {
    unawaited(getStatus().then(
      (value) {
        isAvailable = ActivityStatus.fromValue(value);
      },
    ));
  }

  void _onInit() async {
    callInitialized = false;
    try {
      var data = await _dbWrapper.getSecuredValue(LocalKeys.agent);
      while (data.trim().isEmpty) {
        data = await _dbWrapper.getSecuredValue(LocalKeys.agent);
        await Future.delayed(const Duration(milliseconds: 50));
      }
      agent = AgentDetailsModel.fromJson(data);
      final config = IsmCallConfig(
        userConfig: IsmCallUserConfig(
          firstName: agent?.name,
          lastName: '',
          userEmail: agent?.email,
          userProfile: agent?.userProfileUrl,
          userId: agent?.isometrikUserId,
          userToken: agent?.userToken,
          accessToken: agent?.token.accessToken,
          refreshToken: agent?.token.refreshToken,
          countryCode: agent?.phoneCountryCode,
          isoCode: agent?.phoneIsoCode,
          number: agent?.phoneNumber,
          teamId: agent?.teamInfo.first.id,
          teamName: agent?.teamInfo.first.teamName,
        ),
        projectConfig: IsmCallProjectConfig(
          accountId: agent?.accountId,
          appSecret: agent?.appSecret,
          deviceId: Get.find<DeviceConfig>().deviceId,
          keySetId: agent?.keysetId,
          licenseKey: agent?.licenseKey,
          projectId: agent?.projectId,
          userSecret: '',
        ),
        mqttConfig: IsmCallMqttConfig(
          hostName: AppConstants.mqttHost,
          port: AppConstants.mqttPort,
        ),
      );
      update();

      await IsmCall.i.initialize(
        config,
        appLogo: const AppLogo(),
        onLogout: logout,
        onRefreshToken: refreshToken,
        onAcceptCall: (meetingId, deviceId) => answerCall(meetingId, true),
        onDeclineCall: (meetingId) async {
          final model = await answerCall(meetingId, false);
          return model != null;
        },
        onEndCall: endCall,
      );
      _listenCallTrigger();
    } catch (e, st) {
      CallLog(e, st);
      unawaited(Utility.showInfoDialog(ResponseModel.message(e.toString())));
    } finally {
      callInitialized = true;
    }
  }

  void _listenCallTrigger() {
    IsmCall.i.addCallTriggerListener(
      (trigger) {
        if (Get.isRegistered<LogsController>()) {
          unawaited(Get.find<LogsController>().refreshLogs());
        }
      },
    );
  }

  Future<void> logout() async {
    if (Get.currentRoute != Routes.emailLogin) {
      RouteManagement.goToEmailLogin();
      unawaited(Future.wait([
        _dbWrapper.saveValue(LocalKeys.isLoggedIn, false),
        _dbWrapper.deleteSecuredValue(LocalKeys.agent),
        IsmCall.i.dispose(),
      ]));
    }
  }

  Future<void> refreshToken() async {
    var user = await _viewModel.refreshToken(
      refreshToken: agent!.token.refreshToken,
      clientName: agent!.clientName,
    );

    if (user == null) {
      return;
    }
    agent = user;
  }

  void onTapNavItam(int index) {
    selectedNavIndex = index;
  }

  Future<void> toggleAvailability(ActivityStatus? status) async {
    isAvailable = status ?? isAvailable.toggle;
    var isUpdated = await updateStatus(isAvailable);
    if (!isUpdated) {
      isAvailable = isAvailable.toggle;
    }
  }

  void goToEditProfile() {
    RouteManagement.goToEditProfile();
  }

  void onLogout() {
    Utility.openBottomSheet(
      LogoutSheet(
        onLogout: () {
          IsmCall.i.logout?.call();
        },
        onCancel: Get.back,
      ),
    );
  }

  Future<bool> updatePushToken(String token, [String? prevToken]) async {
    prevPushToken = prevToken ?? currentPushToken;
    currentPushToken = token;
    var res = await Future.wait([
      if (currentPushToken != null && currentPushToken!.isNotEmpty) ...[
        addPushToken(),
      ],
      if (prevPushToken != null && prevPushToken!.isNotEmpty) ...[
        removePushToken(),
      ],
    ]);
    return res.every((e) => e);
  }

  Future<void> getContact(
    String userId, {
    bool forceFetch = false,
  }) async {
    if (!forceFetch) {
      if (_controller.allContacts.keys.contains(userId) &&
          _controller.allContacts[userId] != null) {
        return;
      }
    }
    var contact = await _getContact(userId);
    if (contact == null) {
      return;
    }
    _controller.allContacts[userId] = contact;
    if (!Get.isRegistered<LogsController>()) {
      LogsBinding().dependencies();
    }
    Get.find<LogsController>().update([ContactDetailsView.updateId]);
  }

  void onItemTapped(
    MenuOption option, {
    required CallLogsModel log,
    ContactsModel? contact,
    VoidCallback? onSuccess,
    VoidCallback? onAddNote,
    VoidCallback? onContactCreated,
  }) {
    switch (option) {
      case MenuOption.create:
      case MenuOption.edit:
        Utility.openBottomSheet(
          CreateContactSheet(
            contact: contact,
            userIdentifier: log.userIdentifier,
            onGetContacts: onContactCreated,
          ),
          isScrollControlled: true,
        );
        break;
      case MenuOption.addNote:
        Utility.openBottomSheet(
          AddNoteSheet(
            userId: log.isometrikUserId,
            onSuccess: onAddNote,
          ),
          isScrollControlled: true,
        );
        break;
      case MenuOption.delete:
        if (contact == null) {
          return;
        }
        Utility.openBottomSheet(
          CustomBottomSheet(
            title: option.label,
            body: 'Are you sure you want to ${option.name} this contact ?',
            successLabel: option.label,
            onSuccess: () async {
              var isSuccess = await _controller.deleteContact(
                userIdentifier: log.userIdentifier,
                id: contact.isometrikUserId,
              );
              if (isSuccess) {
                unawaited(Utility.showToast('Contact deleted successfully'));
                onSuccess?.call();
              } else {
                unawaited(Utility.showToast(
                  'Failed to ${option.label}',
                  color: CallColors.red,
                ));
              }
            },
          ),
        );

        break;
      case MenuOption.block:
      case MenuOption.unblock:
        Utility.openBottomSheet(
          CustomBottomSheet(
            title: '${option.label} contact',
            body: 'Are you sure you want to ${option.name} this contact ?',
            successLabel: option.label,
            onSuccess: () async {
              var isSuccess = await _controller._blockOrUnblock(
                isometrikUserId: log.isometrikUserId,
                isBlocking: option == MenuOption.block,
                contactId: contact?.id,
              );
              if (isSuccess) {
                unawaited(Utility.showToast('${option.label}ed successfully'));
                onSuccess?.call();
              } else {
                unawaited(Utility.showToast(
                  'Failed to ${option.label}',
                  color: CallColors.red,
                ));
              }
            },
          ),
        );

        break;
    }
  }
}
