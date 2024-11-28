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

  const MeetingInvitation({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    // Controller instance
    MeetingController meetingController = Get.put(MeetingController());

    // Fetch the meeting details
    meetingController.fetchMeeting(meetingId);

    return Scaffold(
      body: Obx(() {
        final meeting = meetingController.meeting.value;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackBotton(
                pageTitle: "Invitation",
                vertical: true,
              ),
              20.toHeightWhiteSpacing(),
              // Text("data")
              // // Meeting details with reactive UI
              SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: meetingController.meeting.value == null ||
                          meeting == null
                      ? const Loading()
                      : // Loading state

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                style: AppTextStyle.body(
                                    size: 15,
                                    color: AppColor
                                        .primaryColor), // Base style for the whole text
                                children: [
                                  TextSpan(
                                    text:
                                        "${meeting.investor?.companyName ?? meeting.investor?.fullName}",
                                    style: AppTextStyle.body(
                                        size: 15,
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight
                                            .bold), // Bold style for the company name
                                  ),
                                  TextSpan(
                                    text:
                                        " invited you to a business meet-up scheduled for ${Core.formatDate(meeting.scheduledAt!)}",
                                    style: AppTextStyle.body(
                                        size: 15), // Regular style for the rest
                                  ),
                                ],
                              ),
                            ),
                            20.toHeightWhiteSpacing(),

                            // Action buttons
                            if (meeting.status == MeetingStatus.rejected)
                              Container(
                                child: Text(
                                  "You declined this meeting because: ${meeting.founderRejectReason}",
                                  style: AppTextStyle.body(size: 14),
                                ),
                              ),
                            if (meeting.status == MeetingStatus.cancelled)
                              Container(
                                child: Text(
                                  "The investor canceled this meeting because: ${meeting.investorCancelReason}",
                                  style: AppTextStyle.body(size: 14),
                                ),
                              ),
                            if (meeting.status == MeetingStatus.scheduled)
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Below is the meeting link:",
                                      style: AppTextStyle.body(size: 14),
                                    ),
                                    Text(
                                      "${meeting.meetingLink ?? "N/A"}",
                                      style: AppTextStyle.body(size: 14),
                                    ),
                                  ],
                                ),
                              ),

                            if (meeting.status == MeetingStatus.pending)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: AppButton(
                                      onTab: () => meetingController
                                          .acceptMeeting(meeting.id, meeting),
                                      title: "Accept",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: AppButton(
                                      onTab: () {
                                        Get.to(() => DeclineMeeting(
                                              meetingModel: meeting,
                                            ));
                                      },
                                      title: "Decline",
                                      color: AppColor.white,
                                      textColor: AppColor.primaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: AppButton(
                                      onTab: () {
                                        Get.to(() => RescheduleMeeting(
                                              meetingModel: meeting,
                                            ));
                                      },
                                      title: "Reschedule",
                                      color: AppColor.white,
                                      textColor: AppColor.primaryColor,
                                    ),
                                  ),
                                ],
                              ),

                            15.toHeightWhiteSpacing(),
                            const CustomDivider(),
                          ],
                        )),
            ],
          ),
        );
      }),
    );
  }
}
