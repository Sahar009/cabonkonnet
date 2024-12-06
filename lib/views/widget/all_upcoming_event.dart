import 'package:cabonconnet/controllers/event_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/event_model.dart';
import 'package:cabonconnet/views/events/live_event.dart';
import 'package:cabonconnet/views/widget/no_file.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUpcomingEvent extends StatefulWidget {
  const AllUpcomingEvent({super.key});

  @override
  State<AllUpcomingEvent> createState() => _AllUpcomingEventState();
}

class _AllUpcomingEventState extends State<AllUpcomingEvent> {
  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        child: Obx(() {
          if (eventController.events.isEmpty) {
            return const NoDocument(title: 'No events available');
          }

          // Filter and sort events that are scheduled for future dates
          List<EventModel> upcomingEvents = eventController.events
              .where((event) => event.date.isAfter(DateTime.now()))
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Upcoming Events',
                    style: AppTextStyle.body(
                      size: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              upcomingEvents.isEmpty
                  ? const NoDocument(title: 'No upcoming events.')
                  : Expanded(
                      child: ListView.builder(
                        itemCount: upcomingEvents.length,
                        itemBuilder: (context, index) {
                          EventModel eventModel = upcomingEvents[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LiveEvent(
                                          event: eventModel,
                                        )),
                              );
                            },
                            child: EventCardWidget(
                              event: eventModel,
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}
