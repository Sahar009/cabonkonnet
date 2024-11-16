import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/events/create_event.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CustomDialog {
  static void event({required BuildContext context}) {
    showDialog(context: context, builder: (context) => DialogWiget());
  }

  static void logout({required BuildContext context}) {
    showDialog(context: context, builder: (context) => LogOutWiget());
  }
}

class DialogWiget extends StatefulWidget {
  const DialogWiget({
    super.key,
  });

  @override
  State<DialogWiget> createState() => _DialogWigetState();
}

class _DialogWigetState extends State<DialogWiget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        padding: EdgeInsets.symmetric(horizontal: 15),
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
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.close),
                ),
              ),
            ),
            30.toHeightWhiteSpacing(),
            Text(
              "Create an event",
              style: AppTextStyle.soraBody(size: 18),
            ),
            Text(
              "Create an event, invite people to join \nwhich can be paid or free",
              textAlign: TextAlign.center,
              style: AppTextStyle.soraBody(
                fontWeight: FontWeight.w400,
              ),
            ),
            20.toHeightWhiteSpacing(),
            Row(
              children: [
                Icon(IconsaxPlusLinear.profile),
                10.toWidthWhiteSpacing(),
                Expanded(
                  child: Text(
                    "Your event will be checked and scrutinised before been posted to the public.",
                    style: AppTextStyle.body(size: 14),
                  ),
                )
              ],
            ),
            15.toHeightWhiteSpacing(),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(IconsaxPlusLinear.timer_1),
                  10.toWidthWhiteSpacing(),
                  Expanded(
                    child: Text(
                      "Do not create an event that is outside the scope or centered around clean energy ",
                      maxLines: 3,
                      style: AppTextStyle.body(size: 14),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: AppButton(
                onTab: () {
                  Get.back();
                  Get.to(() => const CreateEvent());
                },
                title: "Got it",
              ),
            ),
            40.toHeightWhiteSpacing(),
          ],
        ),
      ),
    );
  }
}

class LogOutWiget extends StatefulWidget {
  const LogOutWiget({
    super.key,
  });

  @override
  State<LogOutWiget> createState() => _LogOutWigetState();
}

class _LogOutWigetState extends State<LogOutWiget> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Obx(() {
        return Container(
          height: 250,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: authController.isBusy.value
              ? Loading()
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
                    30.toHeightWhiteSpacing(),
                    Text(
                      "Log out",
                      style: AppTextStyle.soraBody(size: 18),
                    ),
                    Text(
                      "Are you sure you want to log out?",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.soraBody(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.3,
                          child: AppButton(
                            onTab: () {
                              Get.back();
                            },
                            title: "Cancel",
                            color: AppColor.white,
                            textColor: AppColor.primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.3,
                          child: AppButton(
                            onTab: () {
                              authController.logoutUser();
                              //Get.to(() => const CreateEvent());
                            },
                            title: "Confirm",
                          ),
                        ),
                      ],
                    ),
                    40.toHeightWhiteSpacing(),
                  ],
                ),
        );
      }),
    );
  }
}
