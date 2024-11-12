import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/controllers/comment_controller.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/views/home/new_post.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CommentScreen extends StatefulWidget {
  final PostModel postModel;
  const CommentScreen({super.key, required this.postModel});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController editingController = TextEditingController();
  final CommentController commentController = Get.put(CommentController());

  @override
  void initState() {
    super.initState();
    // Load comments for the specific post
    commentController.fetchComments(widget.postModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                PostWidget(postModel: widget.postModel, isComment: true,),
                const Divider(),
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
                          const Image(image: AssetImage(AppImages.smallpicture1)),
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
                                    comment.userFullName?.capitalizeFirst ?? "",
                                    style: AppTextStyle.body(
                                        size: 16, fontWeight: FontWeight.w500),
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
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const NewPost())),
                  child: const Image(image: AssetImage(AppImages.smallpicture2)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: editingController,
                    maxLines: 5,
                    minLines: 1,
                    style: AppTextStyle.body(
                        fontWeight: FontWeight.normal, size: 12),
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
    );
  }
}
