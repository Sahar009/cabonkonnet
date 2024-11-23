import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/models/chat_rooms.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/chat_repository.dart';
import 'package:get/get.dart';
import '../models/message.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository =
      ChatRepository(databases: Databases(AppwriteConfig().client));
  RxList<ChatRoom> chatRooms = <ChatRoom>[].obs;
  RxList<Message> unreadMessages = <Message>[].obs;
  RxBool isLoading = false.obs;

  late Realtime realtime;
  @override
  void onInit() {
    super.onInit();
    loadUserChatRooms();
    setupRealtimeChatRooms();
  }

  RxList<Message> messages = <Message>[].obs;

  Future<void> loadMessages(String chatRoomId) async {
    messages.value = await chatRepository.fetchMessages(chatRoomId);
    update();
  }

  Future<void> loadUserChatRooms() async {
    String? userId = await AppLocalStorage.getCurrentUserId();
    isLoading.value = true;
    try {
      chatRooms.value = await chatRepository.fetchChatRoomsForUser(userId!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUnreadMessages(String chatRoomId) async {
    isLoading.value = true;
    try {
      unreadMessages.value =
          await chatRepository.fetchUnreadMessages(chatRoomId);
    } finally {
      isLoading.value = false;
    }
  }

  (UserModel?, String?) getChatParticipantInfo(
      ChatRoom chatRoom, String currentUserId) {
    if (chatRoom.type == "direct" && chatRoom.participants.length == 2) {
      // Retrieve the other participant as the friend in a direct chat
      final friend =
          chatRoom.participants.firstWhere((user) => user.id != currentUserId);
      return (friend, friend.fullName);
    } else if (chatRoom.type == "group") {
      // Return the group name if it's a group chat
      return (null, chatRoom.name);
    }
    return (null, ""); // Handle unexpected cases or errors
  }

  Future<void> sendMessage(
      String chatRoomId, String senderId, String content) async {
    await chatRepository.sendMessage(chatRoomId, senderId, content);
    await loadUnreadMessages(chatRoomId); // Refresh unread messages
  }

  Future<ChatRoom> initiateChat(String userId1, String userId2) async {
    return await chatRepository.initiateChat(userId1, userId2);
  }

  void setupRealtimeChatRooms() {
    realtime = Realtime(AppwriteConfig().client);

    realtime
        .subscribe([
          'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.chatRoomCollectionId}.documents'
        ])
        .stream
        .listen((RealtimeMessage event) {
          log(event.events.toString());
          if (event.events
              .contains('databases.*.collections.*.documents.*.create')) {
            // Handle new chat room creation if needed
            loadUserChatRooms(); // Load chat rooms again to include the new room
          } else if (event.events
              .contains('databases.*.collections.*.documents.*.update')) {
            final updatedRoomData = event.payload;
            final roomId = updatedRoomData['\$id'];

            // Find the existing chat room
            final index = chatRooms.indexWhere((room) => room.id == roomId);
            if (index != -1) {
              // Update only the last message or any specific fields
              chatRooms[index] = chatRooms[index].copyWith(
                lastMessage: updatedRoomData["lastMessage"],
                // Update other necessary fields if applicable
              );
            }
            loadUserChatRooms();
          } else if (event.events
              .contains('databases.*.collections.*.documents.*.delete')) {
            final roomId = event.payload['\$id'];
            chatRooms.removeWhere(
                (room) => room.id == roomId); // Remove deleted room
          }
        });
  }

  void setupRealtimeForChat(String chatRoomId) {
    realtime = Realtime(AppwriteConfig().client);

    realtime
        .subscribe([
          'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.messagesCollectionId}.documents'
        ])
        .stream
        .listen((RealtimeMessage event) {
          log(event.events.toString());
          if (event.events
              .contains('databases.*.collections.*.documents.*.create')) {
            // Handle new chat room creation if needed
            loadUserChatRooms(); // Load chat rooms again to include the new room
            loadMessages(chatRoomId);
          } else if (event.events
              .contains('databases.*.collections.*.documents.*.update')) {
            final updatedRoomData = event.payload;
            final roomId = updatedRoomData['\$id'];

            // Find the existing chat room
            final index = messages.indexWhere((room) => room.id == roomId);
            if (index != -1) {
              // Update only the last message or any specific fields
              messages[index] = messages[index].copyWith(
                content: updatedRoomData["content"],
                status: updatedRoomData["statu"],
                // Update other necessary fields if applicable
              );
            }
          } else if (event.events
              .contains('databases.*.collections.*.documents.*.delete')) {
            final roomId = event.payload['\$id'];
            messages.removeWhere(
                (room) => room.id == roomId); // Remove deleted room
          }
        });
  }
}
