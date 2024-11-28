import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/enum/notification_type_enum.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/notification_model.dart';
import 'package:cabonconnet/controllers/notification_controller.dart';
import 'package:cabonconnet/views/investment/meeting_invitation.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreens extends StatefulWidget {
  const NotificationScreens({super.key});

  @override
  State<NotificationScreens> createState() => _NotificationScreensState();
}

class _NotificationScreensState extends State<NotificationScreens> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    // Fetch notifications for a specific user
    notificationController
        .fetchNotifications(); // Replace with actual receiverId
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notificationController.markAllNotificationAsRead();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const AppBackBotton(
                pageTitle: "Notifications",
                vertical: true,
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (notificationController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (notificationController.notifications.isEmpty) {
                  return Center(
                    child: Text(
                      "No notifications available.",
                      style: AppTextStyle.body(
                        size: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: notificationController.notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final notification =
                          notificationController.notifications[index];
                      return NotificationItem(
                        notification: notification,
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable widget for displaying a single notification
class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(Icons.notifications, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${notification.title} ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppTextStyle.body(
                      size: 14,
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.bold,
                    ),
                  ),
                  Text(
                    notification.message,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: AppTextStyle.body(
                      size: 14,
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.bold,
                    ),
                  ),
                  10.toHeightWhiteSpacing(),
                  if (notification.title.contains("Meeting") ||
                      notification.type == NotificationType.eventSubmission)
                    SizedBox(
                      width: 150,
                      child: AppButton(
                        onTab: () {
                          Get.off(() => MeetingInvitation(
                                meetingId: notification.postId ?? "",
                              ));
                        },
                        color: AppColor.white,
                        textColor: AppColor.primaryColor,
                        title: "View details",
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const CustomDivider(),
      ],
    );
  }
}
