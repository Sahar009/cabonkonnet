import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/chat_controller.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:cabonconnet/controllers/saved_post_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/views/chat/message.dart';
import 'package:cabonconnet/views/home/comment_screen.dart';
import 'package:cabonconnet/views/home/product_detail.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/build_image.dart';
import 'package:cabonconnet/views/widget/user_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class PostWidget extends StatefulWidget {
  final PostModel postModel;
  final bool isComment;

  const PostWidget(
      {super.key, required this.postModel, required this.isComment});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  PostController postController = Get.put(PostController());
  SavedPostController savedPostController = Get.put(SavedPostController());
  ChatController chatController = Get.put(ChatController());
  String? currentUserId;
  @override
  void initState() {
    AppLocalStorage.getCurrentUserId().then((value) {
      setState(() {
        currentUserId = value;
      });
    });
    super.initState();
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40), // Reduced padding
        height: 220, // Adjust height if needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 16),
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              onTap: () {
                //   Get.to(() => const NewPost());
              },
              leading: Image.asset(AppImages.saveIcon),
              title: Text(
                "Save",
                style:
                    AppTextStyle.body(size: 15, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
            ListTile(
              onTap: () async {
                var chatRoom = await chatController.initiateChat(
                    currentUserId!, widget.postModel.user?.id ?? "");
                Get.to(() => MessagesScreen(
                      chatRoom: chatRoom,
                      currentUserId: currentUserId!,
                    ));
              },
              leading: Image.asset(AppImages.messageIcon),
              title: Text(
                "Message user",
                style:
                    AppTextStyle.body(size: 15, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
            ListTile(
              onTap: () async {
                // await chatController.initiateChat(
                //     currentUserId!, widget.postModel.user?.id ?? "");
                // Get.to(() => const MessagesScreen());
              },
              leading: Image.asset(AppImages.shareIcon),
              title: Text(
                "Share via",
                style:
                    AppTextStyle.body(size: 15, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset(AppImages.reportIcon),
              title: Text(
                "Report user",
                style:
                    AppTextStyle.body(size: 15, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.postModel.user?.profileImage != null
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          widget.postModel.user!.profileImage!),
                    )
                  : const CircleAvatar(),
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.postModel.user?.fullName ?? "",
                    style: AppTextStyle.body(fontWeight: FontWeight.w500),
                  ),
                  Text(widget.postModel.user?.country ?? "")
                ],
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () => _showPostOptions(context),
                  child: const Icon(Icons.more_vert))
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.postModel.content,
            style: AppTextStyle.body(size: 14, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 5),
          BuildImageWidget(imageUrls: widget.postModel.imageUrls),
          const SizedBox(height: 10),
          widget.postModel.isProduct
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LikeButton(
                      size: 16,
                      likeBuilder: (bool isLiked) {
                        bool isLikeds =
                            widget.postModel.likes?.contains(currentUserId) ??
                                false;
                        return Icon(
                          isLikeds ? Icons.favorite : Icons.favorite_border,
                          color: isLikeds ? Colors.red : Colors.grey,
                          size: 16,
                        );
                      },
                      likeCount: widget.postModel.likes?.length,
                      onTap: (isLiked) {
                        return postController.toggleLike(widget.postModel.id);
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.postModel.commentCount ?? 0} comments',
                          style: AppTextStyle.body(
                              size: 15, fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.circle, size: 6),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.postModel.sharedBy?.length ?? 0} shares',
                          style: AppTextStyle.body(
                              size: 15, fontWeight: FontWeight.normal),
                        ),
                      ],
                    )
                  ],
                ),
          if (!widget.postModel.isProduct) const Divider(),
          widget.postModel.isProduct
              ? Column(
                  children: [
                    15.toHeightWhiteSpacing(),
                    AppButton(
                      onTab: () {
                        Get.to(
                            () => ProductDetails(postModel: widget.postModel));
                      },
                      title: "View product details",
                      color: null,
                      textColor: AppColor.primaryColor,
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UserButton(
                          onTap: () {
                            postController.toggleLike(widget.postModel.id);
                          },
                          iconData: AppImages.like,
                          text: 'Like'),
                      if (!widget.isComment)
                        UserButton(
                            onTap: !widget.isComment
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                                  postModel: widget.postModel,
                                                )));
                                  }
                                : () {},
                            iconData: AppImages.comment,
                            text: 'Comment'),

                      UserButton(
                          onTap: () {},
                          iconData: AppImages.share,
                          text: 'Share'),
                      UserButton(
                          onTap: () {}, iconData: AppImages.send, text: 'Send'),

                      if (widget.isComment)
                        UserButton(
                            onTap: () {
                              savedPostController.savePost(widget.postModel.id);
                            },
                            iconData: AppImages.saveIcon,
                            text: 'Save'),
                      //  widget.isComment ? UserButton(
                      //   onTap:
                      //        () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => CommentScreen(
                      //                         postModel: widget.postModel,
                      //                       )));
                      //         }
                      //     ,
                      //   iconData: AppImages.comment,
                      //   text: 'Comment'),
                    ],
                  ),
                ),
          const Divider()
        ],
      ),
    );
  }
}
