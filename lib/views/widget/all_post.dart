import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/views/widget/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPost extends StatefulWidget {
  const AllPost({
    super.key,
  });

  @override
  State<AllPost> createState() => _AllPostState();
}

class _AllPostState extends State<AllPost> {
  PostController postController = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        if (postController.posts.isEmpty) {
          return const Center(child: Text('No posts available'));
        }
        return ListView.builder(
          itemCount: postController.posts
              .where((post) => !post.isProduct)
              .toList()
              .length,
          itemBuilder: (context, index) {
            List<PostModel> posts =
                postController.posts.where((post) => !post.isProduct).toList();
            PostModel post = posts[index];
            return PostWidget(
              postModel: post,
              isComment: false,
            );
          },
        );
      }),
    );
  }
}
