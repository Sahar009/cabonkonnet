import 'package:cabonconnet/models/chat_rooms.dart';
import 'package:flutter/material.dart';

class ForumChat extends StatelessWidget {
  final List<ChatRoom> chatRooms;

  const ForumChat({Key? key, required this.chatRooms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupChats = chatRooms.where((room) => room.type == 'group').toList();
    if (groupChats.isEmpty) {
      return const Center(
        child: Text(
          "There are no Forum chats",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: groupChats.length,
      itemBuilder: (context, index) {
        final chatRoom = groupChats[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(chatRoom.name[0].toUpperCase()),
          ),
          title: Text(chatRoom.name),
          subtitle: Text(chatRoom.lastMessage?.content ?? 'No messages yet'),
          onTap: () {
            // Navigate to group chat details or perform another action
          },
        );
      },
    );
  }
}
