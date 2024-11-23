import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatelessWidget {
  final String? name;
  final String? profilePic;
  final String? country;

  final String subTitle;
  const ProfileWidget(
      {super.key,
      this.subTitle = "Post to everyone",
      this.name,
      this.profilePic,
      this.country});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Obx(() {
      profileController.getCurrentUserDetails();

      final userModel = profileController.currentUserModelRx.value;
      return userModel == null
          ? Container()
          : Row(
              children: [
                userModel.profileImage != null
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: CachedNetworkImageProvider(
                            profilePic ?? userModel.profileImage!),
                      )
                    : const CircleAvatar(
                        radius: 25,
                      ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name ?? userModel.fullName,
                        style: AppTextStyle.body(fontWeight: FontWeight.w500)),
                    Text(
                        country ??
                            (subTitle == "country"
                                ? (userModel.country ?? " ")
                                : subTitle),
                        style: AppTextStyle.body(
                            fontWeight: FontWeight.w500, size: 14))
                  ],
                ),
              ],
            );
    });
  }
}
