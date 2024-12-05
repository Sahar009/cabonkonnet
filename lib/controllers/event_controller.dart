import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/models/event_model.dart';
import 'package:cabonconnet/repository/event_repository.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/views/home/home.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EventController extends GetxController {
  var isBusy = false.obs;
  final EventRepository eventRepository =
      EventRepository(databases: Databases(AppwriteConfig().client));
  final FileUploadRepository fileRepository = FileUploadRepository(
      bucketId: AppwriteConfig.eventBucketId,
      storage: Storage(AppwriteConfig().client));
  final RxList<EventModel> events = <EventModel>[].obs;

  // Realtime instance
  late Realtime realtime;

  @override
  void onInit() {
    super.onInit();
    fetchAllEvents();
    setupRealtimeEvents();
  }

  // Fetch all events
  Future<void> fetchAllEvents() async {
    final (isSuccess, fetchedEvents, message) =
        await eventRepository.getAllEvents();
    if (isSuccess) {
      if (fetchedEvents != null) {
        fetchedEvents.sort((a, b) => b.date.compareTo(a.date)); // Sort by date
        events.assignAll(fetchedEvents);
      }
    } else {
      CustomSnackbar.success(
          title: 'Error', message: message ?? 'An unknown error occurred');
    }
  }

  // Create a new event
  Future<void> createEvent({
    required String title,
    required String description,
    required String accessType,
    required String location,
    String? address,
    double? ticketPrice,
    required DateTime date,
    required File file,
 
  }) async {
    isBusy.value = true;
    String? imageUrl = await fileRepository.uploadFile(file, "EventImages");
    String? userId = await AppLocalStorage.getCurrentUserId();
    EventModel event = EventModel(
        id: ID.unique(),
        title: title,
        description: description,
        ticketPrice: ticketPrice,
        date: date,
        imageUrl: "$imageUrl",
        accessType: accessType,
        organizerId: userId!,
        location: location,
        address: address);

    final (isSuccess, message) = await eventRepository.createEvent(event);
    isBusy.value = false;

    if (isSuccess) {
      events.add(event);
      CustomSnackbar.success(
          title: 'Success',
          message: 'Event created successfully, please wait for approval');
      Get.offAll(() => Home());
    } else {
      CustomSnackbar.success(
          title: 'Error', message: message ?? 'Failed to create event');
    }
  }

  // Update an existing event
  Future<void> updateEvent(EventModel event) async {
    final isSuccess = await eventRepository.updateEvent(event);
    if (isSuccess) {
      final index = events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        events[index] = event; // Update the existing event in the list
        CustomSnackbar.success(
            title: 'Success', message: 'Event updated successfully');
        Get.back();
      }
    } else {
      CustomSnackbar.success(title: 'Error', message: 'Failed to update event');
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    final isSuccess = await eventRepository.deleteEvent(eventId);
    if (isSuccess) {
      events.removeWhere((event) => event.id == eventId);
      CustomSnackbar.success(
          title: 'Success', message: 'Event deleted successfully');
    } else {
      CustomSnackbar.success(title: 'Error', message: 'Failed to delete event');
    }
  }

// Delete an event
  Future<void> addParticipants(
      String userId, String eventId, EventModel eventModel) async {
    List participants = eventModel.participants ?? [];
    participants.add(userId);
    EventModel event = eventModel.copyWith(participants: participants);
    final isSuccess =
        await eventRepository.addParticipants(userId, eventId, event);
    if (isSuccess) {
      events.removeWhere((event) => event.id == eventId);
      CustomSnackbar.success(
          title: 'Success', message: 'Event deleted successfully');
    } else {
      CustomSnackbar.success(title: 'Error', message: 'Failed to delete event');
    }
  }

  // Real-time setup
  void setupRealtimeEvents() {
    realtime = Realtime(AppwriteConfig().client);

    realtime
        .subscribe([
          'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.eventCollectionId}.documents'
        ])
        .stream
        .listen((RealtimeMessage event) {
          log(event.events.toString());
          if (event.events
              .contains('databases.*.collections.*.documents.*.create')) {
            fetchAllEvents();
          } else if (event.events
              .contains('databases.*.collections.*.documents.*.update')) {
            final updatedEventData = event.payload;
            final eventId = updatedEventData['\$id'];
            final index = events.indexWhere((e) => e.id == eventId);
            if (index != -1) {
              events[index] = events[index].copyWith(
                title: updatedEventData["title"],
                description: updatedEventData["description"],
                // Include other fields as necessary
              );
            }
          } else if (event.events
              .contains('databases.*.collections.*.documents.*.delete')) {
            final eventId = event.payload['\$id'];
            events.removeWhere((event) => event.id == eventId);
          }
        });
  }

  // Upload files helper
  Future<List<String>> uploadFiles(List<XFile> files, String folderName) async {
    List<String> imageUrls = [];
    for (var file in files) {
      try {
        var fileUrl =
            await fileRepository.uploadFile(File(file.path), folderName);
        if (fileUrl != null) {
          imageUrls.add(fileUrl);
        }
      } catch (e) {
        CustomSnackbar.success(
            title: 'Upload  Error',
            message: 'Failed to upload image: ${file.name}');
      }
    }
    return imageUrls;
  }

  @override
  void onClose() {
    // realtime.unsubscribe();s
    super.onClose();
  }
}
