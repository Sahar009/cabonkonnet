import 'dart:io';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../widget/widget.dart';

class ShowcaseProduct extends StatefulWidget {
  const ShowcaseProduct({super.key});

  @override
  State<ShowcaseProduct> createState() => _ShowcaseProductState();
}

ProfileController profileController = Get.put(ProfileController());

class _ShowcaseProductState extends State<ShowcaseProduct> {
  final PostController postController = Get.put(PostController());
  // Define TextEditingController for each field
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productLevelController = TextEditingController();
  final TextEditingController productGoalsController = TextEditingController();
  final TextEditingController fundsNeededController = TextEditingController();
  final TextEditingController productImpactController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();
  String? selectedLevel;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    productNameController.dispose();
    productDescriptionController.dispose();
    productLevelController.dispose();
    productGoalsController.dispose();
    fundsNeededController.dispose();
    productImpactController.dispose();
    additionalNotesController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile> imageFiles = [];
  List<String> hashTags = [];

  Future<void> _selectImages() async {
    if (imageFiles.length >= 6) {
      Get.snackbar("Maximum", "The maximum number of images you can pick is 6");
      return;
    }
    final List<XFile> selectedImages = await _picker.pickMultiImage(limit: 6);
    setState(() {
      imageFiles.addAll(selectedImages);
    });
  }

  void _removeImage(int index) {
    setState(() {
      imageFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: ListView(
            children: [
              postController.isBusy.value
                  ? const Loading()
                  : SingleChildScrollView(
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 70),
                              Text(
                                'Showcase Product',
                                style: AppTextStyle.body(
                                    size: 22, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 20),
                              const ProfileWidget(),
                              const SizedBox(height: 7),
                              const CustomDivider(),
                              const SizedBox(height: 15),
                              Text(
                                'Product Name',
                                style: AppTextStyle.body(size: 16),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller:
                                    productNameController, // Assign controller
                                style: AppTextStyle.body(
                                    fontWeight: FontWeight.normal, size: 12),
                                decoration: InputDecoration(
                                  hintText: 'Enter product name',
                                  hintStyle: AppTextStyle.body(
                                      size: 14, fontWeight: FontWeight.normal),
                                  filled: true,
                                  fillColor: const Color(0xffF5F5F5),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Product Description',
                                style: AppTextStyle.body(size: 16),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller:
                                    productDescriptionController, // Assign controller
                                style: AppTextStyle.body(
                                    fontWeight: FontWeight.normal, size: 12),
                                maxLines: 9,
                                decoration: InputDecoration(
                                  hintText: 'Describe your product',
                                  hintStyle: AppTextStyle.body(
                                      size: 14, fontWeight: FontWeight.normal),
                                  filled: true,
                                  fillColor: const Color(0xffF5F5F5),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Product Level',
                                style: AppTextStyle.body(size: 16),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: selectedLevel,
                                items: ["not_started", "in_progres", "launched"]
                                    .map((String country) {
                                  return DropdownMenuItem<String>(
                                    value: country,
                                    child: Text(country),
                                  );
                                }).toList(),
                                style: AppTextStyle.body(
                                    size: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppColor.black),
                                decoration: InputDecoration(
                                  hintText: 'Select country',
                                  hintStyle: AppTextStyle.body(
                                      size: 12,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.black),
                                  filled: true,
                                  fillColor: const Color(0xffF5F5F5),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 14),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    selectedLevel = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a country'
                                    : null, // Validator
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 15),
                              Text(
                                'Product Goals',
                                style: AppTextStyle.body(size: 16),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller:
                                    productGoalsController, // Assign controller
                                style: AppTextStyle.body(
                                    fontWeight: FontWeight.normal, size: 12),
                                maxLines: 9,
                                decoration: InputDecoration(
                                  hintText: 'Describe your product goals',
                                  hintStyle: AppTextStyle.body(
                                      size: 14, fontWeight: FontWeight.normal),
                                  filled: true,
                                  fillColor: const Color(0xffF5F5F5),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Funds Needed',
                                style: AppTextStyle.body(size: 16),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller:
                                    fundsNeededController, // Assign controller
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: AppTextStyle.body(
                                    fontWeight: FontWeight.normal, size: 12),
                                decoration: InputDecoration(
                                  hintText: 'Enter amount needed',
                                  hintStyle: AppTextStyle.body(
                                      size: 14, fontWeight: FontWeight.normal),
                                  filled: true,
                                  fillColor: const Color(0xffF5F5F5),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Product Impact',
                                style: AppTextStyle.body(size: 16),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller:
                                    productImpactController, // Assign controller
                                style: AppTextStyle.body(
                                    fontWeight: FontWeight.normal, size: 12),
                                maxLines: 9,
                                decoration: InputDecoration(
                                  hintText: 'Describe product impact',
                                  hintStyle: AppTextStyle.body(
                                      size: 14, fontWeight: FontWeight.normal),
                                  filled: true,
                                  fillColor: const Color(0xffF5F5F5),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const SizedBox(height: 15),
                              imageFiles.isNotEmpty
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0,
                                      ),
                                      itemCount: imageFiles.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                image: FileImage(
                                                  File(imageFiles[index].path),
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                            ),
                                            Positioned(
                                              right: -2,
                                              top: -2,
                                              child: GestureDetector(
                                                onTap: () =>
                                                    _removeImage(index),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColor.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _selectImages,
                        child: Row(
                          children: [
                            const Icon(IconsaxPlusLinear.image, size: 20),
                            const SizedBox(width: 6),
                            Text('Select image',
                                style: AppTextStyle.body(
                                    size: 14, fontWeight: FontWeight.normal)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            hashTags.isNotEmpty
                                ? hashTags.join(" ")
                                : '# Hashtag',
                            style: AppTextStyle.body(
                                color: AppColor.primaryColor,
                                size: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          postController.createPostProduct(
                              productsDescription:
                                  productDescriptionController.text,
                              fundNeeded:
                                  double.parse(fundsNeededController.text),
                              productsName: productNameController.text,
                              productsGoal: productGoalsController.text,
                              productsImpact: productImpactController.text,
                              productsLevel: selectedLevel!,
                              hashtags: hashTags,
                              files: imageFiles);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text('Post',
                              style: AppTextStyle.body(
                                  color: AppColor.white,
                                  size: 14,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }
}
