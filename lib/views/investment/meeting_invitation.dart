import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/meeting_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/meeting_model.dart';
import 'package:cabonconnet/views/investment/decline_meeting.dart';
import 'package:cabonconnet/views/investment/reschedule_meeting.dart';
import 'package:cabonconnet/views/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingInvitation extends StatelessWidget {
  final String meetingId;

  const MeetingInvitation({Key? key, required this.meetingId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller instance
    final MeetingController meetingController = Get.put(MeetingController());

    // Fetch meeting details once
    if (!meetingController.isLoading.value) {
      meetingController.fetchMeeting(meetingId);
    }

    return Scaffold(
      body: Obx(() {
        final meeting = meetingController.meeting.value;

        if (meeting == null) {
          return const Center(
              child: CircularProgressIndicator()); // Loading state
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackBotton(
                pageTitle: "Invitation",
                vertical: true,
              ),
              const SizedBox(height: 20),

              // Meeting Details
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style:
                      AppTextStyle.body(size: 15, color: AppColor.primaryColor),
                  children: [
                    TextSpan(
                      text:
                          meeting.investor?.companyName ?? meeting.investor?.fullName ?? "Unknown Investor",
                      style: AppTextStyle.body(
                        size: 15,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          " invited you to a business meet-up scheduled for ${Core.formatDate(meeting.scheduledAt!)}",
                      style: AppTextStyle.body(size: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Status-Specific Details
              if (meeting.status == MeetingStatus.rejected)
                Text(
                  "You declined this meeting for the following reason: ${meeting.founderRejectReason ?? "No reason provided."}",
                  style: AppTextStyle.body(size: 14),
                ),
              if (meeting.status == MeetingStatus.cancelled)
                Text(
                  "The investor canceled this meeting for the following reason: ${meeting.investorCancelReason ?? "No reason provided."}",
                  style: AppTextStyle.body(size: 14),
                ),
              if (meeting.status == MeetingStatus.scheduled)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meeting Link:",
                      style: AppTextStyle.body(size: 14),
                    ),
                    Text(
                      meeting.meetingLink ?? "N/A",
                      style: AppTextStyle.body(size: 14),
                    ),
                  ],
                ),

              // Action Buttons
              if (meeting.status == MeetingStatus.pending)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 120,
                      child: AppButton(
                        onTab: () => meetingController.acceptMeeting(
                            meeting.id, meeting),
                        title: "Accept",
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: AppButton(
                        onTab: () =>
                            Get.to(() => DeclineMeeting(meetingModel: meeting)),
                        title: "Decline",
                        color: AppColor.white,
                        textColor: AppColor.primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: AppButton(
                        onTab: () => Get.to(
                            () => RescheduleMeeting(meetingModel: meeting)),
                        title: "Reschedule",
                        color: AppColor.white,
                        textColor: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 15),
              const CustomDivider(),
            ],
          ),
        );
      }),
    );
  }
}
