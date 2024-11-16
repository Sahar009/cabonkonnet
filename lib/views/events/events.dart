import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/controllers/event_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/costom_dialog.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
// ignore: unused_import
import 'package:cabonconnet/views/events/create_event.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 45),
          Row(
            children: [
              const Image(
                image: AssetImage(AppImages.homelogo),
                height: 50,
              ),
              const SizedBox(width: 5),
              Text('Events',
                  style:
                      AppTextStyle.body(size: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          const CustomDivider(),
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
              50.toWidthWhiteSpacing(),
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
          const CustomDivider(),
          //const CustomDivider(),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          CustomDialog.event(context: context);
        },
        child: SvgPicture.asset(AppImages.createEvent),
      ),
    );
  }
}
