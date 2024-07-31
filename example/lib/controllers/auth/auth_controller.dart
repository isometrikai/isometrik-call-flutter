import 'dart:async';

import 'package:call_qwik_example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  AuthController(this._viewModel);

  final AuthViewModel _viewModel;

  DBWrapper get _dbWrapper => Get.find<DBWrapper>();

  var phoneTEC = TextEditingController();
  var otpTEC = TextEditingController();

  var emailTEC = TextEditingController();
  var passwordTEC = TextEditingController();

  var newPasswordTEC = TextEditingController();
  var confirmPasswordTEC = TextEditingController();

  var oldPassword = '';

  var client = '';
  var project = '';

  final RxBool _hidePassword = true.obs;
  bool get hidePassword => _hidePassword.value;
  set hidePassword(bool value) {
    if (value == hidePassword) {
      return;
    }
    _hidePassword.value = value;
  }

  final RxBool _hideOldPassword = true.obs;
  bool get hideNewPassword => _hideOldPassword.value;
  set hideNewPassword(bool value) {
    if (value == hideNewPassword) {
      return;
    }
    _hideOldPassword.value = value;
  }

  final RxList<ApplicationModel> _clients = <ApplicationModel>[].obs;
  List<ApplicationModel> get clients => _clients;
  set clients(List<ApplicationModel> value) {
    if (listEquals(_clients, value)) {
      return;
    }
    _clients.value = value;
  }

  final RxList<ApplicationModel> _accounts = <ApplicationModel>[].obs;
  List<ApplicationModel> get accounts => _accounts;
  set accounts(List<ApplicationModel> value) {
    if (listEquals(_accounts, value)) {
      return;
    }
    _accounts.value = value;
  }

  Timer? otpTimer;

  final emailLoginKey = GlobalKey<FormState>();
  final resetPasswordKey = GlobalKey<FormState>();
  final forgotPasswordKey = GlobalKey<FormState>();

  final otpFormKey = GlobalKey<FormState>();

  final RxInt _time = 0.obs;
  int get time => _time.value;
  set time(int value) => _time.value = value;

  String get _number => phoneTEC.text.trim();

  List<ApplicationModel> applications(String clientName) => clients
      .where(
        (e) => e.clientName == clientName,
      )
      .toList();

  void togglePasswordVisibility() {
    hidePassword = !hidePassword;
  }

  void toggleNewPasswordVisibility() {
    hideNewPassword = !hideNewPassword;
  }

  void startTimer() {
    otpTimer?.cancel();
    time = _dbWrapper.getIntValue(LocalKeys.otpTime);
    otpTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (time <= 0) {
        otpTimer?.cancel();
      }
      time--;
    });
  }

  Future<void> agentLogin() async {
    if (otpTEC.text.length != 6) {
      return;
    }

    var res = await _viewModel.verifyOtp(
      AgentModel(
        clientName: AppConstants.clientName,
        countryCode: '+91',
        phone: _number,
        createdUnderProjectId: AppConstants.projectId,
        phoneIsoCode: 'IN',
        otp: otpTEC.text.trim(),
      ),
    );
    if (res == null) {
      return;
    }
    RouteManagement.goToHome();
  }

  Future<void> emailLogin({
    String? clientName,
    String? projectId,
    bool shouldValidate = true,
    String? password,
  }) async {
    if (shouldValidate && !(emailLoginKey.currentState?.validate() ?? false)) {
      return;
    }
    var res = await _viewModel.emailLogin(
      email: emailTEC.text.trim(),
      password: password ?? passwordTEC.text.trim(),
      clientName: clientName,
      projectId: projectId,
    );

    if (res == null) {
      return;
    }
    if (res.isFirstTimeLogin) {
      client = res.clientName;
      project = res.projectId;
      oldPassword = passwordTEC.text.trim();
      passwordTEC.clear();
      newPasswordTEC.clear();
      confirmPasswordTEC.clear();
      resetPasswordKey.currentState?.reset();
      RouteManagement.goToResetPassword();
    } else if (res.clientNames.isNotEmpty) {
      clients = [...res.clientNames];
      accounts = getUniqueAccounts();
      if (accounts.length == 1) {
        selectAccount(accounts.first);
      } else {
        RouteManagement.goToSelectAccount();
      }
    } else {
      RouteManagement.goToHome();
    }
  }

  List<ApplicationModel> getUniqueAccounts() {
    var result = <ApplicationModel>[];
    var ids = <String>[];
    for (var client in clients) {
      if (!ids.contains(client.clientName)) {
        ids.add(client.clientName);
        result.add(client);
      }
    }
    return result;
  }

  void selectAccount(ApplicationModel model) {
    var apps = applications(model.clientName);
    if (apps.length == 1) {
      selectApplication(model);
    } else {
      RouteManagement.goToSelectApplication(model.clientName);
    }
  }

  void selectApplication(ApplicationModel model) {
    emailLogin(
      shouldValidate: false,
      clientName: model.clientName,
      projectId: model.projectId,
    );
  }

  void resetPassword() async {
    if (!(resetPasswordKey.currentState?.validate() ?? false)) {
      return;
    }
    Utility.hideKeyboard();
    var didReset = await _viewModel.resetPassword(
      clientName: client,
      projectId: project,
      email: emailTEC.text.trim(),
      oldPassword: oldPassword,
      newPassword: newPasswordTEC.text.trim(),
    );
    if (didReset) {
      unawaited(
          Utility.showToast('New Password has been created successfully!'));
      unawaited(emailLogin(
        shouldValidate: false,
        password: newPasswordTEC.text.trim(),
      ));
    }
  }

  void onForgotPassword() async {
    if (!(forgotPasswordKey.currentState?.validate() ?? false)) {
      return;
    }
    var isSent = await _viewModel.forgotPassword(
      email: emailTEC.text.trim(),
      clientName: client,
      projectId: project,
    );
    if (isSent) {
      unawaited(Utility.showToast('Password reset email sent!'));

      Get.back();
    }
  }
}
