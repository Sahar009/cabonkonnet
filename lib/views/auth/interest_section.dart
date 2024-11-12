import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/controllers/interest_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterestSection extends StatefulWidget {
  const InterestSection({super.key});

  @override
  State<InterestSection> createState() => _InterestSectionState();
}

class _InterestSectionState extends State<InterestSection> {
  InterestController interestController = Get.put(InterestController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Image(image: AssetImage(AppImages.homelogo)),
                const SizedBox(height: 30),
                Text(
                  "What are your topics interests",
                  style: AppTextStyle.body(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Select three of more topics to personalize your interests \nand experience on Carbonconnect.",
                  style: AppTextStyle.body(size: 12),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  children: interestController.interests.map((interest) {
                    return GestureDetector(
                      onTap: () {
                        interestController.addOrRemove(interest);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: interestController.check(interest)
                                ? AppColor.primaryColor
                                : AppColor.white,
                            border: Border.all(
                              color: AppColor.primaryColor,
                              width: 2,
                            )),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (interestController.check(interest))
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(
                                  Icons.cancel,
                                  color: AppColor.white,
                                ),
                              ),
                            Text(
                              interest['topic'].toString().trim(),
                              style: AppTextStyle.body(
                                size: 13,
                                color: interestController.check(interest)
                                    ? AppColor.white
                                    : AppColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          width: 185,
          child: AppButton(onTab: () {
            interestController.updateInterest();
          }),
        ),
      ),
    );
  }
}
