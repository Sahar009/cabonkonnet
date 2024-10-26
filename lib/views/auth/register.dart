import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/auth/login.dart';
import 'package:cabonconnet/views/auth/register_continue.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for dependency injection
import 'package:iconsax_plus/iconsax_plus.dart';

class Register extends StatefulWidget {
  final String role;
  const Register({super.key, required this.role});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthController authController =
      Get.put(AuthController()); // Initialize AuthController

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^[0-9]{10,}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    } else if (value != authController.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return authController.isBusy.value
            ? Loading()
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: _formKey,
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
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Full Name',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 5),
                          AppTextFields(
                            hint: 'Enter Full Name',
                            controller: authController.fullNameController,
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
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 5),
                          AppTextFields(
                            hint: 'Enter email address',
                            controller: authController.emailController,
                            iconData: IconsaxPlusLinear.sms,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Phone number',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 5),
                          AppTextFields(
                              hint: 'Enter phone number',
                              controller: authController.phoneController,
                              iconData: IconsaxPlusLinear.mobile,
                              validator: _validatePhone),
                          const SizedBox(height: 20),
                          Text(
                            'Password',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 5),
                          AppTextFields(
                            hint: 'Enter password',
                            controller: authController.passwordController,
                            iconData: IconsaxPlusLinear.lock,
                            isPassword: true,
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Confirm Password',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 5),
                          AppTextFields(
                            hint: 'Confirm your password',
                            controller:
                                authController.confirmPasswordController,
                            iconData: IconsaxPlusLinear.lock,
                            isPassword: true,
                            validator: _validateConfirmPassword,
                          ),
                          const SizedBox(height: 80),
                          Obx(() => GestureDetector(
                                onTap: () async {
                                  // Validate the input fields

                                  // Set the busy state to true
                                  if (_formKey.currentState!.validate()) {
                                    // Call the registerUser method
                                    await authController.registerUser(
                                        role: widget.role);
                                  }

                                  // Reset the busy state

                                  // Navigate to the next screen if registration is successful
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: authController.isBusy.value
                                          ? Colors.grey
                                          : AppColor.primaryColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: authController.isBusy.value
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColor.white),
                                        )
                                      : Text(
                                          'Continue',
                                          style: AppTextStyle.body(
                                              color: AppColor.white, size: 14),
                                        ),
                                ),
                              )),
                          const SizedBox(height: 30),
                          Center(
                            child: Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: AppTextStyle.body(
                                        size: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  TextSpan(
                                      text: 'Login',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => Login());
                                          // Add navigation logic here
                                        },
                                      style: AppTextStyle.body(
                                          fontWeight: FontWeight.normal,
                                          size: 14,
                                          color: AppColor.primaryColor))
                                ])),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
