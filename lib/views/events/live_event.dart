import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/event_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/models/event_model.dart';
import 'package:cabonconnet/views/ticket/buy_ticket.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/custom_divider.dart';
import 'package:cabonconnet/views/widget/event_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveEvent extends StatefulWidget {
  final EventModel event;
  const LiveEvent({super.key, required this.event});

  @override
  State<LiveEvent> createState() => _LiveEventState();
}

class _LiveEventState extends State<LiveEvent> {
  EventController eventController = Get.put(EventController());

  String? currentUserId;
  @override
  void initState() {
    AppLocalStorage.getCurrentUserId().then((value) {
      setState(() {
        currentUserId = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
            8.toHeightWhiteSpacing(),
            EventCardWidget(
              event: widget.event,
            ),
            25.toHeightWhiteSpacing(),
            const CustomDivider(),
            25.toHeightWhiteSpacing(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About event',
                    style: AppTextStyle.body(
                      fontWeight: FontWeight.w600,
                      size: 15,
                    )),
                Text(widget.event.description,
                    style: AppTextStyle.soraBody(
                      fontWeight: FontWeight.w300,
                      size: 13,
                    )),
                35.toHeightWhiteSpacing(),
                if (widget.event.accessType == "Paid")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Ticket',
                          style: AppTextStyle.body(
                            fontWeight: FontWeight.w600,
                            size: 15,
                          )),
                      Text("\$ ${widget.event.ticketPrice}",
                          style: AppTextStyle.soraBody(
                            fontWeight: FontWeight.w300,
                            size: 13,
                          )),
                    ],
                  ),
              ],
            ),
            const Spacer(),
            !widget.event.participants!.contains(currentUserId)
                ? widget.event.accessType == "Paid"
                    ? AppButton(
                        onTab: () {
                          Get.to(() => BuyTicket(
                                event: widget.event,
                              ));
                        },
                        title: "Book ticket",
                      )
                    : AppButton(
                        onTab: () {
                          eventController.addParticipants(currentUserId ?? '',
                              widget.event.id, widget.event);
                        },
                        title: "Join event",
                      )
                : Container(
                    height: 44,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        "You’re already registered.",
                        style: AppTextStyle.soraBody(
                          color: AppColor.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
            50.toHeightWhiteSpacing()
          ],
        ),
      ),
    );
  }
}
