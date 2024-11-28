import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/meeting_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/meeting_model.dart';
import 'package:cabonconnet/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widget/widget.dart';

class RescheduleMeeting extends StatefulWidget {
  final MeetingModel meetingModel;
  const RescheduleMeeting({super.key, required this.meetingModel});

  @override
  RescheduleMeetingState createState() => RescheduleMeetingState();
}

class RescheduleMeetingState extends State<RescheduleMeeting> {
  // Track the selected date and time
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 30);
  bool isAmSelected = true;

  // To store events or reminders for specific dates
  Map<DateTime, List<String>> reminders = {
    DateTime(2024, 11, 21): ['Investor meeting at 10:30 AM', 'Follow-up email'],
    DateTime(2024, 11, 23): ['Prepare presentation for investor'],
    DateTime(2024, 11, 25): ['Call investor about new proposal'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackBotton(),
              Text(
                'Investment Calendar',
                style: AppTextStyle.soraBody(
                    fontWeight: FontWeight.normal, size: 18),
              ),
              15.toHeightWhiteSpacing(),
              Text(
                'You have an invitation for a meeting with an investor. Pick a time and date suitable for you.',
                style: AppTextStyle.soraBody(
                    size: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 24),
              Text(
                'Choose a date',
                style: AppTextStyle.soraBody(
                    size: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // TableCalendar for displaying the calendar
              Card(
                color: AppColor.white,
                elevation: 1,
                child: TableCalendar(
                  focusedDay: _selectedDate,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  selectedDayPredicate: (day) {
                    return isSameDay(day, _selectedDate);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  eventLoader: (day) {
                    // Normalize the time to 00:00:00 for comparison
                    return reminders.keys
                            .any((reminderDate) => isSameDay(reminderDate, day))
                        ? reminders[day] ?? []
                        : [];
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: const BoxDecoration(
                      color: AppColor.blackTextColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColor.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: AppTextStyle.soraBody(color: Colors.white),
                    markersMaxCount: 1, // Allow only 1 marker for each day
                    markerDecoration: const BoxDecoration(
                      color: Colors.red, // Set the color of the event dots
                      shape: BoxShape.circle,
                    ),
                  ),
                  // This hides the extra weeks and keeps the view focused on the current month
                  calendarFormat: CalendarFormat.month,
                  availableGestures:
                      AvailableGestures.none, // Disable swipe gestures
                  onHeaderTapped: (data) {
                    _showMonthYearPicker(context);
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false, // Hide the format button
                    leftChevronIcon: const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    titleCentered: true,
                    titleTextStyle: AppTextStyle.soraBody(
                      color: Colors.black,
                      size: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    // When tapped, show the Month/Year picker dialog
                  ),
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _selectedDate = focusedDay;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Choose a time',
                style: AppTextStyle.soraBody(
                    size: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Time Input
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Text(
                        "Time", //,
                        style: AppTextStyle.soraBody(size: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // AM / PM Selector

                  GestureDetector(
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration:
                            const BoxDecoration(color: AppColor.filledColor),
                        child: Text(_selectedTime.format(context)),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        color: AppColor.filledColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAmSelected = true;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color:
                                  isAmSelected ? AppColor.primaryColor : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('AM',
                                style: AppTextStyle.soraBody(
                                    size: 14,
                                    color: !isAmSelected
                                        ? AppColor.primaryColor
                                        : AppColor.white)),
                          ),
                        ),
                        10.toWidthWhiteSpacing(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAmSelected = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color:
                                  !isAmSelected ? AppColor.primaryColor : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('PM',
                                style: AppTextStyle.soraBody(
                                    size: 14,
                                    color: isAmSelected
                                        ? AppColor.primaryColor
                                        : AppColor.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              60.toHeightWhiteSpacing(),

              AppButton(
                onTab: () {
                  _showAddtionalPromtDialog(
                      DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          _selectedTime.hour,
                          _selectedTime.minute),
                      widget.meetingModel);
                },
                title: "Confirm",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show a dialog to select the Month and Year
  _showMonthYearPicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.primaryColor,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Show a dialog to add reminder
  _showAddtionalPromtDialog(DateTime date, MeetingModel meetingModel) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvestPromt(
          date: date,
          meetingModel: meetingModel,
        );
      },
    );
  }
}

class InvestPromt extends StatefulWidget {
  final DateTime date;
  final MeetingModel meetingModel;
  const InvestPromt({
    super.key,
    required this.date,
    required this.meetingModel,
  });

  @override
  State<InvestPromt> createState() => _InvestPromtState();
}

class _InvestPromtState extends State<InvestPromt> {
  MeetingController meetingController = Get.put(MeetingController());
  TextEditingController meetingNote = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(child: Obx(() {
      return Container(
        height: 320,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: meetingController.isLoading.value
            ? const Loading()
            : Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10.0, top: 20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                  10.toHeightWhiteSpacing(),
                  Text(
                    "Send an investment prompt",
                    style: AppTextStyle.soraBody(size: 18),
                  ),
                  15.toHeightWhiteSpacing(),

                  Expanded(
                    child: TextField(
                      controller: meetingNote,
                      decoration: const InputDecoration(
                        hintText: "Add message (optional)",
                        fillColor: AppColor.filledColor,
                        filled: true,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 6,
                      minLines: 6,
                      style: AppTextStyle.soraBody(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  10.toHeightWhiteSpacing(),

                  // const Spacer(),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    child: AppButton(
                      onTab: () {
                        meetingController.rescheduleMeeting(
                            widget.meetingModel.id,
                            widget.date,
                            widget.meetingModel);
                        //Get.to(() => const CreateEvent());
                      },
                      title: "Confirm",
                    ),
                  ),
                  40.toHeightWhiteSpacing(),
                ],
              ),
      );
    }));
  }
}
