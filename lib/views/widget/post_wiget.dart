import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/views/home/comment_screen.dart';
import 'package:cabonconnet/views/widget/user_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:like_button/like_button.dart';

class PostWidget extends StatefulWidget {
  final PostModel postModel;

  const PostWidget({super.key, required this.postModel});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String? currentUserId;
  PostController postController = Get.put(PostController());

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
                    AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
            ListTile(
              onTap: () {
                //   Get.to(() => const NewPost());
              },
              leading: Image.asset(AppImages.messageIcon),
              title: Text(
                "Message user",
                style:
                    AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
            ListTile(
              onTap: () {
                //   Get.to(() => const NewPost());
              },
              leading: Image.asset(AppImages.shareIcon),
              title: Text(
                "Share via",
                style:
                    AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
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
                    AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
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
                      backgroundImage:
                          NetworkImage(widget.postModel.user!.profileImage!),
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
            style: AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 5),
          _buildImageGallery(widget.postModel.imageUrls),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LikeButton(
                size: 16,
                likeBuilder: (bool isLiked) {
                  bool isLikeds =
                      widget.postModel.likes!.contains(currentUserId);
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
                        size: 13, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.circle, size: 6),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.postModel.sharedBy?.length ?? 0} shares',
                    style: AppTextStyle.body(
                        size: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              )
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UserButton(
                    onTap: () {
                      postController.toggleLike(widget.postModel.id);
                    },
                    iconData: IconsaxPlusLinear.like_1,
                    text: 'Like'),
                UserButton(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                    postModel: widget.postModel,
                                  )));
                    },
                    iconData: IconsaxPlusLinear.message,
                    text: 'Comment'),
                UserButton(
                    onTap: () {},
                    iconData: IconsaxPlusLinear.share,
                    text: 'Share'),
                UserButton(
                    onTap: () {},
                    iconData: IconsaxPlusLinear.send_2,
                    text: 'Send'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(List<String> imageUrls) {
    if (imageUrls.isEmpty) {
      return Container(); // No images to show
    } else if (imageUrls.length == 1) {
      return SizedBox(
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: imageUrls[0],
          fit: BoxFit.cover,
        ),
      );
    } else if (imageUrls.length == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: imageUrls
            .map((url) => Expanded(
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                  ),
                ))
            .toList(),
      );
    } else if (imageUrls.length == 3) {
      return SizedBox(
        height: 100, // Adjust height as needed
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                fit: BoxFit.cover,
                width: 100, // Fixed width for each image
              ),
            );
          },
        ),
      );
    } else {
      // For more than 3 images, use StaggeredGridView
      return SizedBox(
        height: 200, // Adjust height as needed
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            childAspectRatio: 1, // Adjust aspect ratio
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: imageUrls[index],
              fit: BoxFit.cover,
            );
          },
        ),
      );
    }
  }
}
