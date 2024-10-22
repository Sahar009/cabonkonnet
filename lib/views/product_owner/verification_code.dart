import 'package:cabonconnet/views/forgot_password/create_new_password.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key});

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                    'Enter the verification code sent to your email',
                    style: AppTextStyle.body(
                        size: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              PinCodeTextField(
                pinTextStyle: AppTextStyle.body(),
                keyboardType: TextInputType.number,
                maxLength: 4,
                pinBoxRadius: 8,
                pinBoxColor: const Color.fromARGB(255, 243, 238, 238),
                pinBoxHeight: 70,
              ),
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ()));
                      },
                    style: AppTextStyle.body(
                        fontWeight: FontWeight.normal,
                        size: 14,
                        color: AppColor.primaryColor))
              ])),
              const SizedBox(height: 300),
              AppButton(
                onTab: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateNewPassword()));
                },
                title: 'Verify code',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
