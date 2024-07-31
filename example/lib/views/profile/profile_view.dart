import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const String route = Routes.profile;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppBar(label: 'Profile'),
        body: GetBuilder<HomeController>(
          builder: (controller) {
            if (IsmCall.i.config == null) {
              return Dimens.box0;
            }
            var user = IsmCall.i.config?.userConfig;
            return Center(
              child: Padding(
                padding: Dimens.edgeInsets16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Dimens.boxHeight32,
                    Hero(
                      tag: user?.userProfile ?? 'user-profile',
                      child: CustomImage.network(
                        user?.userProfile ?? '',
                        name: user?.firstName ?? 'U',
                        isProfileImage: true,
                        dimensions: Dimens.hundred,
                      ),
                    ),
                    Dimens.boxHeight16,
                    Text(
                      user?.fullName ?? 'User',
                      style: context.textTheme.titleLarge,
                    ),
                    Dimens.boxHeight8,
                    Text(
                      user?.phoneNumber ?? '',
                      style: context.textTheme.bodyMedium,
                    ),
                    Dimens.boxHeight24,
                    SizedBox(
                      width: Get.width * 0.5,
                      child: IsmCallButton(
                        label: 'Edit Profile',
                        onTap: controller.goToEditProfile,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: Get.width * 0.5,
                      child: IsmCallButton(
                        label: 'Logout',
                        backgroundColor: IsmCallColors.red,
                        onTap: controller.onLogout,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
