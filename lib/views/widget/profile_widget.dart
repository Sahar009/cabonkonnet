import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Obx(() {
      final userModel = profileController.userModelRx.value;

      return userModel == null
          ? Container()
          : Row(
              children: [
                userModel.profileImage != null
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            CachedNetworkImageProvider(userModel.profileImage!),
                      )
                    : const CircleAvatar(
                        radius: 25,
                      ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userModel.fullName,
                        style: AppTextStyle.body(fontWeight: FontWeight.w500)),
                    Text('Post to everyone',
                        style: AppTextStyle.body(
                            fontWeight: FontWeight.w500, size: 14))
                  ],
                ),
              ],
            );
    });
  }
}
