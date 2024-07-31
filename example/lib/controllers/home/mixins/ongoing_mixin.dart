part of '../home_controller.dart';

mixin OngoingMixin {
  HomeController get _controller => Get.find();

  bool get isContactAdded => Get.find<ContactController>()
      .contacts
      .flat
      .map((e) => e.isometrikUserId)
      .contains(
        _controller.userInfoModel?.userId,
      );

  void clearContactFields() {
    _controller.firstNameTEC.clear();
    _controller.lastNameTEC.clear();
    _controller.emailTEC.clear();
    _controller.phoneTEC.clear();
    _controller.notesTEC.clear();
    _controller.selectedCountry = _controller._kCountry;
  }

  void onUpdateContact({
    String? id,
    String? userIdentifier,
    VoidCallback? onGetContacts,
  }) async {
    if (!(_controller.createContactKey.currentState?.validate() ?? false)) {
      return;
    }
    var isSuccess = await _controller.addContact(userIdentifier, id);
    if (isSuccess) {
      Utility.closeBottomSheet();
      if (Get.isRegistered<ContactController>()) {
        unawaited(Get.find<ContactController>()
            .getContacts()
            .then((_) => onGetContacts?.call()));
      } else {
        onGetContacts?.call();
      }
      _controller.update();
      _controller.update([ContactDetailsView.updateId]);
      var msg = id == null
          ? 'Contact Added successfully'
          : 'Contact Updated successfully';
      unawaited(Utility.showToast(msg));
    }
  }

  List<NoteModel>? _meetingNotes(
    bool isDetails,
    String userId,
  ) =>
      (isDetails ? _controller.allNotes[userId] : _controller.notes);

  bool hasNotes(
    bool isDetails,
    String userId,
  ) =>
      _meetingNotes(isDetails, userId) != null &&
      _meetingNotes(isDetails, userId)!.isNotEmpty;

  bool hasRecording(String userId) =>
      _controller.allRecordings[userId] != null &&
      _controller.allRecordings[userId]!.isNotEmpty;

  void goToNotes() async {
    if (_controller.notes == null || _controller.notes!.isEmpty) {
      await _controller.getNotes(
        userId: _controller.userInfoModel?.userId ?? '',
        showLoader: true,
      );
    }
    if (hasNotes(false, _controller.userInfoModel?.userId ?? '')) {
      unawaited(RouteManagement.goToNotes());
    } else {
      unawaited(RouteManagement.goToAddNotes(IsmCallHelper.ongoingMeetingId));
    }
  }
}
