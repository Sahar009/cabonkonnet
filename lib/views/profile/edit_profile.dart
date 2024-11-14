import 'dart:io';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/user_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  final bool isOrg;
  const EditProfile({super.key, required this.user, this.isOrg = false});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  UserController userController = Get.put(UserController());

  // Define TextEditingController instances for each field
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController bioController;
  late TextEditingController countryController;
  late TextEditingController businessRegNumberController;
  late TextEditingController websiteController;
  late TextEditingController teamController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with user data
    nameController = TextEditingController(text: widget.user.fullName);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phoneNumber);
    addressController = TextEditingController(text: widget.user.address);
    bioController = TextEditingController(text: widget.user.bio);

    if (widget.isOrg) {
      // Initialize organization-specific controllers
      countryController =
          TextEditingController(text: widget.user.country ?? "");
      businessRegNumberController =
          TextEditingController(text: widget.user.businessRegNumber ?? "");
      websiteController =
          TextEditingController(text: widget.user.website ?? "");
      teamController = TextEditingController(
          text: "${widget.user.teamMembers?.length ?? 0} members");
    }
  }

  Future<void> _selectImages() async {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        imageFile = File(selectedImage.path);
      });
    }
  }

  void _saveProfile() async {
    // Check if each field has changed and only include it in copyWith if it has
    UserModel updatedUser = widget.user.copyWith(
      // Common fields for both individual and organization profiles
      fullName: nameController.text != widget.user.fullName
          ? nameController.text
          : null,
      email: emailController.text != widget.user.email
          ? emailController.text
          : null,
      phoneNumber: phoneController.text != widget.user.phoneNumber
          ? phoneController.text
          : null,
      address: addressController.text != widget.user.address
          ? addressController.text
          : null,
      bio: bioController.text != widget.user.bio ? bioController.text : null,
      // Organization-specific fields only if `isOrg` is true
      country: widget.isOrg && countryController.text != widget.user.country
          ? countryController.text
          : null,
      businessRegNumber: widget.isOrg &&
              businessRegNumberController.text != widget.user.businessRegNumber
          ? businessRegNumberController.text
          : null,
      website: widget.isOrg && websiteController.text != widget.user.website
          ? websiteController.text
          : null,
    );

    // Update the user model
    setState(() {
      // widget.user = updatedUser;
    });
    if (widget.isOrg) {
      await userController.updateUserAndBussines(
          userModel: updatedUser, bussnessLogo: imageFile);
    } else {
      await userController.updateUserAndBussines(
          userModel: updatedUser, profilePic: imageFile);
    }
    // Provide feedback or navigate back
    //  Get.back();
    Get.snackbar("Success", "Profile updated successfully!");
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    bioController.dispose();

    if (widget.isOrg) {
      countryController.dispose();
      businessRegNumberController.dispose();
      websiteController.dispose();
      teamController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return userController.isBusy.value
            ? const Loading()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.arrow_back_ios),
                              ),
                              Text(
                                widget.isOrg
                                    ? "Organization"
                                    : "Profile Details",
                                style: AppTextStyle.body(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    widget.isOrg
                        ? Container(
                            height: 130,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: AppColor.filledColor,
                              borderRadius: BorderRadius.circular(8),
                              image: imageFile != null
                                  ? DecorationImage(
                                      image: FileImage(imageFile!))
                                  : null,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: _selectImages,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.filledColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColor.primaryColor,
                                      )),
                                  height: 33,
                                  width: 126,
                                  child: Center(
                                    child: Text(
                                      "Add company logo",
                                      style: AppTextStyle.body(size: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 55,
                                  backgroundImage: imageFile != null
                                      ? FileImage(imageFile!)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: _selectImages,
                                    child: Container(
                                      height: 25,
                                      width: 34,
                                      decoration: BoxDecoration(
                                        color: AppColor.primaryColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.camera_enhance,
                                          color: AppColor.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 30),
                    widget.isOrg
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                ProfileTextEditor(
                                  label: "Business Name",
                                  controller: nameController,
                                ),
                                ProfileTextEditor(
                                  label: "Country",
                                  controller: countryController,
                                ),
                                ProfileTextEditor(
                                  label: "Business Reg number",
                                  controller: businessRegNumberController,
                                ),
                                ProfileTextEditor(
                                  label: "Website",
                                  controller: websiteController,
                                ),
                                ProfileTextEditor(
                                  label: "Team",
                                  controller: teamController,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                ProfileTextEditor(
                                  label: "Name",
                                  controller: nameController,
                                ),
                                ProfileTextEditor(
                                  label: "Email",
                                  controller: emailController,
                                ),
                                ProfileTextEditor(
                                  label: "Phone number",
                                  controller: phoneController,
                                ),
                                ProfileTextEditor(
                                  label: "Address",
                                  controller: addressController,
                                ),
                                ProfileTextEditor(
                                  label: "Bio",
                                  controller: bioController,
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: AppButton(
                        onTab: _saveProfile,
                        title: "Save",
                      ),
                    )
                  ],
                ),
              );
      }),
    );
  }
}

class ProfileTextEditor extends StatelessWidget {
  const ProfileTextEditor({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 10.0).copyWith(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.body(size: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: "Enter your $label",
                hintStyle:
                    AppTextStyle.body(size: 14, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
