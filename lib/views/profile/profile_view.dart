import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/profile/delete_account.dart';
import 'package:cabonconnet/views/profile/profile_details.dart';
import 'package:cabonconnet/views/profile/saved_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.put(ProfileController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.33,
              decoration: const BoxDecoration(color: AppColor.white),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const CircleAvatar(radius: 50),
                            Obx(() {
                              final userModel =
                                  profileController.userModelRx.value;
                              return userModel == null
                                  ? Container()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              userModel.profileImage != null
                                                  ? CachedNetworkImageProvider(
                                                      userModel.profileImage!)
                                                  : null,
                                        ),
                                        Text(
                                          userModel.fullName.capitalizeFirst!,
                                          style: AppTextStyle.body(size: 20),
                                        ),
                                        Text(
                                          userModel.role.capitalizeFirst ?? '',
                                          style: AppTextStyle.body(size: 13),
                                        ),
                                        Text(
                                          userModel.country ?? "",
                                          style: AppTextStyle.body(
                                              size: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          userModel.website ??
                                              "www.greenplace.com",
                                          style: AppTextStyle.body(
                                              size: 12,
                                              color: AppColor.primaryColor,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: AppColor.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.to(() => ProfileDetails(
                            user: profileController.userModelRx.value!,
                          ));
                    },
                    leading: SvgPicture.asset(
                      AppImages.person,
                      height: 25,
                      width: 25,
                    ),
                    title: const Text("Profile Details"),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: -4),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Get.to(() => ProfileDetails(
                            user: profileController.userModelRx.value!,
                            isOrg: true,
                          ));
                    },
                    leading: const Icon(
                      IconsaxPlusLinear.bank,
                    ),
                    title: const Text("Organization"),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: -4),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {},
                    leading: SvgPicture.asset(AppImages.analytic),
                    title: const Text("Analytics"),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: -4),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: AppColor.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.to(() => SavedPost(
                            user: profileController.userModelRx.value!,
                          ));
                    },
                    leading: Image.asset(AppImages.saveIcon),
                    title: const Text("Saved posts"),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: -4),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  const Divider(),
                  ListTile(
                    leading: SvgPicture.asset(AppImages.activity),
                    title: const Text("Activity"),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: -4),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      IconsaxPlusLinear.timer_1,
                    ),
                    title: const Text("Reminders"),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: -4),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  // const Divider(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              color: AppColor.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      authController.logoutUser();
                    },
                    leading: const Icon(
                      IconsaxPlusLinear.login,
                    ),
                    title: Text(
                      "Log out",
                      style: AppTextStyle.body(size: 16),
                    ),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: -4),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      Get.to(() => DeleteAccount());
                    },
                    leading: SvgPicture.asset(AppImages.delect),
                    title: Text(
                      "Delete account",
                      style: AppTextStyle.body(color: AppColor.red, size: 16),
                    ),
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: -4),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TransButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const TransButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: AppTextStyle.body(
              color: AppColor.primaryColor,
              size: 15,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
