import 'package:cabonconnet/investor/investor_register_continue.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/textstyles/textstyles.dart';
import 'package:cabonconnet/widget/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class InvestorRegister extends StatefulWidget {
  const InvestorRegister({super.key});

  @override
  State<InvestorRegister> createState() => _InvestorRegisterState();
}

class _InvestorRegisterState extends State<InvestorRegister> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                'Full Name',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                hint: 'Enter Full Name',
                controller: fullNameController,
                iconData: IconsaxPlusLinear.profile,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Email',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                hint: 'Enter email address',
                controller: emailController,
                iconData: IconsaxPlusLinear.sms,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Phone number',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                hint: 'Enter phone number',
                controller: phoneController,
                iconData: IconsaxPlusLinear.mobile,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Password',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                hint: 'Enter password',
                controller: passwordController,
                iconData: IconsaxPlusLinear.lock,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              Text(
                'Confirm Password',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                hint: 'Confirm your password',
                controller: confirmPasswordController,
                iconData: IconsaxPlusLinear.lock,
                isPassword: true,
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: () {
                  // Validate the input fields before navigating
                  // Add validation logic here

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const InvestorRegisterContinue()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'Continue',
                    style: AppTextStyle.body(color: AppColor.white, size: 14),
                  ),
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
                        // Add navigation logic here
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
