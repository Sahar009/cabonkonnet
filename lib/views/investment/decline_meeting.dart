import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/meeting_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/meeting_model.dart';
import 'package:cabonconnet/views/widget/app_back_botton.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeclineMeeting extends StatefulWidget {
  final MeetingModel meetingModel;
  const DeclineMeeting({super.key, required this.meetingModel});

  @override
  State<DeclineMeeting> createState() => _DeclineMeetingState();
}

class _DeclineMeetingState extends State<DeclineMeeting> {
  TextEditingController reason = TextEditingController();
  MeetingController meetingController = Get.put(MeetingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
         () {
          return meetingController.isLoading.value ? const Loading() : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBackBotton(),
                Text(
                  'Investment ',
                  style: AppTextStyle.soraBody(
                      fontWeight: FontWeight.normal, size: 18),
                ),
                15.toHeightWhiteSpacing(),
                Text(
                  'Kindly let us know why you want to decline this invitation',
                  style: AppTextStyle.soraBody(
                      size: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: reason,
                  maxLines: 7,
                  minLines: 7,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.filledColor,
                      hintStyle: AppTextStyle.soraBody(
                          size: 13, fontWeight: FontWeight.w300),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      hintText: "Give your reasons..."),
                ),
                const Spacer(),
                AppButton(
                  onTab: () {
                    if (reason.text.isNotEmpty) {
                      meetingController.rejectMeeting(
                          widget.meetingModel.id, reason.text, widget.meetingModel);
                    } else {
                      CustomSnackbar.error(message: "Reason field cannot be empty");
                    }
                  },
                  title: "Decline request",
                ),
                70.toHeightWhiteSpacing(),
              ],
            ),
          );
        }
      ),
    );
  }
}
