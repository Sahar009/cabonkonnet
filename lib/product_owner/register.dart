import 'package:cabonconnet/login/login.dart';
import 'package:cabonconnet/product_owner/register_continue.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/textstyles/textstyles.dart';
import 'package:cabonconnet/widget/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProductOwnerRegister extends StatefulWidget {
  const ProductOwnerRegister({super.key});

  @override
  State<ProductOwnerRegister> createState() => _ProductOwnerRegisterState();
}

class _ProductOwnerRegisterState extends State<ProductOwnerRegister> {
  final _formKey = GlobalKey<FormState>();

  // Separate controllers for each text field
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Custom Validators
  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

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
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    } else if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey, // Attach the form key here
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
                    controller: fullNameController,
                    iconData: IconsaxPlusLinear.profile,
                    validator: _validateFullName, // Added validator here
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
                    controller: emailController,
                    iconData: IconsaxPlusLinear.sms,
                    validator: _validateEmail, // Added validator here
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
                    controller: phoneController,
                    iconData: IconsaxPlusLinear.mobile,
                    validator: _validatePhone, // Added validator here
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Password',
                    style: AppTextStyle.body(
                        size: 13, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 5),
                  AppTextFields(
                    hint: 'Enter password',
                    controller: passwordController,
                    iconData: IconsaxPlusLinear.lock,
                    validator: _validatePassword, // Added validator here
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
                    controller: confirmPasswordController,
                    iconData: IconsaxPlusLinear.lock,
                    validator: _validateConfirmPassword, // Added validator here
                  ),
                  const SizedBox(height: 80),
                  GestureDetector(
                    onTap: () {
                      // Check if form is valid before continuing
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterContinue(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Continue',
                        style:
                            AppTextStyle.body(color: AppColor.white, size: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: AppTextStyle.body(
                              size: 14, fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: 'Login',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                          style: AppTextStyle.body(
                            fontWeight: FontWeight.normal,
                            size: 14,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
