import 'package:call_qwik_example/main.dart';
import 'package:get/get.dart';

class RouteManagement {
  const RouteManagement._();

  /// Go to the Terms and Condition Screen
  static void goToTermsCondition() {
    Get.offAllNamed<void>(
      Routes.termsCondition,
    );
  }

  /// Go to the Email Login Screen
  static void goToEmailLogin() {
    Get.offAllNamed<void>(
      Routes.emailLogin,
    );
  }

  /// Go to the Reset Password Screen
  static void goToResetPassword() {
    Get.toNamed<void>(Routes.resetPassword);
  }

  /// Go to the Forgot Password Screen
  static void goToForgotPassword() {
    Get.toNamed<void>(
      Routes.forgotPassword,
    );
  }

  /// Go to the Verify Otp Screen
  static void goToVerifyOtp() {
    Get.toNamed<void>(
      Routes.verifyOtp,
    );
  }

  /// Go to the Select Account Screen
  static void goToSelectAccount() {
    Get.toNamed<void>(
      Routes.selectAccount,
    );
  }

  /// Go to the Select Application Screen
  static void goToSelectApplication(String clientName) {
    Get.toNamed<void>(
      Routes.selectApplication,
      arguments: clientName,
    );
  }

  /// Go to the Home Screen
  static void goToHome() {
    Get.offAllNamed<void>(
      Routes.home,
    );
  }

  static Future<void> goToEditProfile() async {
    await Get.toNamed(Routes.editProfile);
  }

  static Future<void> goToHistory(CallLogsModel logs) async {
    await Get.toNamed(
      Routes.history,
      arguments: logs.toMap(),
    );
  }

  static Future<void> goToContactDetails({
    CallLogsModel? log,
    ContactsModel? contact,
  }) async {
    assert(
      log != null || contact != null,
      'Either log or contact must be non-null t navigate to contact details screen',
    );
    await Get.toNamed(
      Routes.contactDetails,
      arguments: {
        'log': log?.toMap(),
        'contact': contact?.toMap(),
      },
    );
  }

  static Future<void> goToIncomingCall(
    IncomingCallArgument argument,
  ) async {
    await Get.toNamed(
      Routes.incomingCall,
      arguments: argument.toMap(),
    );
  }

  static Future<void> goToNotes() async {
    await Get.toNamed(Routes.notes);
  }

  static Future<void> goToSingleNote({
    required String userId,
    required NoteModel note,
  }) async {
    await Get.toNamed(Routes.singleNote, arguments: {
      'userId': userId,
      'note': note.toMap(),
    });
  }

  static Future<void> goToAddNotes(String? meetingId) async {
    await Get.toNamed(
      Routes.addNotes,
      arguments: meetingId,
    );
  }

  static Future<void> goToSearchContact() async {
    await Get.toNamed(Routes.searchContact);
  }

  static Future<void> goToVideoView(String url) async {
    await Get.toNamed(Routes.videoViewer, arguments: url);
  }
}
