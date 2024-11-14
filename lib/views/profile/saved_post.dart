import 'dart:developer';

import 'package:cabonconnet/controllers/saved_post_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/views/widget/no_file.dart';
import 'package:cabonconnet/views/widget/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedPost extends StatefulWidget {
  final UserModel user;

  const SavedPost({
    super.key,
    required this.user,
  });

  @override
  State<SavedPost> createState() => _SavedPostState();
}

class _SavedPostState extends State<SavedPost> {
  final SavedPostController savedPostController =
      Get.find<SavedPostController>();

  @override
  void initState() {
    super.initState();
    // Fetch the user's saved posts when this screen loads
    savedPostController.getUserSavedPosts(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      "Saved Posts",
                      style: AppTextStyle.body(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              // Check if loading
              if (savedPostController.isBusy.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Check if there are saved posts
              if (savedPostController.savedPostsList.isEmpty) {
                return const NoDocument(
                  title: "No saved posts found.",
                );
              }
              // Display saved posts list
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: savedPostController.savedPostsList.length,
                itemBuilder: (context, index) {
                  final post = savedPostController.savedPostsList.map((e) {
                    log(e.toString());
                    return PostModel.fromMap(e["post"]);
                  }).toList();
                  return PostWidget(
                    postModel: post[index],
                    isComment: false,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// PostCard widget for displaying each saved post
class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'] ?? 'Untitled Post',
              style: AppTextStyle.body(
                size: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post['description'] ?? 'No description available.',
              style: AppTextStyle.body(
                size: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            if (post['imageUrl'] != null) // Display image if available
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post['imageUrl'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
