import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/core.dart';

import 'package:cabonconnet/views/home/showcase_product.dart';
import 'package:cabonconnet/views/widget/custom_text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widget/widget.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

ProfileController profileController = Get.put(ProfileController());

class _CreateProductState extends State<CreateProduct> {
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

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: ListView(children: [
              postController.isBusy.value
                  ? const Loading()
                  : SingleChildScrollView(
                      child: SizedBox(
                          child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppBackBotton(
                            pageTitle: 'Showcase Product',
                            vertical: true,
                          ),
                          const ProfileWidget(),
                          10.toHeightWhiteSpacing(),
                          const CustomDivider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Card(
                              elevation: 5,
                              color: AppColor.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextField(
                                      controller: productNameController,
                                      labelText: 'Product Name',
                                      hintText: 'Enter product name',
                                    ),
                                    CustomTextField(
                                      controller: productDescriptionController,
                                      labelText: 'Product Description',
                                      hintText: 'Describe your product',
                                      maxLines: 9,
                                    ),
                                    CustomTextField(
                                      controller: productLevelController,
                                      labelText: 'Product Level',
                                      hintText: 'Select product level',
                                      isDropdown: true,
                                      dropdownItems: const [
                                        "not_started",
                                        "in_progres",
                                        "launched"
                                      ],
                                      dropdownValue: selectedLevel,
                                      onDropdownChanged: (value) {
                                        setState(() {
                                          selectedLevel = value;
                                        });
                                      },
                                    ),
                                    CustomTextField(
                                      controller: productGoalsController,
                                      labelText: 'Product Goals',
                                      hintText: 'Describe your product goals',
                                      maxLines: 9,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AppButton(
                            onTab: () {
                              Get.to(() => ShowcaseProduct(
                                    productDescription:
                                        productDescriptionController.text,
                                    productGoal: productGoalsController.text,
                                    productLevel:
                                        selectedLevel ?? "not_started",
                                    productName: productNameController.text,
                                  ));
                            },
                            title: "Continue",
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    )))
            ]));
      }),
    );
  }
}
