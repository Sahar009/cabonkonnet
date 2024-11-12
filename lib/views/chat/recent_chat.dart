import 'package:cabonconnet/controllers/chat_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/models/chat_rooms.dart';
import 'package:cabonconnet/views/chat/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentChat extends StatefulWidget {
  final List<ChatRoom> chatRooms;
  final String currentUserId;
  const RecentChat(
      {super.key, required this.currentUserId, required this.chatRooms});

  @override
  State<RecentChat> createState() => _RecentChatState();
}

class _RecentChatState extends State<RecentChat> {
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    final directMessages =
        widget.chatRooms.where((room) => room.type == 'direct').toList();

    if (directMessages.isEmpty) {
      return const Center(
        child: Text(
          "There are no recent chats",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: directMessages.length,
      itemBuilder: (context, index) {
        final chatRoom = directMessages[index];
        final (friend, name) = chatController.getChatParticipantInfo(
            chatRoom, widget.currentUserId);
        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Text(name?[0].toUpperCase() ?? ""),
              ),
              title: Text(name ?? ''),
              subtitle:
                  Text(chatRoom.lastMessage?.content ?? 'No messages yet'),
              trailing: Text(
                chatRoom.lastMessage!.updatedAt.toCustomTimeAgo(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Get.to(() => MessagesScreen(
                    chatRoom: chatRoom, currentUserId: widget.currentUserId));
              },
            ),
            const Divider()
          ],
        );
      },
    );
  }
}
