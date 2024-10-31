import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class VerificationCode extends StatefulWidget {
  final bool isFirstVerify;
  final String email;
  final String password;
  const VerificationCode({
    super.key,
    required this.password,
    required this.email,
    required this.isFirstVerify,
  });

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  AuthController authController = AuthController();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return authController.isBusy.value
            ? const Loading()
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back_ios, size: 16))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Enter Verification Code',
                            style: AppTextStyle.body(size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Enter the verification code sent to your email \n ${widget.email}',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      PinCodeTextField(
                        controller: textEditingController,
                        pinTextStyle: AppTextStyle.body(),
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        pinBoxRadius: 8,
                        pinBoxColor: const Color.fromARGB(255, 243, 238, 238),
                        pinBoxHeight: 50,
                        pinBoxWidth: 50,
                        pinBoxOuterPadding: const EdgeInsets.all(10),
                        highlightPinBoxColor: Colors.white,
                        defaultBorderColor: Colors.white,
                      ),
                      Text(authController.otpStatus.value),
                      const SizedBox(height: 50),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: 'Didnt get a code? ',
                          style: AppTextStyle.body(
                              size: 14, fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                            text: 'Resend',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                authController.sendOtp(
                                    widget.email, widget.isFirstVerify);
                              },
                            style: AppTextStyle.body(
                                fontWeight: FontWeight.normal,
                                size: 14,
                                color: AppColor.primaryColor))
                      ])),
                      const SizedBox(height: 300),
                      AppButton(
                        onTab: () {
                          authController.verifyOtp(
                              widget.email,
                              textEditingController.text.trim(),
                              widget.password);
                        },
                        title: 'Verify code',
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
