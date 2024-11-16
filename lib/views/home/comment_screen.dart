import 'package:cabonconnet/controllers/comment_controller.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/views/home/new_post.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../widget/widget.dart';

class CommentScreen extends StatefulWidget {
  final PostModel postModel;
  const CommentScreen({super.key, required this.postModel});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController editingController = TextEditingController();
  final CommentController commentController = Get.put(CommentController());
  final PostController postController = Get.put(PostController());
  UserModel? user = Get.put(ProfileController()).userModelRx.value;

  @override
  void initState() {
    super.initState();
    commentController.fetchComments(widget.postModel.id);
    commentController.setupRealtimeComments(
        widget.postModel.id); // Set up real-time updates once
  }

  Future<void> refreshData() async {
    await postController.getPost(widget.postModel.id); // Reload post data
    await commentController
        .fetchComments(widget.postModel.id); // Fetch updated comments
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(height: 5),
                  PostWidget(
                    postModel: widget.postModel,
                    isComment: true,
                  ),
                  const CustomDivider(),
                ],
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentController.comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            comment.userProfileImage != null
                                ? CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        comment.userProfileImage!),
                                  )
                                : CircleAvatar(
                                    child: Text(comment.userFullName![0]),
                                  ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xffF5F5F5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.userFullName?.capitalizeFirst ??
                                          "",
                                      style: AppTextStyle.body(
                                          size: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      comment.content,
                                      style: AppTextStyle.body(
                                          size: 13,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewPost())),
                      child: user == null
                          ? const CircleAvatar()
                          : user?.profileImage != null
                              ? CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      user!.profileImage!),
                                )
                              : CircleAvatar(
                                  child: Text(user!.fullName[0].toUpperCase()),
                                )),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: editingController,
                      maxLines: 5,
                      minLines: 1,
                      style: AppTextStyle.body(
                          fontWeight: FontWeight.normal, size: 14),
                      decoration: InputDecoration(
                        hintText: 'Add comment',
                        hintStyle: AppTextStyle.body(
                            size: 12, fontWeight: FontWeight.normal),
                        filled: true,
                        fillColor: const Color(0xffF5F5F5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (editingController.text.isNotEmpty) {
                        commentController.addComment(
                          postId: widget.postModel.id,
                          content: editingController.text,
                        );
                        editingController.clear(); // Clear input after comment
                      }
                    },
                    child: const Icon(IconsaxPlusBold.send_2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
