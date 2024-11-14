import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/event_model.dart';
import 'package:cabonconnet/views/events/live_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCardWidget extends StatelessWidget {
  final EventModel event;

  EventCardWidget({required this.event});

  @override
  Widget build(BuildContext context) {
    // Check if the event date is today and whether the event time has started
    DateTime now = DateTime.now();
    bool isToday = isSameDay(event.date, now);
    bool isEventUpcoming = event.date.isAfter(now);

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
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
                          builder: (context) => const LiveEvent()),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: AppTextStyle.soraBody(
                size: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: AppColor.textColor, size: 18),
                SizedBox(width: 4),
                Text(
                  event.location,
                  style: AppTextStyle.soraBody(size: 14)
                      .copyWith(letterSpacing: 2),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: event.accessType == "Free"
                        ? Colors.lightBlue
                        : Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.accessType,
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
                  Icon(Icons.calendar_today,
                      color: AppColor.textColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Today',
                    style: AppTextStyle.body(size: 14),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.access_time,
                      color: AppColor.primaryColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    DateFormat('hh:mm a').format(event.date) + ' WAT',
                    style: AppTextStyle.body(size: 14),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      color: AppColor.textColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    DateFormat('MMMM d, y').format(event.date),
                    style: AppTextStyle.body(size: 14),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.access_time,
                      color: AppColor.primaryColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    DateFormat('hh:mm a').format(event.date) + ' WAT',
                    style: AppTextStyle.body(size: 14),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  // Helper function to check if two dates are on the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
