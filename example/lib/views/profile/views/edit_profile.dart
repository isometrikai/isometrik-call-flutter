import 'package:call_qwik_example/main.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  static const String route = Routes.editProfile;

  static const String imageId = 'profile-image-id';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppBar(label: 'Profile'),
        body: GetBuilder<HomeController>(
          initState: (_) {
            if (IsmCall.i.config == null) {
              return;
            }
            var user = IsmCall.i.config?.userConfig;
            Get.find<HomeController>()
              ..nameTEC.text = user?.fullName ?? ''
              ..profileImage = user?.userProfile ?? ''
              ..selectedCountry = Country.tryParse(
                      user?.countryCode?.replaceAll('+', '') ?? '') ??
                  Country.tryParse(user?.isoCode ?? '') ??
                  Country.worldWide;
          },
          builder: (controller) {
            if (IsmCall.i.config == null) {
              return Dimens.box0;
            }
            var user = IsmCall.i.config?.userConfig;
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: Dimens.edgeInsets16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Dimens.boxHeight32,
                      GetBuilder<HomeController>(
                        id: imageId,
                        builder: (_) => Hero(
                          tag: user?.userProfile ?? 'user-profile',
                          child: controller.profileImage.isNullOrEmpty
                              ? TapHandler(
                                  onTap: controller.editProfileImage,
                                  child: SizedBox.square(
                                    dimension: Dimens.hundred,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: context.theme.cardColor,
                                      ),
                                      child: const UnconstrainedBox(
                                        child: CustomImage.svg(
                                          AssetConstants.addPhoto,
                                          fromPackage: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CustomImage.network(
                                      controller.profileImage,
                                      name: user?.firstName ?? 'U',
                                      isProfileImage: true,
                                      dimensions: Dimens.hundred,
                                    ),
                                    Positioned(
                                      bottom: -10,
                                      right: -10,
                                      child: Transform.scale(
                                        scale: 0.8,
                                        child: IconButton(
                                          style: IconButton.styleFrom(
                                            backgroundColor: CallColors.white,
                                            foregroundColor:
                                                context.theme.primaryColor,
                                          ),
                                          onPressed:
                                              controller.editProfileImage,
                                          icon: const Icon(
                                              Icons.camera_alt_rounded),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Dimens.boxHeight16,
                      CustomInputField.userName(
                        label: 'Full name',
                        controller: controller.nameTEC,
                      ),
                      const Spacer(),
                      IsmCallButton(
                        label: 'Save',
                        onTap: controller.onEditProfile,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}
