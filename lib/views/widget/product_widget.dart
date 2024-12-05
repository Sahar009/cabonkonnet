import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/controllers/chat_controller.dart';
import 'package:cabonconnet/controllers/post_controller.dart';
import 'package:cabonconnet/controllers/saved_post_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/views/chat/message.dart';
import 'package:cabonconnet/views/home/product_detail.dart';
import 'package:cabonconnet/views/profile/profile_view.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class ProductWidget extends StatefulWidget {
  final ProductModel productModel;

  const ProductWidget({
    super.key,
    required this.productModel,
  });

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
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
                savedPostController.savePost(widget.productModel.id);
                Get.back();
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
                    currentUserId!, widget.productModel.user?.id ?? "");
                Get.back();
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
                //     currentUserId!, widget.productModel.user?.id ?? "");
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
              onTap: () {
                Get.back();
                showDialog(
                    context: context,
                    builder: (context) =>
                        ReportUser(userId: widget.productModel.user?.id ?? ""));
              },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() =>
                      ProfileView(userId: widget.productModel.user?.id ?? ""));
                },
                child: Row(
                  children: [
                    widget.productModel.user?.profileImage != null
                        ? CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                widget.productModel.user!.profileImage!),
                          )
                        : const CircleAvatar(),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productModel.user?.fullName ?? "",
                          style: AppTextStyle.body(
                            fontWeight: FontWeight.w500,
                            size: 16,
                          ),
                        ),
                        Text(widget.productModel.user?.country ?? "")
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => _showPostOptions(context),
                        child: const Icon(Icons.more_vert))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ReadMoreText(
                  widget.productModel.description,
                  textAlign: TextAlign.start,
                  trimLines: 4,
                  trimMode: TrimMode.Line,
                  colorClickableText: Colors.pink,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  annotations: [
                    Annotation(
                      regExp: RegExp(r'#([a-zA-Z0-9_]+)'),
                      spanBuilder: (
                              {required String text, TextStyle? textStyle}) =>
                          TextSpan(
                        text: text,
                        style: textStyle?.copyWith(color: Colors.blue),
                      ),
                    ),
                    Annotation(
                      regExp: RegExp(r'<@(\d+)>'),
                      spanBuilder: (
                              {required String text, TextStyle? textStyle}) =>
                          TextSpan(
                        text: 'User123',
                        style: textStyle?.copyWith(color: Colors.green),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle tap, e.g., navigate to a user profile
                          },
                      ),
                    ),
                    // Additional annotations for URLs...
                  ],
                  style: AppTextStyle.body(
                      size: 14, fontWeight: FontWeight.normal),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        BuildImageWidget(imageUrls: widget.productModel.imageUrls),
        const SizedBox(height: 10),
        Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15),
              child: AppButton(
                onTab: () {
                  Get.to(
                      () => ProductDetails(productModel: widget.productModel));
                },
                title: "View product details",
                color: null,
                textColor: AppColor.primaryColor,
              ),
            ),
          ],
        ),
        const CustomDivider()
      ],
    );
  }
}

class ReportUser extends StatefulWidget {
  final String userId;
  const ReportUser({super.key, required this.userId});

  @override
  State<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  final AuthController reportController = Get.put(AuthController());
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        return Container(
          height: 350,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: reportController.isBusy.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Dialog title
                    Center(
                      child: Text(
                        "Report User",
                        style: AppTextStyle.soraBody(size: 17),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Help us maintain a safe and respectful community.",
                      style: AppTextStyle.soraBody(
                          size: 14, fontWeight: FontWeight.normal),
                    ),
                    10.toHeightWhiteSpacing(),

                    TextField(
                      controller: reasonController,
                      decoration: InputDecoration(
                        labelText: "Reason (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: AppButton(
                            onTab: () {
                              Get.back();
                            },
                            title: "Cancel",
                            color: AppColor.white,
                            textColor: AppColor.primaryColor,
                          ),
                        ),

                        // Confirm Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: AppButton(
                            onTab: () {
                              final userId = widget.userId.trim();
                              final reason = reasonController.text.trim();

                              reportController.reportUser(
                                userId: userId,
                                reason: reason.isNotEmpty ? reason : null,
                              );
                              Get.back();
                            },
                            title: "Confirm",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      }),
    );
  }
}



// import 'package:cabonkonnet_admin/constant/app_color.dart';
// import 'package:cabonkonnet_admin/constant/app_images.dart';
// import 'package:cabonkonnet_admin/constant/local_storage.dart';
// import 'package:cabonkonnet_admin/controllers/chat_controller.dart';
// import 'package:cabonkonnet_admin/controllers/post_controller.dart';
// import 'package:cabonkonnet_admin/controllers/saved_post_controller.dart';
// import 'package:cabonkonnet_admin/helpers/textstyles.dart';
// import 'package:cabonkonnet_admin/models/post_model.dart';
// import 'package:cabonkonnet_admin/models/user_model.dart';

// import 'package:cabonkonnet_admin/views/widget/widget.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:get/get.dart';
// import 'package:like_button/like_button.dart';

// class ProductWidget extends StatefulWidget {
//   final productModel productModel;
//   final bool isComment;

//   const ProductWidget({
//     super.key,
//     required this.productModel,
//     required this.isComment,
//   });

//   @override
//   State<ProductWidget> createState() => _ProductWidgetState();
// }

// class _ProductWidgetState extends State<ProductWidget> {
//   final PostController postController = Get.put(PostController());
//   final SavedPostController savedPostController =
//       Get.put(SavedPostController());
//   final ChatController chatController = Get.put(ChatController());
//   String? currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     AppLocalStorage.getCurrentUserId().then((value) {
//       setState(() {
//         currentUserId = value;
//       });
//     });
//   }

//   void _showPostOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (context) => _PostOptions(
//         currentUserId: currentUserId,
//         productModel: widget.productModel,
//         chatController: chatController,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _PostHeader(
//           user: widget.productModel.user,
//           onOptionsTap: () => _showPostOptions(context),
//         ),
//         const SizedBox(height: 10),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Text(
//             widget.productModel.content,
//             style: AppTextStyle.body(size: 14, fontWeight: FontWeight.normal),
//           ),
//         ),
//         const SizedBox(height: 5),
//         BuildImageWidget(imageUrls: widget.productModel.imageUrls),
//         const SizedBox(height: 10),
//         if (!widget.productModel.isProduct)
//           _PostActions(
//             productModel: widget.productModel,
//             currentUserId: currentUserId,
//             postController: postController,
//           ),
//         if (!widget.productModel.isProduct) const CustomDivider(),
//         if (widget.productModel.isProduct)
//           _ProductActions(
//             productModel: widget.productModel,
//           ),
//       ],
//     );
//   }
// }

// // Modular components for reuse and cleaner structure
// class _PostHeader extends StatelessWidget {
//   final UserModel? user;
//   final VoidCallback onOptionsTap;

//   const _PostHeader({required this.user, required this.onOptionsTap});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         children: [
//           user?.profileImage != null
//               ? CircleAvatar(
//                   backgroundImage:
//                       CachedNetworkImageProvider(user!.profileImage!),
//                 )
//               : const CircleAvatar(),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 user?.fullName ?? "Unknown User",
//                 style: AppTextStyle.body(fontWeight: FontWeight.w500, size: 16),
//               ),
//               Text(user?.country ?? ""),
//             ],
//           ),
//           const Spacer(),
//           GestureDetector(
//             onTap: onOptionsTap,
//             child: const Icon(Icons.more_vert),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PostActions extends StatelessWidget {
//   final productModel productModel;
//   final String? currentUserId;
//   final PostController postController;

//   const _PostActions({
//     required this.productModel,
//     required this.currentUserId,
//     required this.postController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool isLiked = productModel.likes?.contains(currentUserId) ?? false;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           LikeButton(
//             size: 16,
//             isLiked: isLiked,
//             likeCount: productModel.likes?.length,
//             onTap: (isLiked) async {
//               return await postController.toggleLike(productModel.id);
//             },
//           ),
//           Text(
//             '${productModel.commentCount ?? 0} comments',
//             style: AppTextStyle.body(size: 14),
//           ),
//           Text(
//             '${productModel.sharedBy?.length ?? 0} shares',
//             style: AppTextStyle.body(size: 14),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ProductActions extends StatelessWidget {
//   final productModel productModel;

//   const _ProductActions({required this.productModel});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//       child: AppButton(
//         onTab: () {
//           // Navigate to product details
//         },
//         title: "View product details",
//         color: null,
//         textColor: AppColor.primaryColor,
//       ),
//     );
//   }
// }

// class _PostOptions extends StatelessWidget {
//   final String? currentUserId;
//   final productModel productModel;
//   final ChatController chatController;

//   const _PostOptions({
//     required this.currentUserId,
//     required this.productModel,
//     required this.chatController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       height: 220,
//       child: Column(
//         children: [
//           _PostOptionItem(
//             icon: AppImages.saveIcon,
//             title: "Save",
//             onTap: () {},
//           ),
//           _PostOptionItem(
//             icon: AppImages.messageIcon,
//             title: "Message user",
//             onTap: () async {
//               await chatController.initiateChat(
//                 currentUserId!,
//                 productModel.user?.id ?? "",
//               );
//             },
//           ),
//           _PostOptionItem(
//             icon: AppImages.shareIcon,
//             title: "Share via",
//             onTap: () {},
//           ),
//           _PostOptionItem(
//             icon: AppImages.reportIcon,
//             title: "Report user",
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PostOptionItem extends StatelessWidget {
//   final String icon;
//   final String title;
//   final VoidCallback onTap;

//   const _PostOptionItem({
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       leading: Image.asset(icon),
//       title: Text(title, style: AppTextStyle.body(size: 15)),
//     );
//   }
// }
