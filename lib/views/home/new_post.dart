import 'dart:io';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:cabonconnet/views/widget/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final PostController postController = Get.put(PostController());
  final TextEditingController contentEditingController =
      TextEditingController();

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
        return postController.isBusy.value
            ? const Loading()
            : Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 70),
                          Text(
                            'Create a post',
                            style: AppTextStyle.body(
                                size: 22, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          const ProfileWidget(),
                          const SizedBox(height: 7),
                          const Divider(),
                          Expanded(
                            child: TextFormField(
                              controller: contentEditingController,
                              onChanged: (value) {
                                setState(() {
                                  hashTags = value.extractHashtags();
                                });
                              },
                              style: AppTextStyle.body(
                                  size: 14, fontWeight: FontWeight.normal),
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: 'Write your post...',
                                border: InputBorder.none,
                                hintStyle: AppTextStyle.body(
                                    size: 12, fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          imageFiles.isNotEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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
                                            onTap: () => _removeImage(index),
                                            child: Container(
                                              decoration: const BoxDecoration(
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
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: _selectImages,
                                  child: Row(
                                    children: [
                                      const Icon(IconsaxPlusLinear.image,
                                          size: 20),
                                      const SizedBox(width: 6),
                                      Text('Select image',
                                          style: AppTextStyle.body(
                                              size: 14,
                                              fontWeight: FontWeight.normal)),
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
                                    postController.createPost(
                                        content: contentEditingController.text,
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
