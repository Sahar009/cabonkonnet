import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/controllers/event_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/events/create_event.dart';
import 'package:cabonconnet/views/events/live_event.dart';
import 'package:cabonconnet/views/widget/event_widget.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final PageController pageController = PageController();
  final EventController eventController = Get.put(EventController());
  bool isLive = true;

  // Define the refresh function
  Future<void> _refreshEvents() async {
    await eventController.fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                const Image(image: AssetImage(AppImages.homelogo)),
                const SizedBox(width: 5),
                Text('Events',
                    style: AppTextStyle.body(
                        size: 22, fontWeight: FontWeight.w500)),
              ],
            ),
            const Divider(),
            20.toHeightWhiteSpacing(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabButton(
                  isActive: isLive,
                  onTap: () {
                    setState(() {
                      isLive = true;
                    });
                    pageController.jumpToPage(0);
                  },
                  title: "Live",
                ),
                30.toWidthWhiteSpacing(),
                TabButton(
                  isActive: !isLive,
                  onTap: () {
                    setState(() {
                      isLive = false;
                    });
                    pageController.jumpToPage(1);
                  },
                  title: "Upcoming",
                )
              ],
            ),
            const Divider(),
            // Use ListView to wrap PageView within RefreshIndicator
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshEvents,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                child: ListView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Allow pull-to-refresh
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height -
                          200, // Set an appropriate height
                      child: PageView(
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            isLive = index == 0;
                          });
                        },
                        children: const [
                          AllLiveEvent(),
                          AllUpcomingEvent()
                          // Add other tabs here, like AllUpcomingEvents for Upcoming
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Get.to(() => const CreateEvent());
        },
        child: SvgPicture.asset(AppImages.createEvent),
      ),
    );
  }
}
