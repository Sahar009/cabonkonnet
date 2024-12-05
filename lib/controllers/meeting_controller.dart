import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/enum/notification_type_enum.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/models/meeting_model.dart';
import 'package:cabonconnet/models/notification_model.dart';
import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/repository/meeting_repository.dart';
import 'package:cabonconnet/repository/notification_repository.dart';
import 'package:cabonconnet/views/home/home.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class MeetingController extends GetxController {
  final MeetingRepository meetingRepository =
      MeetingRepository(databases: AppwriteConfig().databases);
  NotificationRepository notificationRepository = NotificationRepository();
  var isLoading = false.obs; // Loading state
  var errorMessage = ''.obs;
  // Observable variables
  var _meeting = Rxn<MeetingModel>();

  Rxn<MeetingModel> get meeting => _meeting; // Error messages

  Future<MeetingModel?> fetchMeeting(String meetingId) async {
    isLoading(true);
    try {
      final (isSuccess, result, message) =
          await meetingRepository.getMeeting(meetingId);
      if (isSuccess) {
        _meeting.value = result;
        return result;
      } else {
        errorMessage.value = message ?? 'Unknown error occurred';
      }
      return null;
    } finally {
      isLoading(false);
    }
  }

  // Create a meeting
  Future<bool> createMeeting({
    required DateTime date,
    required ProductModel productModel,
    required String? meetingNote,
  }) async {
    isLoading(true);
    try {
      String? userId = await AppLocalStorage.getCurrentUserId();
      String id = const Uuid().v4();
      MeetingModel meetingModel = MeetingModel(
        id: id,
        investorId: userId!,
        founderId: productModel.user!.id,
        productId: productModel.id,
        scheduledAt: date,
        meetingNote: meetingNote,
      );

      final (isSuccess, message) =
          await meetingRepository.createMeeting(meetingModel);

      if (isSuccess) {
        NotificationModel notificationModel = NotificationModel(
          id: "",
          title: "Meeting Created",
          message: "A new meeting has been scheduled.",
          type: NotificationType.meetingSubmission,
          senderId: userId,
          receiverId: productModel.user!.id,
          isRead: false,
          postId: id,
          createdAt: DateTime.now(),
        );
        notificationRepository.createNotification(notificationModel);

        CustomSnackbar.success(
            title: "Success", message: "Meeting created successfully.");

        Get.offAll(() => Home());
        return true;
      } else {
        errorMessage.value = message ?? 'Failed to create meeting';
        return false;
      }
    } finally {
      isLoading(false);
    }
  }

  // Accept a meeting
  Future<bool> acceptMeeting(
      String meetingId, MeetingModel meetingModel) async {
    isLoading(true);
    try {
      final result = await meetingRepository.acceptMeetingByFounder(meetingId);
      if (result) {
        NotificationModel notificationModel = NotificationModel(
          id: "",
          title: "Meeting Accepted",
          message: "The meeting request has been accepted.",
          type: NotificationType.meetingApproval,
          senderId: meetingModel.founderId,
          receiverId: meetingModel.investorId,
          isRead: false,
          postId: meetingId,
          createdAt: DateTime.now(),
        );
        notificationRepository.createNotification(notificationModel);
        CustomSnackbar.success(
            title: "Success",
            message: "The meeting request has been accepted.");
        Get.off(() => Home());

        return true;
      } else {
        errorMessage.value = 'Failed to accept meeting';
        return false;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> acceptMeetingByInvetor(
      String meetingId, MeetingModel meetingModel) async {
    isLoading(true);
    try {
      final result = await meetingRepository.acceptMeetingByInvestor(meetingId);
      if (result) {
        NotificationModel notificationModel = NotificationModel(
          id: "",
          title: "Meeting Accepted",
          message: "The meeting request has been accepted.",
          type: NotificationType.meetingApproval,
          senderId: meetingModel.investorId,
          receiverId: meetingModel.founderId,
          isRead: false,
          postId: meetingId,
          createdAt: DateTime.now(),
        );
        notificationRepository.createNotification(notificationModel);
        CustomSnackbar.success(
            title: "Success",
            message: "The meeting request has been accepted.");
        return true;
      } else {
        errorMessage.value = 'Failed to accept meeting';
        return false;
      }
    } finally {
      isLoading(false);
    }
  }

  // Reschedule a meeting
  Future<bool> rescheduleMeeting(
      String meetingId, DateTime date, MeetingModel meetingModel) async {
    isLoading(true);
    try {
      final result =
          await meetingRepository.rescheduleMeetingByFounder(meetingId, date);
      if (result) {
        NotificationModel notificationModel = NotificationModel(
          id: "",
          title: "Meeting Rescheduled",
          message: "The meeting has been rescheduled to ${date.toString()}",
          type: NotificationType.meetingReschedule,
          senderId: meetingModel
              .founderId, // Update with appropriate sender ID if available
          receiverId: meetingModel
              .investorId, // Update with appropriate receiver ID if available
          isRead: false,
          postId: meetingId,

          createdAt: DateTime.now(),
        );
        notificationRepository.createNotification(notificationModel);
        Get.to(() => Home());
        CustomSnackbar.success(
            title: "Success", message: "The meeting has been rescheduled");

        return true;
      } else {
        errorMessage.value = 'Failed to reschedule meeting';
        return false;
      }
    } finally {
      isLoading(false);
    }
  }

  // Cancel a meeting
  Future<bool> cancelMeeting(
      String meetingId, String cancelReason, MeetingModel meetingModel) async {
    isLoading(true);
    try {
      final result = await meetingRepository.cancelMeetingByInvestor(
          meetingId, cancelReason);
      if (result) {
        NotificationModel notificationModel = NotificationModel(
          id: "",
          title: "Meeting Cancelled",
          message: "The meeting has been cancelled. Reason: $cancelReason",
          type: NotificationType.meetingRejection,
          senderId: meetingModel
              .investorId, // Update with appropriate sender ID if available
          receiverId: meetingModel
              .founderId, // Update with appropriate receiver ID if available
          isRead: false,
          postId: meetingId,

          createdAt: DateTime.now(),
        );
        notificationRepository.createNotification(notificationModel);

        return true;
      } else {
        errorMessage.value = 'Failed to cancel meeting';
        return false;
      }
    } finally {
      isLoading(false);
    }
  }

  // Reject a meeting
  Future<bool> rejectMeeting(
      String meetingId, String rejectReason, MeetingModel meetingModel) async {
    isLoading(true);
    try {
      final result = await meetingRepository.rejectMeetingByFounder(
          meetingId, rejectReason);
      if (result) {
        NotificationModel notificationModel = NotificationModel(
          id: "",
          title: "Meeting Rejected",
          message:
              "The meeting request has been rejected. Reason: $rejectReason",
          type: NotificationType.meetingRejection,
          senderId: meetingModel
              .founderId, // Update with appropriate sender ID if available
          receiverId: meetingModel
              .investorId, // Update with appropriate receiver ID if available
          isRead: false,
          postId: meetingId,

          createdAt: DateTime.now(),
        );
        notificationRepository.createNotification(notificationModel);
        _meeting.value = null;
        Get.to(() => Home());
        return true;
      } else {
        errorMessage.value = 'Failed to reject meeting';
        return false;
      }
    } finally {
      isLoading(false);
    }
  }
}
