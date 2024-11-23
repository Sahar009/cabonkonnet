// import 'package:flutter/material.dart';

// class InvestmentCalendar extends StatefulWidget {
//   @override
//   _InvestmentCalendarState createState() => _InvestmentCalendarState();
// }

// class _InvestmentCalendarState extends State<InvestmentCalendar> {
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 30);
//   bool isAmSelected = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Investment'),
//         leading: BackButton(),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'You have an invitation for a meeting with an investor. Pick a time and date suitable for you.',
//               style: AppTextStyle.soraBody(size: 16, color: Colors.black87),
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Choose a date',
//               style: TextStyle(size: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             // Calendar
//             CalendarDatePicker(
//               // initialCalendarMode: ,
//               initialDate: _selectedDate,
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2100),
//               onDateChanged: (date) {
//                 setState(() {
//                   _selectedDate = date;
//                 });
//               },
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Choose a time',
//               style: TextStyle(size: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 // Time Input
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () async {
//                       TimeOfDay? pickedTime = await showTimePicker(
//                         context: context,
//                         initialTime: _selectedTime,
//                       );
//                       if (pickedTime != null) {
//                         setState(() {
//                           _selectedTime = pickedTime;
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         _selectedTime.format(context),
//                         style: TextStyle(size: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 // AM / PM Selector
//                 ToggleButtons(
//                   isSelected: [isAmSelected, !isAmSelected],
//                   onPressed: (index) {
//                     setState(() {
//                       isAmSelected = index == 0;
//                     });
//                   },
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text('AM', style: TextStyle(size: 16)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text('PM', style: TextStyle(size: 16)),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(8),
//                   borderColor: Colors.grey,
//                   selectedBorderColor: AppColor.primaryColor,
//                   selectedColor: Colors.white,
//                   fillColor: AppColor.primaryColor,
//                 ),
//               ],
//             ),
//             Spacer(),
//             // Confirm Button
//             ElevatedButton(
//               onPressed: () {
//                 // Handle confirm logic
//                 print("Selected Date: $_selectedDate");
//                 print("Selected Time: ${_selectedTime.format(context)}");
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.primaryColor,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               child: Text(
//                 'Confirm',
//                 style: TextStyle(size: 16, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class InvestmentCalendar extends StatefulWidget {
//   @override
//   _InvestmentCalendarState createState() => _InvestmentCalendarState();
// }

// class _InvestmentCalendarState extends State<InvestmentCalendar> {
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 30);
//   bool isAmSelected = true;

//   // This will hold the dates that have reminders
//   Map<DateTime, List<String>> reminders = {};

//   // To store reminder text (simple list of reminders for now)
//   TextEditingController _reminderController = TextEditingController();

//   // To check if the date has a reminder
//   bool hasReminder(DateTime date) {
//     return reminders[date] != null && reminders[date]!.isNotEmpty;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Investment'),
//         leading: BackButton(),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'You have an invitation for a meeting with an investor. Pick a time and date suitable for you.',
//               style: TextStyle(size: 16, color: Colors.black87),
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Choose a date',
//               style: TextStyle(size: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),

//             // Custom header for the calendar
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_left),
//                   onPressed: () {
//                     setState(() {
//                       _selectedDate =
//                           DateTime(_selectedDate.year, _selectedDate.month - 1);
//                     });
//                   },
//                 ),
//                 Text(
//                   '${_selectedDate.month.toString()} - ${_selectedDate.year.toString()}',
//                   style: TextStyle(size: 18, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.arrow_right),
//                   onPressed: () {
//                     setState(() {
//                       _selectedDate =
//                           DateTime(_selectedDate.year, _selectedDate.month + 1);
//                     });
//                   },
//                 ),
//               ],
//             ),

//             // Calendar
//             CalendarDatePicker(
//               initialDate: _selectedDate,
//               firstDate: DateTime(2000),
//               lastDate: DateTime(2100),
//               onDateChanged: (date) {
//                 setState(() {
//                   _selectedDate = date;
//                 });
//               },
//               selectableDayPredicate: (day) => true,
//             ),
//             SizedBox(height: 24),
//             Text(
//               'Choose a time',
//               style: TextStyle(size: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 // Time Input
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () async {
//                       TimeOfDay? pickedTime = await showTimePicker(
//                         context: context,
//                         initialTime: _selectedTime,
//                       );
//                       if (pickedTime != null) {
//                         setState(() {
//                           _selectedTime = pickedTime;
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         _selectedTime.format(context),
//                         style: TextStyle(size: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 // AM / PM Selector
//                 ToggleButtons(
//                   isSelected: [isAmSelected, !isAmSelected],
//                   onPressed: (index) {
//                     setState(() {
//                       isAmSelected = index == 0;
//                     });
//                   },
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text('AM', style: TextStyle(size: 16)),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Text('PM', style: TextStyle(size: 16)),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(8),
//                   borderColor: Colors.grey,
//                   selectedBorderColor: AppColor.primaryColor,
//                   selectedColor: Colors.white,
//                   fillColor: AppColor.primaryColor,
//                 ),
//               ],
//             ),
//             Spacer(),
//             // Add Reminder Button
//             ElevatedButton(
//               onPressed: () {
//                 _showAddReminderDialog();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColor.primaryColor,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               child: Text(
//                 'Add Reminder',
//                 style: TextStyle(size: 16, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Show a dialog to add reminder
//   _showAddReminderDialog() async {
//     String? reminderText;
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Reminder'),
//           content: TextField(
//             controller: _reminderController,
//             decoration: InputDecoration(hintText: "Enter reminder text"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 reminderText = _reminderController.text;
//                 _reminderController.clear();
//                 Navigator.of(context).pop();
//                 if (reminderText != null && reminderText!.isNotEmpty) {
//                   setState(() {
//                     if (reminders[_selectedDate] == null) {
//                       reminders[_selectedDate] = [];
//                     }
//                     reminders[_selectedDate]!.add(reminderText!);
//                   });
//                 }
//               },
//               child: Text('Save'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widget/widget.dart';

class InvestmentCalendar extends StatefulWidget {
  const InvestmentCalendar({super.key});

  @override
  InvestmentCalendarState createState() => InvestmentCalendarState();
}

class InvestmentCalendarState extends State<InvestmentCalendar> {
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

                  Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration:
                          const BoxDecoration(color: AppColor.filledColor),
                      child: Text(_selectedTime.format(context)),
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
                  _showAddtionalPromtDialog();
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
  _showAddtionalPromtDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const InvestPromt();
      },
    );
  }
}


class InvestPromt extends StatefulWidget {
  const InvestPromt({
    super.key,
  });

  @override
  State<InvestPromt> createState() => _InvestPromtState();
}

class _InvestPromtState extends State<InvestPromt> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Container(
      height: 320,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
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
                //  authController.logoutUser();
                //Get.to(() => const CreateEvent());
              },
              title: "Confirm",
            ),
          ),
          40.toHeightWhiteSpacing(),
        ],
      ),
    ));
  }
}
