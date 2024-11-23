import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/event_model.dart';

class EventRepository {
  final Databases databases;

  const EventRepository({required this.databases});

  // Create a new event
  Future<(bool isSuccess, String? message)> createEvent(
      EventModel event) async {
    try {
      final Document document = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventCollectionId,
        documentId: event.id, // Unique ID for the document
        data: event.toMap(),
      );
      return (true, document.$id); // Return true and the document ID
    } catch (e) {
      return (false, e.toString()); // Return false and the error message
    }
  }

  // Fetch all events
  Future<(bool isSuccess, List<EventModel>? events, String? message)>
      getAllEvents() async {
    try {
      final documents = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventCollectionId,
      );
      List<EventModel> events = documents.documents
          .map((doc) => EventModel.fromMap(doc.data))
          .toList();

      return (true, events, ""); // Return true and the list of events
    } catch (e) {
      return (false, null, e.toString()); // Return false and the error message
    }
  }

  // Update an existing event
  Future<bool> updateEvent(EventModel event) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventCollectionId,
        documentId: event.id,
        data: event.toMap(),
      );
      return true; // Return true if the update is successful
    } catch (e) {
      return false; // Return false if there's an error
    }
  }

  // Delete an event
  Future<bool> deleteEvent(String eventId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventCollectionId,
        documentId: eventId,
      );
      return true; // Return true if the deletion is successful
    } catch (e) {
      return false; // Return false if there's an error
    }
  }

  Future addParticipants(
      String userId, String eventId, EventModel event) async {
    try {
      await databases.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.eventParticipantId,
          documentId: ID.unique(),
          data: {"event": eventId, "participant": userId});

      await databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.eventCollectionId,
          documentId: eventId,
          data: {"participants": event.participants});
      return true; // Return true if the deletion is successful
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return false; // Return false if there's an error
    }
  }
}
