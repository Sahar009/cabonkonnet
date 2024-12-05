import 'dart:io';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/event_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final EventController eventController = EventController();
  String eventAccess = 'Free';
  String location = 'Online';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  /// Combined date and time picker
  Future<void> pickDateTime() async {
    // Step 1: Pick a date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Step 2: Pick a time after selecting the date
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
        });
      }
    }
  }

  /// Combine selected date and time into a DateTime object
  DateTime? get eventDateTime {
    if (selectedDate != null && selectedTime != null) {
      return DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }
    return null;
  }

  Future<void> _selectImages() async {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        imageFile = File(selectedImage.path);
      });
    }
  }

  void _createEvent() {
    if (selectedDate == null && imageFile == null) {
      CustomSnackbar.error(message: "Pick Your Date Or Your Cover Image");
      return;
    }
    if (_formKey.currentState!.validate()) {
      eventController.createEvent(
    
          title: titleController.text,
          description: descriptionController.text,
          accessType: eventAccess,
          date: selectedDate!,
          ticketPrice: double.tryParse(priceController.text),
          address: addressController.text,
          location: location,
          file: imageFile!);
    } else {
      Get.snackbar("Validation Error", "Please fill all required fields",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return eventController.isBusy.value
            ? const Loading()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      60.toHeightWhiteSpacing(),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child:
                                  const Icon(Icons.arrow_back_ios_new_rounded)),
                          10.toWidthWhiteSpacing(),
                          Text(
                            "Create Event",
                            style: AppTextStyle.body(),
                          )
                        ],
                      ),
                      const Divider(
                        color: AppColor.primaryColor,
                      ),
                      20.toHeightWhiteSpacing(),
                      SingleChildScrollView(
                        child: Form(
                          key: _formKey, // Assign the form key
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Your existing widgets here...
                              EventTextEditor(
                                label: "Event Title",
                                controller: titleController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Event Title is required";
                                  }
                                  return null;
                                },
                              ),
                              EventTextEditor(
                                label: "Event Description",
                                controller: descriptionController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Event Description is required";
                                  }
                                  return null;
                                },
                              ),
                              EventDropdown(
                                label: "Event Access",
                                value: eventAccess,
                                items: const ['Free', 'Paid'],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    eventAccess = newValue!;
                                  });
                                },
                              ),
                              if (eventAccess == 'Paid')
                                EventTextEditor(
                                  label: "Ticket Price",
                                  controller: priceController,
                                  validator: (value) {
                                    if (eventAccess == 'Paid' &&
                                        (value == null || value.isEmpty)) {
                                      return "Ticket Price is required for paid events";
                                    }
                                    if (value != null &&
                                        double.tryParse(value) == null) {
                                      return "Please enter a valid number";
                                    }
                                    return null;
                                  },
                                ),
                              EventDatePicker(
                                label: "Event Date",
                                selectedDateTime: eventDateTime,
                                onSelectDateTime: pickDateTime,
                              ),
                              EventDropdown(
                                label: "Location",
                                value: location,
                                items: const ['Online', 'Physical'],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    location = newValue!;
                                  });
                                },
                              ),
                              if (location == 'Physical')
                                EventTextEditor(
                                  label: "Event Address",
                                  controller: addressController,
                                  validator: (value) {
                                    if (location == 'Physical' &&
                                        (value == null || value.isEmpty)) {
                                      return "Event Address is required for paid events";
                                    }
                                    if (value != null &&
                                        double.tryParse(value) == null) {
                                      return "Please enter a valid number";
                                    }
                                    return null;
                                  },
                                ),
                              20.toHeightWhiteSpacing(),
                              Container(
                                alignment: Alignment.center,
                                height: 130,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppColor.filledColor,
                                  borderRadius: BorderRadius.circular(8),
                                  image: imageFile != null
                                      ? DecorationImage(
                                          image: FileImage(imageFile!))
                                      : null,
                                ),
                                child: GestureDetector(
                                  onTap: _selectImages,
                                  child: Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                      height: 33,
                                      child: Center(
                                        child: Text(
                                          "Add event cover image",
                                          style: AppTextStyle.body(size: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              40.toHeightWhiteSpacing(),
                              AppButton(
                                onTab:
                                    _createEvent, // Call the validation method
                                title: "Create event",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

class EventTextEditor extends StatelessWidget {
  const EventTextEditor({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator; // Added validator

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  AppTextStyle.soraBody(size: 15, fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          TextFormField(
            // Switched to TextFormField for validation
            controller: controller,
            validator: validator,
            maxLines: label.toLowerCase().contains("description") ? 5 : 1,
            decoration: InputDecoration(
              hintStyle: AppTextStyle.soraBody(
                  color: AppColor.textColor, fontWeight: FontWeight.w400),
              prefixText: label.toLowerCase().contains("price") ? "\$ " : null,
              hintText: label.toLowerCase().contains("price")
                  ? "e.g 30 "
                  : "Enter your $label",
              filled: label.toLowerCase().contains("description"),
              border: !label.toLowerCase().contains("description")
                  ? const UnderlineInputBorder()
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}

class EventDropdown extends StatelessWidget {
  const EventDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  AppTextStyle.soraBody(size: 15, fontWeight: FontWeight.w400)),
          const SizedBox(height: 3),
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: AppTextStyle.soraBody(
                      size: 15, fontWeight: FontWeight.w400),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              fillColor: AppColor.filledColor,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}

class EventDatePicker extends StatelessWidget {
  const EventDatePicker({
    super.key,
    required this.label,
    required this.selectedDateTime,
    required this.onSelectDateTime,
  });

  final String label;
  final DateTime? selectedDateTime;
  final VoidCallback onSelectDateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  AppTextStyle.soraBody(size: 15, fontWeight: FontWeight.w400)),
          InkWell(
            onTap: onSelectDateTime,
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: "Select Date and Time",
                hintStyle: AppTextStyle.soraBody(
                    size: 15, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
              ),
              child: Text(
                selectedDateTime != null
                    ? "${selectedDateTime!.toLocal()}"
                        .split('.')[0] // Format: Date and Time
                    : 'Choose Date and Time',
                style: AppTextStyle.soraBody(
                    size: 15, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventButton extends StatelessWidget {
  const EventButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
