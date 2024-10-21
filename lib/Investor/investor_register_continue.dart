import 'package:cabonconnet/Product_Owner/verification_code.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/textstyles/textstyles.dart';
import 'package:cabonconnet/widget/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class InvestorRegisterContinue extends StatefulWidget {
  const InvestorRegisterContinue({super.key});

  @override
  State<InvestorRegisterContinue> createState() =>
      _InvestorRegisterContinueState();
}

class _InvestorRegisterContinueState extends State<InvestorRegisterContinue> {
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [Icon(Icons.arrow_back_ios, size: 16)],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Register',
                style: AppTextStyle.body(size: 22),
              ),
              const SizedBox(height: 5),
              Text(
                'Please fill in all information correctly',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              Text(
                'Name of company',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                  hint: 'Enter your company name',
                  controller: addressController,
                  iconData: IconsaxPlusLinear.bank),
              const SizedBox(height: 20),
              Text(
                'Country',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                  hint: 'Enter country',
                  controller: addressController,
                  iconData: IconsaxPlusBold.cloud),
              const SizedBox(height: 20),
              Text(
                'Address',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                  hint: 'Enter your address',
                  controller: addressController,
                  iconData: IconsaxPlusLinear.sms_edit),
              const SizedBox(height: 20),
              Text(
                'Upload your bank statement or tax return',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                  hint: 'Upload your bank statement ',
                  controller: addressController,
                  iconData: IconsaxPlusLinear.document),
              const SizedBox(height: 20),
              Text(
                'Upload valid ID card',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                  hint: 'upload your ID card',
                  controller: addressController,
                  iconData: IconsaxPlusBold.document),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VerificationCode()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text('Continue',
                      style:
                          AppTextStyle.body(color: AppColor.white, size: 14)),
                ),
              ),
              const SizedBox(height: 30),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: 'Already have an account? ',
                  style: AppTextStyle.body(
                      size: 14, fontWeight: FontWeight.normal),
                ),
                TextSpan(
                    text: 'Login',
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
            ],
          ),
        ),
      ),
    );
  }
}
