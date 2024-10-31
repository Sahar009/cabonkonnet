import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/events/live_event.dart';
import 'package:cabonconnet/views/widget/event_widget.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Image(image: AssetImage(AppImages.homelogo)),
                  SizedBox(width: 5),
                  Text('Events',
                      style: AppTextStyle.body(
                          size: 22, fontWeight: FontWeight.w500)),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LiveEvent()));
                },
                child: Row(
                  children: [
                    Image(image: AssetImage(AppImages.mic)),
                    SizedBox(width: 8),
                    Text('Live',
                        style: AppTextStyle.body(fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    'Events happening now',
                    style: AppTextStyle.body(
                        size: 11, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(height: 20),
              EventsWidget(
                  heading: 'Innovations in Solar Energy Storage',
                  subtitle:
                      'Exploring advancements in battery technoliges and storage solution',
                  imagePath: AppImages.smallpicture2,
                  hostName: 'Terry Silver'),
              SizedBox(height: 15),
              EventsWidget(
                  heading: 'Innovations in Solar Energy Storage',
                  subtitle:
                      'Exploring advancements in battery technoliges and storage solution',
                  imagePath: AppImages.smallpicture2,
                  hostName: 'Terry Silver'),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('Upcoming Events',
                    style: AppTextStyle.body(
                        size: 22, fontWeight: FontWeight.w500)),
              ),
              SizedBox(height: 15),
              EventsWidget(
                  isUpcoming: true,
                  heading: 'Offshore Wind Power Development',
                  subtitle:
                      'A deep dive into the latest projects and technologies in offshore wind energy, focusing on environmental impact',
                  imagePath: AppImages.smallpicture2,
                  hostName: 'Terry Silver'),
              SizedBox(height: 15),
              EventsWidget(
                  isUpcoming: true,
                  heading: 'Green Hydrogen as a Clean Energy Carrier',
                  subtitle:
                      'Discussing the role of green hydrogen in decarbonizing heavy industries and transportation',
                  imagePath: AppImages.smallpicture2,
                  hostName: 'Terry Silver'),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
