
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class EventsWidget extends StatelessWidget {
  final String heading;
  final String subtitle;
  final String imagePath;
  final String hostName;
  final bool isUpcoming;
  const EventsWidget({
    super.key,
    required this.heading,
    required this.subtitle,
    required this.imagePath,
    required this.hostName,
    this.isUpcoming = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xff0091CC),
              borderRadius: isUpcoming
                  ? BorderRadius.circular(10)
                  : const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(heading,
                    style: AppTextStyle.body(
                        size: 16,
                        color: AppColor.white,
                        fontWeight: FontWeight.w500)),
                Text(
                  subtitle,
                  style: AppTextStyle.body(
                      color: AppColor.white,
                      size: 14,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
        isUpcoming
            ? Container()
            : Container(
                height: 60,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xff00AAF1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Image(image: AssetImage(imagePath)),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hostName,
                            style: AppTextStyle.body(
                                color: AppColor.white, size: 15)),
                        Text(
                          'Host',
                          style: AppTextStyle.body(
                              fontWeight: FontWeight.normal,
                              color: AppColor.white,
                              size: 13),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ],
    );
  }
}
