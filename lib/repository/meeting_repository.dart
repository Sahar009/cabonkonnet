import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/meeting_model.dart';

class MeetingRepository {
  final Databases databases;

  MeetingRepository({required this.databases});

  // Create a new Meeting
  Future<(bool isSuccess, String? message)> createMeeting(
      MeetingModel meeting) async {
    try {
      var cred = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meeting.id,
        data: meeting.toMap(),
      );

      return (true, cred.$id); // Return success and document ID
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error creating meeting');
      return (
        false,
        e.message ?? 'Unknown error occurred'
      ); // Improved error handling
    }
  }

  // Retrieve a Meeting by ID
  Future<(bool isSuccess, MeetingModel? meeting, String? message)> getMeeting(
      String meetingId) async {
    try {
      final Document document = await databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meetingId,
      );
      return (true, MeetingModel.fromMap(document.data), null);
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error fetching meeting');
      return (false, null, e.message ?? 'Unknown error occurred');
    }
  }

  // Update a Meeting
  Future<bool> updateMeeting(MeetingModel meeting) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meeting.id,
        data: meeting.toMap(),
      );
      return true;
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error updating meeting');
      return false;
    }
  }

  // Delete a Meeting
  Future<bool> deleteMeeting(String meetingId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meetingId,
      );
      return true;
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error deleting meeting');
      return false;
    }
  }

  // Fetch all Meetings
  Future<(bool isSuccess, List<MeetingModel>? meetings, String? message)>
      getAllMeetings() async {
    try {
      final documents = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
      );

      List<MeetingModel> meetingList = documents.documents
          .map((doc) => MeetingModel.fromMap(doc.data))
          .toList();

      return (true, meetingList, null);
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error fetching all meetings');
      return (false, null, e.message ?? 'Unknown error occurred');
    }
  }

  // Cancel a Meeting by Investor
  Future<bool> cancelMeetingByInvestor(
      String meetingId, String cancelReason) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meetingId,
        data: {
          'status': 'cancelled',
          'investorCancelReason': cancelReason,
        },
      );
      return true;
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error cancelling meeting');
      return false;
    }
  }

  // Reject a Meeting by Founder
  Future<bool> rejectMeetingByFounder(
      String meetingId, String rejectReason) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meetingId,
        data: {
          'status': 'rejected',
          'founderRejectReason': rejectReason,
        },
      );
      return true;
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error rejecting meeting');
      return false;
    }
  }

  // Accept a Meeting by Founder
  Future<bool> acceptMeetingByFounder(String meetingId) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meetingId,
        data: {'status': 'scheduled', "isScheduled": true},
      );
      return true;
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error accepting meeting');
      return false;
    }
  }

  // Accept a Meeting by Founder
  Future<bool> acceptMeetingByInvestor(String meetingId) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meetingId,
        data: {'status': 'scheduled', "isScheduled": true},
      );
      return true;
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error accepting meeting');
      return false;
    }
  }

  // Reschedule a Meeting by Founder
  Future<bool> rescheduleMeetingByFounder(
      String meetingId, DateTime date) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.meetingCollectionId,
        documentId: meetingId,
        data: {
          'status': 'rescheduled',
          'scheduledAt': date.toIso8601String(),
        },
      );
      return true;
    } on AppwriteException catch (e) {
      log(e.message ?? 'Error rescheduling meeting');
      return false;
    }
  }
}
