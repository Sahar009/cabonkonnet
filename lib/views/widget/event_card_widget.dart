import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/event_model.dart';
import 'package:cabonconnet/views/events/live_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventCardWidget extends StatefulWidget {
  final EventModel event;

  const EventCardWidget({super.key, required this.event});

  @override
  State<EventCardWidget> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  void _showEventOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 40), // Reduced padding
        height: 180, // Adjust height if needed
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 16),
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset(AppImages.saveIcon),
              title: Text(
                "Set reminder",
                style:
                    AppTextStyle.body(size: 15, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
            ListTile(
              onTap: () async {},
              leading: Image.asset(AppImages.shareIcon),
              title: Text(
                "Share via",
                style:
                    AppTextStyle.body(size: 15, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset(AppImages.reportIcon),
              title: Text(
                "Report event",
                style:
                    AppTextStyle.body(size: 15, fontWeight: FontWeight.normal),
              ),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              contentPadding: const EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if the event date is today and whether the event time has started
    DateTime now = DateTime.now();
    bool isToday = isSameDay(widget.event.date, now);
    bool isEventUpcoming = widget.event.date.isAfter(now);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => LiveEvent(event: widget.event));
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black,
                    image: DecorationImage(
                      image: NetworkImage(widget.event.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),

              // Conditionally show the microphone icon
              if (isToday && !isEventUpcoming)
                Positioned(
                  bottom: 12,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LiveEvent(
                                  event: widget.event,
                                )),
                      );
                    },
                    child: Row(
                      children: [
                        const Image(image: AssetImage(AppImages.mic)),
                        const SizedBox(width: 8),
                        Text(
                          'Live',
                          style: AppTextStyle.body(
                              size: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          15.toHeightWhiteSpacing(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.event.title,
                      style: AppTextStyle.soraBody(
                        size: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () => _showEventOptions(context),
                      child: const Icon(Icons.more_vert))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      color: AppColor.textColor, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    widget.event.location,
                    style: AppTextStyle.soraBody(size: 14)
                        .copyWith(letterSpacing: 2),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.event.accessType == "Free"
                          ? Colors.lightBlue
                          : const Color(0xffFFA0E1).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.event.accessType,
                      style: AppTextStyle.body(size: 14),
                    ),
                  ),
                ],
              ),
              5.toHeightWhiteSpacing(),
              // Conditionally show date and time based on whether it's today
              if (isToday)
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColor.textColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Today',
                      style: AppTextStyle.body(size: 14),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time,
                        color: AppColor.primaryColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat('hh:mm a').format(widget.event.date)} WAT',
                      style: AppTextStyle.body(size: 14),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColor.textColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMMM d, y').format(widget.event.date),
                      style: AppTextStyle.body(size: 14),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time,
                        color: AppColor.primaryColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat('hh:mm a').format(widget.event.date)} WAT',
                      style: AppTextStyle.body(size: 14),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to check if two dates are on the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
