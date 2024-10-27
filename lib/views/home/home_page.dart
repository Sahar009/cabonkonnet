import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:cabonconnet/views/widget/post_wiget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:iconsax_plus/iconsax_plus.dart'; // Import your PostController

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostController postController = Get.put(PostController());
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Image(image: AssetImage(AppImages.homelogo)),
                  Expanded(
                    child: AppTextFields(
                      controller: addressController,
                      hint: 'Search',
                      iconData: IconsaxPlusLinear.search_normal_1,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        postController.fetchAllPosts();
                      },
                      child: const Icon(IconsaxPlusLinear.notification))
                ],
              ),
              const SizedBox(height: 5),
              // Use Obx to reactively display posts
              Obx(() {
                if (postController.posts.isEmpty) {
                  return Center(child: Text('No posts available'));
                }
                return Column(
                  children: postController.posts.map((post) {
                    return PostWidget(
                      postModel: post,
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
