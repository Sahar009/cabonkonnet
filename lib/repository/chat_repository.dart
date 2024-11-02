import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/chat_rooms.dart';
import 'package:cabonconnet/models/message.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final Databases databases;

  ChatRepository({required this.databases});

  Future<ChatRoom?> getExistingChatRoom(String userId1, String userId2) async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.chatRoomCollectionId,
        queries: [
          Query.equal('type', 'direct'),
          Query.equal('users', [userId1, userId2]),
        ],
      );
      var d = response.documents.map((e) => e.data).toList();
      log(d.toString());
      if (response.documents.isNotEmpty) {
        return ChatRoom.fromDocument(response.documents.first);
      }
      return null;
    } catch (e) {
      log("Error in getExistingChatRoom: $e");
      return null;
    }
  }

  Future<ChatRoom> initiateChat(String userId1, String userId2) async {
    try {
      ChatRoom? existingChatRoom = await getExistingChatRoom(userId1, userId2);

      if (existingChatRoom != null) {
        return existingChatRoom;
      }

      final newChatRoomDoc = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.chatRoomCollectionId,
        documentId: 'unique()',
        data: {
          'type': 'direct',
          'participants': [userId1, userId2],
          'users': [userId1, userId2],
          'name': 'Private Chat',
        },
      );

      return ChatRoom.fromDocument(newChatRoomDoc);
    } catch (e) {
      log("Error in initiateChat: $e");
      rethrow;
    }
  }

  Future<List<ChatRoom>> fetchChatRoomsForUser(String userId) async {
    try {
      log(userId);
      final response = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.chatRoomCollectionId,
        queries: [
          Query.contains('users', userId),
          Query.isNotNull('lastMessageId'),
        ],
      );

      var d = response.documents.map((e) => e.data).toList();
      log("The list Of Rooms " + d.toString());

      return response.documents
          .map((doc) => ChatRoom.fromDocument(doc))
          .toList();
    } catch (e) {
      log('Error fetching chat rooms: $e');
      return [];
    }
  }

  Future<List<Message>> fetchUnreadMessages(String chatRoomId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollectionId,
        queries: [
          Query.equal('chatRoomId', chatRoomId),
          Query.equal('status', 'sent'),
        ],
      );

      return response.documents
          .map((doc) => Message.fromDocument(doc))
          .toList();
    } catch (e) {
      log("Error in fetchUnreadMessages: $e");
      return [];
    }
  }

  Future<void> sendMessage(
      String chatRoomId, String senderId, String content) async {
    try {
      String isd = const Uuid().v4();
      await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollectionId,
        documentId: isd,
        data: {
          'chatRoomId': chatRoomId,
          'sender': senderId,
          'content': content.trim(),
          'status': 'sent',
        },
      );
      databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.chatRoomCollectionId,
          documentId: chatRoomId,
          data: {"lastMessage": isd, "lastMessageId": isd});
    } catch (e) {
      log("Error in sendMessage: $e");
    }
  }

  Future<List<Message>> fetchMessages(String chatRoomId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.messagesCollectionId,
        queries: [
          Query.equal('chatRoomId', chatRoomId),
          Query.orderAsc('\$createdAt'), // Orders messages by creation time
        ],
      );

      return response.documents
          .map((doc) => Message.fromDocument(doc))
          .toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }
}
