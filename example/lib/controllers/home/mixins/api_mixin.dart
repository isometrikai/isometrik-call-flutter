part of '../home_controller.dart';

mixin ApiMixin {
  HomeController get _controller => Get.find();

  Future<void> getPresignedUrl({
    required String fileName,
    required Uint8List bytes,
  }) async {
    Utility.showLoader();
    var imageExtension = fileName.split('.').last;
    var contentType = await Utility.getMimetype(imageExtension) ?? 'image/png';
    var res = await _controller._viewModel.getPresignedUrl(
      showLoader: false,
      fileName: fileName,
      folder: 'profile',
      contentType: contentType,
    );
    if (res == null) {
      Utility.closeLoader();
      return;
    }
    var urlResponse = await updatePresignedUrl(
      presignedUrl: res.data.url,
      bytes: bytes,
      contentType: contentType,
      host: res.data.signedHeader.host,
    );
    if (urlResponse == 200) {
      _controller.profileImage = res.url;
      _controller.update([EditProfileView.imageId]);
    }
    Utility.closeLoader();
  }

  Future<int?> updatePresignedUrl({
    required String presignedUrl,
    required Uint8List bytes,
    required String contentType,
    required String host,
  }) async {
    var response = await _controller._viewModel.updatePresignedUrl(
      presignedUrl: presignedUrl,
      file: bytes,
      contentType: contentType,
      host: host,
    );
    return response.statusCode;
  }

  Future<bool> editProfile() => _controller._viewModel.editProfile(
        name: _controller.nameTEC.text.trim(),
        imageUrl: _controller.profileImage,
      );

  Future<IsmAcceptCallModel?> answerCall(
    String meetingId,
    bool isAccepted,
  ) =>
      _controller._viewModel.answerCall(
        meetingId: meetingId,
        isAccepted: isAccepted,
      );

  Future<bool> endCall(String id) => _controller._viewModel.endCall(id);

  Future<bool> getStatus() => _controller._viewModel.getStatus();

  Future<bool> updateStatus(
    ActivityStatus status,
  ) =>
      _controller._viewModel.updateStatus(
        status: status.name,
      );

  Future<bool> addContact([
    String? userIdentifier,
    String? id,
  ]) =>
      _controller._viewModel.addContact(
        id: id,
        teamId: IsmCall.i.config?.userConfig.teamId ?? '',
        userIdentifier:
            userIdentifier ?? _controller.userInfoModel?.userIdentifier ?? '',
        firstName: _controller.firstNameTEC.text.trim(),
        lastName: _controller.lastNameTEC.text.trim(),
        phone: _controller.phoneTEC.text.trim(),
        email: _controller.emailTEC.text.trim(),
        countryCode: _controller.selectedCountry.phoneCode,
        notes: _controller.notesTEC.text.trim(),
      );

  Future<bool> deleteContact({
    required String userIdentifier,
    required String id,
  }) async =>
      _controller._viewModel.deleteContact(
        id: id,
        userIdentifier: userIdentifier,
      );

  Future<bool> addPushToken() => _controller._viewModel.updatePushToken(
        add: true,
        token: _controller.currentPushToken ?? '',
      );

  Future<bool> removePushToken([
    bool isLoggingOut = false,
  ]) =>
      _controller._viewModel.updatePushToken(
        add: false,
        token: (isLoggingOut
                ? _controller.currentPushToken
                : _controller.prevPushToken) ??
            '',
      );

  Future<void> getNotes({
    required String userId,
    bool isDetails = false,
    bool? showLoader,
    bool forPagination = false,
    bool firstLoad = false,
  }) async {
    if (isDetails) {
      _controller.detailsNotesSkip = forPagination
          ? (_controller.detailsNotesSkip + _controller.notesLimit) >
                  _controller.detailsNotesTotalCount
              ? _controller.detailsNotesTotalCount
              : _controller.detailsNotesSkip + _controller.notesLimit
          : 0;
    } else {
      _controller.notesSkip = forPagination
          ? (_controller.notesSkip + _controller.notesLimit) >
                  _controller.notesTotalCount
              ? _controller.notesTotalCount
              : _controller.notesSkip + _controller.notesLimit
          : 0;
    }
    if (!forPagination && firstLoad) {
      if (isDetails) {
        _controller.isDetailsNotesLoading = true;
      }
    }
    _controller.update([ContactNotes.updateId]);
    var data = await _controller._getNotes(
      userId,
      isDetails: isDetails,
      showLoader: showLoader,
    );
    if (data == null) {
      if (forPagination) {
        _controller._notesController(isDetails).loadFailed();
      } else {
        _controller._notesController(isDetails).refreshFailed();
      }
      return;
    }
    if (!_controller.allNotes.keys.contains(userId)) {
      _controller.allNotes[userId] = [];
    }
    if (data.isNotEmpty) {
      if (forPagination) {
        if (isDetails) {
          _controller.allNotes[userId]!.addAll(data);
        } else {
          _controller.notes?.addAll(data);
        }
      } else {
        if (isDetails) {
          _controller.allNotes[userId] = [...data];
        } else {
          _controller.notes = [...data];
        }
      }
      if (isDetails) {
        _controller.detailsNotesTotalCount =
            _controller.allNotes[userId]?.length ?? 0;
      } else {
        _controller.notesTotalCount = _controller.notes?.length ?? 0;
      }

      if (forPagination) {
        _controller._notesController(isDetails).loadComplete();
      } else {
        _controller._notesController(isDetails).refreshCompleted();
        _controller._notesController(isDetails).resetNoData();
      }
    } else {
      _controller._notesController(isDetails).loadNoData();
      _controller._notesController(isDetails).refreshToIdle();
    }

    if (isDetails) {
      _controller.isDetailsNotesLoading = false;
    }

    _controller.update([NotesView.updateId, ContactNotes.updateId]);
  }

  Future<NotesList?> _getNotes(
    String id, {
    bool? showLoader,
    required bool isDetails,
  }) =>
      _controller._viewModel.getNotes(
        id: id,
        showLoader: showLoader,
        limit: _controller.notesLimit,
        skip: isDetails ? _controller.detailsNotesSkip : _controller.notesSkip,
      );

  void addNote({
    String? meetingId,
    String? userId,
    VoidCallback? onSuccess,
  }) async {
    if (!(_controller.addNoteKey.currentState?.validate() ?? false)) {
      return;
    }
    var isAdded = await _controller._addNote(
      id: userId ?? _controller.userInfoModel!.userId,
      meetingId: meetingId,
    );

    if (isAdded) {
      unawaited(Utility.showToast('Note added successfully'));
      _controller.notesTEC.clear();
      Get.back();
      onSuccess?.call();
      unawaited(_controller.getNotes(
        userId: _controller.userInfoModel?.userId ?? '',
        showLoader: false,
      ));
    }
  }

  Future<bool> _addNote({
    required String id,
    String? meetingId,
  }) =>
      _controller._viewModel.addNote(
        id: id,
        projectId: IsmCall.i.config?.projectConfig.projectId ?? '',
        meetingId: meetingId,
        note: _controller.notesTEC.text.trim(),
      );

  Future<ContactsModel?> _getContact(
    String userId,
  ) =>
      _controller._viewModel.getContact(
        // teamId: IsmCall.i.config?.userConfig.teamId ?? '',
        userId: userId,
      );

  Future<void> getRecordings({
    required String userId,
    bool forPagination = false,
    bool firstLoad = false,
  }) async {
    _controller.recordingsSkip = forPagination
        ? (_controller.recordingsSkip + _controller.recordingsLimit) >
                _controller.recordingsTotalCount
            ? _controller.recordingsTotalCount
            : _controller.recordingsSkip + _controller.recordingsLimit
        : 0;

    if (!forPagination && firstLoad) {
      _controller.isRecordingsLoading = true;
    }
    _controller.update([ContactRecordings.updateId]);
    var data = await _controller._getRecordings(userId);
    if (data == null) {
      if (forPagination) {
        _controller.recordingsController.loadFailed();
      } else {
        _controller.recordingsController.refreshFailed();
      }
      return;
    }
    if (!_controller.allNotes.keys.contains(userId)) {
      _controller.allNotes[userId] = [];
    }
    if (data.isNotEmpty) {
      if (forPagination) {
        _controller.allRecordings[userId]!.addAll(data);
      } else {
        _controller.allRecordings[userId] = [...data];
      }

      _controller.recordingsTotalCount =
          _controller.allRecordings[userId]?.length ?? 0;

      if (forPagination) {
        _controller.recordingsController.loadComplete();
      } else {
        _controller.recordingsController.refreshCompleted();
        _controller.recordingsController.resetNoData();
      }
    } else {
      _controller.recordingsController.loadNoData();
      _controller.recordingsController.refreshToIdle();
    }

    _controller.isRecordingsLoading = false;

    _controller.update([ContactRecordings.updateId]);
  }

  Future<RecordingsList?> _getRecordings(
    String userId,
  ) =>
      _controller._viewModel.getRecordings(
        userId: userId,
        limit: 10,
        skip: 0,
      );

  Future<bool> _blockOrUnblock({
    required String isometrikUserId,
    String? contactId,
    required bool isBlocking,
  }) =>
      _controller._viewModel.blockOrUnblock(
        isometrikUserId: isometrikUserId,
        contactId: contactId,
        isBlocked: isBlocking,
      );
}
