import 'dart:developer';

import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/models/notification_model.dart';
import 'package:cabonconnet/repository/notification_repository.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationRepository notificationRepository =
      NotificationRepository();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Fetch notifications for a specific user
  Future<void> fetchNotifications() async {
    String? userId = await AppLocalStorage.getCurrentUserId();
    log(userId.toString());
    isLoading.value = true;
    try {
      final fetchedNotifications =
          await notificationRepository.fetchNotifications(userId ?? "");
      notifications.assignAll(fetchedNotifications);
    } catch (e) {
      log("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Create a new notification
  Future<void> createNotification(NotificationModel notification) async {
    try {
      await notificationRepository.createNotification(notification);
      notifications.add(notification); // Optimistically update UI
    } catch (e) {
      log("Error creating notification: $e");
    }
  }

  Future<void> markAllNotificationAsRead() async {
    try {
      for (var notfication in notifications) {
        if (notfication.isRead) {
          continue;
        } else {
          await notificationRepository.markAsRead(notfication.id);

          final index =
              notifications.indexWhere((notif) => notif.id == notfication.id);
          if (index != -1) {
            notifications[index] = notifications[index].copyWith(isRead: true);
          }
        }
      }
    } catch (e) {
      log("Error marking notification as read: $e");
    }
  }

  // // Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await notificationRepository.markAsRead(notificationId);
      final index =
          notifications.indexWhere((notif) => notif.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
      }
    } catch (e) {
      log("Error marking notification as read: $e");
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await notificationRepository.deleteNotification(notificationId);
      notifications.removeWhere((notif) => notif.id == notificationId);
    } catch (e) {
      log("Error deleting notification: $e");
    }
  }

  // // Listen to real-time notifications
  // void listenToNotifications(String receiverId) {
  //   notificationRepository
  //       .notificationsStream(receiverId)
  //       .listen((realtimeNotifications) {
  //     notifications.assignAll(realtimeNotifications);
  //   });
  // }
}
