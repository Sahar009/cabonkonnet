import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/views/chat/forum_chat.dart';
import 'package:cabonconnet/views/chat/recent_chat.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Chat and Forum
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              profileController.userModelRx.value?.profileImage != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                          profileController.userModelRx.value?.profileImage! ??
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
          bottom: TabBar(
            indicatorColor: Colors.blue,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 4),
                insets: EdgeInsets.symmetric(horizontal: 60)),
            tabs: [
              Tab(text: "Chat"),
              Tab(text: "Forum"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RecentChat(),
            ForumChat(),
          ],
        ),
      ),
    );
  }
}