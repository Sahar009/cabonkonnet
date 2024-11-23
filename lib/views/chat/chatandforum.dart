import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/chat_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/models/chat_rooms.dart';
import 'package:cabonconnet/views/chat/forum_chat.dart';
import 'package:cabonconnet/views/chat/recent_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../widget/widget.dart';

class ChatAndForum extends StatefulWidget {
  const ChatAndForum({super.key});

  @override
  State<ChatAndForum> createState() => _ChatAndForumState();
}

class _ChatAndForumState extends State<ChatAndForum> {
  final ChatController chatController = Get.put(ChatController());
  final ProfileController profileController = Get.put(ProfileController());

  TextEditingController searchController = TextEditingController();
  PageController pageController = PageController();
  bool isInbox = true;

  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    currentUserId = await AppLocalStorage.getCurrentUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          50.toHeightWhiteSpacing(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              children: [
                _buildProfileAvatar(),
                10.toWidthWhiteSpacing(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColor.filledColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 35,
                    child: const Row(
                      children: [
                        Icon(
                          IconsaxPlusLinear.search_normal,
                          size: 15,
                        ),
                        SizedBox(width: 10),
                        Text("Search"),
                      ],
                    ),
                  ),
                ),
                30.toWidthWhiteSpacing(),
                // GestureDetector(
                //   onTap: () {
                //     // CustomDialog.error();
                //   },
                //   child: SvgPicture.asset(AppImages.notify),
                // )
              ],
            ),
          ),
          _buildCustomTabs(),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  isInbox = index == 0;
                });
              },
              children: [
                Obx(() {
                  List<ChatRoom> chatRooms = chatController.chatRooms;
                  chatRooms.sort((a, b) => b.lastMessage!.createdAt
                      .compareTo(a.lastMessage!.createdAt));
                  return RecentChat(
                    chatRooms: chatRooms,
                    currentUserId: currentUserId ?? "",
                  );
                }),
                ForumChat(chatRooms: chatController.chatRooms),
              ],
            ),
          ),
        ],

      ),
    );
  }

  

  Widget _buildProfileAvatar() {
    final profileImage = profileController.currentUserModelRx.value?.profileImage;

    return CircleAvatar(
      backgroundImage: profileImage != null
          ? CachedNetworkImageProvider(profileImage)
          : null,
      child: profileImage == null ? const Icon(Icons.person) : null,
    );
  }

  Widget _buildCustomTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TabButton(
            isActive: isInbox,
            onTap: () {
              setState(() {
                isInbox = true;
              });
              pageController.jumpToPage(0);
            },
            title: "Inbox",
          ),
          50.toWidthWhiteSpacing(),
          TabButton(
            isActive: !isInbox,
            onTap: () {
              setState(() {
                isInbox = false;
              });
              pageController.jumpToPage(1);
            },
            title: "Forum",
          ),
        ],
      ),
    );
  }
}
