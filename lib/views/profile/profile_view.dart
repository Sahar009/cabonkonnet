import 'dart:io';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/costom_dialog.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/views/profile/delete_account.dart';
import 'package:cabonconnet/views/profile/profile_details.dart';
import 'package:cabonconnet/views/profile/saved_post.dart';
import 'package:cabonconnet/views/widget/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';

class ProfileView extends StatefulWidget {
  final String userId;
  final bool isEditable;

  const ProfileView({
    super.key,
    required this.userId,
    this.isEditable =
        false, // Default to non-editable for other users' profiles
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController profileController = Get.put(ProfileController());
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    profileController.updateUserId(widget.userId);
  }

  Future<void> _selectCoverImage() async {
    if (!widget.isEditable) return;

    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        imageFile = File(selectedImage.path);
      });
      profileController.updateUserDetails(imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      body: Obx(() {
        final userModel = profileController.userModelRx.value;

        if (userModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header Section
              ProfileHeader(
                userModel: userModel,
                isEditable: widget.isEditable,
                onEditCover: _selectCoverImage,
              ),

              const SizedBox(height: 20),

              // Action Lists
              ActionListSection(
                userId: widget.userId,
                isEditable: widget.isEditable,
                userModel: userModel,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final UserModel userModel;
  final bool isEditable;
  final VoidCallback? onEditCover;

  const ProfileHeader({
    super.key,
    required this.userModel,
    this.isEditable = false,
    this.onEditCover,
  });

  @override
  Widget build(BuildContext context) {
    File? imageFile;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: MediaQuery.sizeOf(context).height * 0.35,
      decoration: const BoxDecoration(color: AppColor.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          50.toHeightWhiteSpacing(),
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                    color: AppColor.filledColor,
                    borderRadius: BorderRadius.circular(5),
                    // ignore: unnecessary_null_comparison
                    image: imageFile != null
                        ? DecorationImage(
                            image: FileImage(imageFile), fit: BoxFit.cover)
                        : userModel.coverImage != null
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                    userModel.coverImage!),
                                fit: BoxFit.cover)
                            : null),
                child: userModel.coverImage == null && isEditable
                    ? Center(
                        child: GestureDetector(
                          onTap: onEditCover,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all()),
                            child: const Text("Add cover photo"),
                          ),
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 3,
                left: 5,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: userModel.profileImage != null
                      ? CachedNetworkImageProvider(userModel.profileImage!)
                      : null,
                ),
              ),
              if (userModel.coverImage != null && isEditable)
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      //    _selectImages();

                      onEditCover;
                    },
                    child: const Icon(
                      IconsaxPlusLinear.edit_2,
                      color: AppColor.red,
                    ),
                  ),
                )
            ],
          ),
          10.toHeightWhiteSpacing(),
          Text(
            userModel.fullName.capitalizeFirst!,
            style: AppTextStyle.body(size: 18),
          ),
          3.toHeightWhiteSpacing(),
          Text(
            userModel.role.capitalizeFirst ?? '',
            style: AppTextStyle.body(size: 16),
          ),
          3.toHeightWhiteSpacing(),
          Text(
            userModel.country ?? "",
            style: AppTextStyle.body(size: 15, fontWeight: FontWeight.w300),
          ),
          2.toHeightWhiteSpacing(),
          Text(
            userModel.website ?? "www.greenplace.com",
            style: AppTextStyle.body(
                size: 15,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class ActionListSection extends StatelessWidget {
  final String userId;
  final bool isEditable;
  final UserModel userModel;
  const ActionListSection({
    super.key,
    required this.userId,
    this.isEditable = false,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        children: [
          Container(
            color: AppColor.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomListTile(
                  onTap: () {
                    Get.to(() => ProfileDetails(
                          user: userModel,
                          isEditable: isEditable,
                        ));
                  },
                  leading:
                      SvgPicture.asset(AppImages.person, height: 25, width: 25),
                  title: "Profile Details",
                ),
                CustomListTile(
                  onTap: () {
                    Get.to(() => ProfileDetails(
                          user: userModel,
                          isOrg: true,
                          isEditable: isEditable,
                        ));
                  },
                  leading: const Icon(IconsaxPlusLinear.bank),
                  title: "Organization",
                ),
                CustomListTile(
                  onTap: () {},
                  leading: SvgPicture.asset(AppImages.analytic),
                  title: "Analytics",
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            color: AppColor.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (isEditable)
                  CustomListTile(
                    onTap: () {
                      Get.to(() => SavedPost(
                            user: userModel,
                          ));
                    },
                    leading: Image.asset(AppImages.saveIcon),
                    title: "Saved posts",
                  ),
                CustomListTile(
                  onTap: () {},
                  leading: SvgPicture.asset(AppImages.activity),
                  title: "Activity",
                ),
                CustomListTile(
                  onTap: () {},
                  leading: const Icon(IconsaxPlusLinear.timer_1),
                  title: "Reminders",
                  isLast: true,
                ),
              ],
            ),
          ),
          20.toHeightWhiteSpacing(),
          if (isEditable)
            Container(
              color: AppColor.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CustomListTile(
                    onTap: () {
                      CustomDialog.logout(context: context);
                    },
                    leading: const Icon(IconsaxPlusLinear.login),
                    title: "Log out",
                  ),
                  CustomListTile(
                    onTap: () {
                      Get.to(() => const DeleteAccount());
                    },
                    leading: SvgPicture.asset(AppImages.delect),
                    title: "Delete account",
                    isLast: true,
                  ),
                ],
              ),
            ),
          50.toHeightWhiteSpacing()
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Widget leading;
  final Widget? trailing;
  final bool isLast;

  const CustomListTile(
      {super.key,
      required this.onTap,
      required this.title,
      required this.leading,
      this.trailing,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: leading,
          title: Text(title),
          visualDensity: const VisualDensity(horizontal: -2, vertical: -4),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          trailing: trailing ??
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              ),
        ),
        5.toHeightWhiteSpacing(),
        isLast ? Container() : const CustomDivider(),
      ],
    );
  }
}
