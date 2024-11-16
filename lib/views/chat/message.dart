import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/chat_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/chat_rooms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

import '../widget/widget.dart';

class MessagesScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  final String currentUserId;

  const MessagesScreen({
    super.key,
    required this.chatRoom,
    required this.currentUserId,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextEditingController editingController = TextEditingController();
  final ChatController chatController = Get.put(ChatController());
  final ScrollController _scrollController = ScrollController(); // Step 1

  @override
  void initState() {
    super.initState();
    chatController.loadMessages(widget.chatRoom.id);
    chatController.setupRealtimeForChat(widget.chatRoom.id);

    chatController.messages.listen((_) {
      // Delay to ensure the message list is updated
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final (friend, name) = chatController.getChatParticipantInfo(
        widget.chatRoom, widget.currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            friend?.profileImage == null
                ? CircleAvatar(child: Text(name?[0].toUpperCase() ?? ""))
                : CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(friend?.profileImage ?? ""),
                  ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$name",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${friend?.role}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: const [Icon(Icons.more_vert_outlined)],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return const Center(child: Text("No messages yet."));
              }

              return ListView.builder(
                controller: _scrollController, // Step 2
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isCurrentUser =
                      message.sender.id == widget.currentUserId;

                  // Check if we need a date divider
                  bool showDateDivider = false;
                  if (index == 0 ||
                      !isSameDay(chatController.messages[index - 1].createdAt,
                          message.createdAt)) {
                    showDateDivider = true;
                  }

                  return Column(
                    children: [
                      if (showDateDivider)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            children: [
                              const Expanded(child: CustomDivider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8),
                                child: Text(
                                  _formatDate(message.createdAt),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Expanded(child: CustomDivider()),
                            ],
                          ),
                        ),
                      ListTile(
                        title: Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? AppColor.primaryColor
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              message.content,
                              style: TextStyle(
                                  color: isCurrentUser
                                      ? AppColor.white
                                      : AppColor.black),
                            ),
                          ),
                        ),
                        subtitle: Text(
                          DateFormat("h:mm a").format(message.createdAt),
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                          textAlign:
                              isCurrentUser ? TextAlign.right : TextAlign.left,
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          // CircleAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: editingController,
              maxLines: 5,
              minLines: 1,
              style: AppTextStyle.body(fontWeight: FontWeight.normal, size: 12),
              decoration: InputDecoration(
                hintText: 'Write message',
                hintStyle:
                    AppTextStyle.body(size: 12, fontWeight: FontWeight.normal),
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
                chatController.sendMessage(
                  widget.chatRoom.id,
                  widget.currentUserId,
                  editingController.text,
                );
                editingController.clear();
              }
            },
            child: const Icon(IconsaxPlusBold.send_2),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays < 7 && date.weekday <= now.weekday) {
      // Same week, show the day (Monday, Tuesday, etc.)
      return DateFormat.EEEE().format(date); // Full day name
    } else if (difference.inDays < 14) {
      // Last week, show day, short day name, and month
      return DateFormat("EEE, MMM d").format(date); // Example: Mon, Oct 16
    } else {
      // Older, show full date with year if different
      final yearFormat = now.year == date.year ? "MMM d" : "MMM d, yyyy";
      return DateFormat(yearFormat).format(date);
    }
  }
}
