import 'dart:io';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/team_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({super.key});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  TeamController teamController = Get.put(TeamController());
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectImages() async {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        imageFile = File(selectedImage.path);
      });
    }
  }

  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  void _saveMember() {
    if (_validateForm()) {
      teamController.createTeam(
        teamName: fullNameController.text,
        teamEmail: emailController.text,
        teamPosition: positionController.text,
        teamLocation: locationController.text,
        profilePic: imageFile, // Optional if null
      );
    } else {
      Get.snackbar("Error", "Please fix errors before submitting.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 80),
                Row(
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
                          "Add Member",
                          style: AppTextStyle.body(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                CreateTextEditor(
                  label: "Full name",
                  controller: fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Full name is required";
                    }
                    return null;
                  },
                ),
                CreateTextEditor(
                  label: "Email address",
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email address is required";
                    } else if (!GetUtils.isEmail(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                CreateTextEditor(
                  label: "Team position",
                  controller: positionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Position is required";
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () {},
                  child: CreateTextEditor(
                    readOnly: true,
                    label: "Location",
                    controller: locationController,
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode:
                            false, // optional, to show or hide phone code
                        onSelect: (Country country) {
                          locationController.text =
                              country.name; // Update the location field
                        },
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Location is required";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 130,
                  width: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColor.filledColor,
                    borderRadius: BorderRadius.circular(8),
                    image: imageFile != null
                        ? DecorationImage(image: FileImage(imageFile!))
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
                        width: 86,
                        child: Center(
                          child: Text(
                            "Add Photo",
                            style: AppTextStyle.body(size: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                AppButton(
                  onTab: _saveMember,
                  title: "Save",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateTextEditor extends StatelessWidget {
  const CreateTextEditor(
      {super.key,
      required this.label,
      required this.controller,
      required this.validator,
      this.readOnly = false,
      this.onTap});
  final bool readOnly;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.body(size: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          TextFormField(
            onTap: onTap,
            readOnly: readOnly,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: "Enter your $label",
              hintStyle: AppTextStyle.body(
                size: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
