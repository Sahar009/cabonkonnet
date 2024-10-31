import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';

class ChatRepository {
  final Databases databases;

  ChatRepository({required this.databases});

  Future<Document?> getExistingChatRoom(String userId1, String userId2) async {
    final response = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.chatRoomCollectionId,
      queries: [
        Query.equal('type', 'direct'),
        Query.equal('participants', [userId1, userId2]),
      ],
    );
    if (response.documents.isNotEmpty) {
      return response.documents.first;
    }
    return null;
  }

  Future<Document> initiateChat(String userId1, String userId2) async {
    Document? existingChatRoom = await getExistingChatRoom(userId1, userId2);

    if (existingChatRoom != null) {
      return existingChatRoom; // Return existing chat room if found
    }

    final newChatRoom = await databases.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.chatRoomCollectionId,
      documentId: 'unique()',
      data: {
        'type': 'direct',
        'participants': [userId1, userId2],
        'name': 'Private Chat',
        'createdAt': DateTime.now().toIso8601String(),
      },
    );

    return newChatRoom;
  }

  Future<List<Document>> fetchUserChatRooms(String userId) async {
    final response = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: 'ChatRooms',
      queries: [
        Query.search('participants', userId), // Uses relational querying
      ],
    );
    return response.documents;
  }

  Future<List<Document>> fetchChatRoomsForUser(String userId) async {
    final response = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: 'ChatRooms',
      queries: [
        Query.search('participants',
            userId), // Find chat rooms with this user as a participant
      ],
    );
    return response.documents;
  }

  Future<List<Document>> fetchUnreadMessages(String chatRoomId) async {
    final response = await databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.messagesCollectionId,
      queries: [
        Query.equal('chatRoomId', chatRoomId),
        Query.equal(
            'status', 'sent'), // Filter by status to find unread messages
      ],
    );
    return response.documents;
  }
Future<void> sendMessage(String chatRoomId, String senderId, String content) async {
  await databases.createDocument(
    databaseId: AppwriteConfig.databaseId,
    collectionId: AppwriteConfig.messagesCollectionId,
    documentId: 'unique()',
    data: {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'sent',
    },
  );
}
  
}
