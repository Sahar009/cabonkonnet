import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/controllers/event_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/event_model.dart';
import 'package:cabonconnet/views/events/live_event.dart';
import 'package:cabonconnet/views/widget/no_file.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllLiveEvent extends StatefulWidget {
  const AllLiveEvent({super.key});

  @override
  State<AllLiveEvent> createState() => _AllLiveEventState();
}

class _AllLiveEventState extends State<AllLiveEvent> {
  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        if (eventController.events.isEmpty) {
          return const NoDocument(title: 'No events available');
        }

        // Filter events happening today
        List<EventModel> liveEvents = eventController.events.where((event) {
          DateTime now = DateTime.now();
          return event.date.year == now.year &&
              event.date.month == now.month &&
              event.date.day == now.day;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LiveEvent()),
                );
              },
              child: Row(
                children: [
                  const Image(image: AssetImage(AppImages.mic)),
                  const SizedBox(width: 8),
                  Text(
                    'Live',
                    style: AppTextStyle.body(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  'Events happening today',
                  style: AppTextStyle.body(
                    size: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            liveEvents.isEmpty
                ? const NoDocument(title: 'No live events currently.')
                : SizedBox(
                    height: 400, // Set a specific height for the ListView
                    child: ListView.builder(
                      itemCount: liveEvents.length,
                      itemBuilder: (context, index) {
                        EventModel eventModel = liveEvents[index];
                        return EventCardWidget(
                          event: eventModel,
                        );
                      },
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
