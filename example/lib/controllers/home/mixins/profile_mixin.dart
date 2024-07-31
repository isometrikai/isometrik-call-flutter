part of '../home_controller.dart';

mixin ProfileMixin {
  HomeController get _controller => Get.find();

  Future<void> editProfileImage() => Utility.openBottomSheet(
        PickImageSheet(
          onPickImage: _uploadImage,
        ),
      );

  Future<void> onEditProfile() async {
    if (_controller.profileImage.isEmpty ||
        _controller.nameTEC.text.trim().isEmpty) {
      return;
    }
    var isUpdated = await _controller.editProfile();
    if (isUpdated) {
      var config = IsmCall.i.config!;
      config = config.copyWith(
        userConfig: config.userConfig.copyWith(
          firstName: _controller.nameTEC.text.trim(),
          userProfile: _controller.profileImage,
        ),
      );

      Get.back();
      _controller.update();
    }
  }

  void _uploadImage(ImageSource imageSource) async {
    var result = await ImagePicker().pickImage(
      imageQuality: 25,
      source: imageSource,
    );

    if (result != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: result.path,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper'.tr,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          )
        ],
      );
      var bytes = File(croppedFile!.path).readAsBytesSync();
      await _controller.getPresignedUrl(
        fileName: result.name,
        bytes: bytes,
      );
    }
  }
}
