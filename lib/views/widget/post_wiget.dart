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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CommentScreen(
                      postModel: widget.postModel,
                    )));
      },
      child: Padding(
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
                    : CircleAvatar(),
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
                const Icon(IconsaxPlusLinear.menu)
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
              children: [
                // Icon(
                //   widget.postModel.likes!.any((e) => e["user"] == currentUserId)
                //       ? Icons.favorite
                //       : Icons.favorite_border,
                //   size: 16,
                //   color: widget.postModel.likes!
                //           .any((e) => e["user"] == currentUserId)
                //       ? Colors.red
                //       : null,
                // ),
                Icon(
                  Icons.favorite_border,
                  size: 16,
                ),
                const SizedBox(width: 3),
                Text(
                  "${widget.postModel.likes?.length ?? 0}",
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal),
                ),
                const Spacer(),
                Text(
                  '${widget.postModel.comments?.length ?? 0} comments',
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
                )
              ],
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
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
                      onTap: () {},
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
      print(imageUrls);
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
