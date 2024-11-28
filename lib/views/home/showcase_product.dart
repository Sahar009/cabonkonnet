import 'dart:io';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/product_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widget/widget.dart';

class ShowcaseProduct extends StatefulWidget {
  final String productName;
  final String productLevel;
  final String productDescription;
  final String productGoal;
  const ShowcaseProduct(
      {
      super.key,
      required this.productName,
      required this.productLevel,
      required this.productDescription,
      required this.productGoal});

  @override
  State<ShowcaseProduct> createState() => _ShowcaseProductState();
}

ProfileController profileController = Get.put(ProfileController());

class _ShowcaseProductState extends State<ShowcaseProduct> {
  final ProductController postController = Get.put(ProductController());
  // Define TextEditingController for each field
  final TextEditingController fundsNeededController = TextEditingController();
  final TextEditingController productImpactController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();
  int _currentIndex = 0;
  String _selectedFundingType = 'Crowdfunding';
  @override
  void dispose() {
    // Dispose controllers to free up resources

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

  void _removeImage(index) {
    setState(() {
      imageFiles.remove(index);
    });
  }

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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          15.toHeightWhiteSpacing(),
                          Card(
                            elevation: 4,
                            color: AppColor.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: fundsNeededController,
                                    labelText: 'Funds Needed',
                                    hintText: 'Enter required funds',
                                  ),
                                  CustomTextField(
                                    controller: productImpactController,
                                    labelText: 'Product Impact',
                                    hintText: 'Describe the product impact',
                                    maxLines: 9,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          15.toHeightWhiteSpacing(),
                          Center(
                            child: Card(
                              color: AppColor.white,
                              elevation: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  10.toHeightWhiteSpacing(),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('Choose funding type',
                                        style: AppTextStyle.soraBody(
                                          size: 15,
                                        )),
                                  ),
                                  15.toHeightWhiteSpacing(),
                                  ListTile(
                                    title: Text('Investor',
                                        style: AppTextStyle.soraBody(size: 15)),
                                    trailing: Radio<String>(
                                      value: 'Investor',
                                      groupValue: _selectedFundingType,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFundingType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Crowdfunding',
                                        style: AppTextStyle.soraBody(
                                          fontWeight: FontWeight.normal,
                                          size: 15,
                                        )),
                                    trailing: Radio<String>(
                                      value: 'Crowdfunding',
                                      groupValue: _selectedFundingType,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedFundingType = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(18.0)
                                        .copyWith(top: 0),
                                    child: Text(
                                      'Note that once you start receiving funds you can’t reverse decision',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Card(
                            color: AppColor.white,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add images to show product',
                                    style: AppTextStyle.body(size: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  FlutterCarousel(
                                    options: FlutterCarouselOptions(
                                      initialPage: imageFiles.length + 1,
                                      height: 200.0,
                                      showIndicator: false,
                                      enlargeCenterPage: true,
                                      viewportFraction: 0.7,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndex = index;
                                          
                                        });
                                      },
                                    ),
                                    items: [
                                      // Map through the images and add the "Add Photo" box if less than 6 images
                                      ...imageFiles.map((imgFile) {
                                        return Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          decoration: BoxDecoration(
                                            color: AppColor.filledColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image:
                                                  FileImage(File(imgFile.path)),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                setState(() {
                                                  imageFiles.remove(imgFile);
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                      // Add the "Add Photo" box dynamically
                                      if (imageFiles.length < 6)
                                        GestureDetector(
                                          onTap: _selectImages,
                                          child: Container(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              color: AppColor.filledColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppColor.primaryColor),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Add Photo",
                                                style:
                                                    AppTextStyle.body(size: 12),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          10.toHeightWhiteSpacing(),
                          _buildCustomIndicator(imageFiles.length),
                          30.toHeightWhiteSpacing(),
                          AppButton(
                            onTab: () {
                              postController.createPostProduct(
                                  productsDescription:
                                      widget.productDescription,
                                  fundNeeded:
                                      double.parse(fundsNeededController.text),
                                  productsName: widget.productName,
                                  productsGoal: widget.productGoal,
                                  productsImpact: productImpactController.text,
                                  productsLevel: widget.productLevel,
                                  hashtags: hashTags,
                                  fundingType: _selectedFundingType,
                                  files: imageFiles);
                            },
                            title: "Post product",
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    )))
            ]));
      }),
    );
  }

  Widget _buildCustomIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width:
              _currentIndex == index ? 25 : 12, // Make active indicator larger
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _currentIndex == index
                ? AppColor.primaryColor
                : Colors.grey, // Active color vs inactive color
          ),
        ),
      ),
    );
  }
}
