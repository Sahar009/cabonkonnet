import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/notification_model.dart';

class NotificationRepository {
  final Databases _database = AppwriteConfig().databases;
  final String _databaseId = AppwriteConfig.databaseId;
  final String _collectionId = AppwriteConfig.notificationCollectionId;

  // Fetch Notifications for a specific user
  Future<List<NotificationModel>> fetchNotifications(String receiverId) async {
    try {
      final result = await _database.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal('receiverId', receiverId),
        ],
      );

      return result.documents
          .map((doc) => NotificationModel.fromMap(doc.data))
          .toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  // Create a new notification
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await _database.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: 'unique()', // Automatically generate an ID
        data: notification.toMap(),
      );
    } catch (e) {
      print("Error creating notification: $e");
    }
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _database.updateDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: notificationId,
        data: {'isRead': true},
      );
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _database.deleteDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: notificationId,
      );
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  // // Real-time Notifications Stream
  // Stream<List<NotificationModel>> notificationsStream(String receiverId) {
  //   return _database.subscribe(
  //     [
  //       'databases.$_databaseId.collections.$_collectionId.documents',
  //     ],
  //   ).map((event) {
  //     final notifications = event.payload;
  //     return notifications
  //         .where((doc) => doc['receiverId'] == receiverId)
  //         .map<NotificationModel>((doc) => NotificationModel.fromJson(doc))
  //         .toList();
  //   });
  // }
}
