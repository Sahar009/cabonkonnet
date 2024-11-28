enum NotificationType {
  productSubmission,
  productApproval,
  productRejection,
  eventSubmission,
  eventApproval,
  eventRejection,
  meetingSubmission,
  meetingApproval,
  meetingRejection,
  meetingReschedule,
}

extension NotificationTypeExtension on NotificationType {
  // Map enum to human-readable string
  String get displayName {
    switch (this) {
      case NotificationType.productApproval:
        return "Product Approval ";

      case NotificationType.productSubmission:
        return "Product Submission ";
      case NotificationType.productRejection:
        return "Product Rejection";
      case NotificationType.eventSubmission:
        return "Event Submission";
      case NotificationType.eventApproval:
        return "Event Approval";
      case NotificationType.eventRejection:
        return "Event Rejection";
      case NotificationType.meetingSubmission:
        return "Meeting Submission";
      case NotificationType.meetingApproval:
        return "Meeting Approval";
      case NotificationType.meetingRejection:
        return "Meeting Rejection";
      case NotificationType.meetingReschedule:
        return "Meeting Reschedule";
    }
  }

  // Map enum to Appwrite string value
  String get appwriteValue {
    switch (this) {
      case NotificationType.productApproval:
        return "product_submission";
      case NotificationType.productSubmission:
        return "product_approval";
      case NotificationType.productRejection:
        return "product_rejection";
      case NotificationType.eventSubmission:
        return "event_submission";
      case NotificationType.eventApproval:
        return "event_approval";
      case NotificationType.eventRejection:
        return "event_rejection";
      case NotificationType.meetingSubmission:
        return "meeting_submission";
      case NotificationType.meetingApproval:
        return "meeting_approval";
      case NotificationType.meetingRejection:
        return "meeting_rejection";
      case NotificationType.meetingReschedule:
        return "meeting_reschedule";
    }
  }

  // Convert Appwrite string to enum
  static NotificationType? fromAppwriteValue(String value) {
    switch (value) {
      case "product_rejection":
        return NotificationType.productRejection;
      case "event_submission":
        return NotificationType.eventSubmission;
      case "event_approval":
        return NotificationType.eventApproval;
      case "event_rejection":
        return NotificationType.eventRejection;
      case "meeting_submission":
        return NotificationType.meetingSubmission;
      case "meeting_approval":
        return NotificationType.meetingApproval;
      case "meeting_rejection":
        return NotificationType.meetingRejection;
      case "meeting_reschedule":
        return NotificationType.meetingReschedule;
      default:
        return null; // or handle error
    }
  }
}
