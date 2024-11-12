import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/chat_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/models/chat_rooms.dart';
import 'package:cabonconnet/views/chat/forum_chat.dart';
import 'package:cabonconnet/views/chat/recent_chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ChatAndForum extends StatefulWidget {
  const ChatAndForum({super.key});

  @override
  State<ChatAndForum> createState() => _ChatAndForumState();
}

class _ChatAndForumState extends State<ChatAndForum> {
  final TextEditingController addressController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Chat and Forum
      child: Obx(() {
        // ignore: invalid_use_of_protected_member
        List<ChatRoom> chatRooms = chatController.chatRooms.value;
        chatRooms.sort((a, b) =>
            b.lastMessage!.createdAt.compareTo(a.lastMessage!.createdAt));
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                profileController.userModelRx.value?.profileImage != null
                    ? CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            profileController
                                    .userModelRx.value?.profileImage! ??
                                ""),
                      )
                    : const CircleAvatar(
                        child: Icon(Icons.person), // Optional placeholder icon
                      ),
                const SizedBox(
                    width: 10), // Space between avatar and search field
                SizedBox(
                  height: 40,
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  child: TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      fillColor: const Color(0xffF2F2F2),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      suffixIcon: const Icon(
                        IconsaxPlusLinear.search_normal_1,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottom: const TabBar(
              indicatorColor: Colors.blue,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4),
                  insets: EdgeInsets.symmetric(horizontal: 60)),
              tabs: [
                Tab(text: "Inbox"),
                Tab(text: "Forum"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              RecentChat(
                chatRooms: chatRooms,
                currentUserId: currentUserId ?? "",
              ), // Pass chatRooms here
              ForumChat(chatRooms: chatRooms), //
            ],
          ),
        );
      }),
    );
  }
}
