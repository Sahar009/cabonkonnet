import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(radius: 50),
                    const SizedBox(height: 10),
                    Obx(() {
                      final userModel = profileController.userModelRx.value;
                      return userModel == null
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel.fullName.capitalizeFirst!,
                                  style: AppTextStyle.body(size: 20),
                                ),
                                Text(
                                  getUserTitle(userModel.role),
                                  style: AppTextStyle.body(size: 13),
                                ),
                                Text(
                                  userModel.country ?? "",
                                  style: AppTextStyle.body(
                                      size: 12, fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  userModel.website ?? "www.greenplace.com",
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
                Column(
                  children: [
                    TransButton(
                      title: "Edit Profile",
                      onTap: () {},
                    ),
                    TransButton(
                      title: 'Log Out',
                      onTap: () {
                        authController.logoutUser();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColor.primaryColor),
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
        margin: EdgeInsets.symmetric(vertical: 5),
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
