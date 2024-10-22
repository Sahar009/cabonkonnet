import 'package:cabonconnet/product_owner/verification_code.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/textstyles/textstyles.dart';
import 'package:cabonconnet/widget/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class RegisterContinue extends StatefulWidget {
  const RegisterContinue({super.key});

  @override
  State<RegisterContinue> createState() => _RegisterContinueState();
}

class _RegisterContinueState extends State<RegisterContinue> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController businessRegNumberController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  // Selected Country
  String? selectedCountry;

  // List of Countries
  final List<String> countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'India',
    'Australia',
    'Nigeria', // Add more countries as needed
  ];

  // Custom Validators
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey, // Attach the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Row(
                  children: [Icon(Icons.arrow_back_ios, size: 16)],
                ),
                const SizedBox(height: 10),
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
                  'Name of company',
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 5),
                AppTextFields(
                  hint: 'Enter your company name',
                  controller: companyNameController,
                  iconData: IconsaxPlusLinear.bank,
                  validator: (value) =>
                      _validateField(value, 'Company name'), // Validator
                ),
                const SizedBox(height: 20),
                Text(
                  'Country',
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selectedCountry,
                  items: countries.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  style: AppTextStyle.body(
                      size: 13,
                      fontWeight: FontWeight.normal,
                      color: AppColor.black),
                  decoration: InputDecoration(
                    hintText: 'Select country',
                    hintStyle: AppTextStyle.body(
                        size: 12,
                        fontWeight: FontWeight.normal,
                        color: AppColor.black),
                    filled: true,
                    fillColor: const Color(0xffF5F5F5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a country'
                      : null, // Validator
                ),
                const SizedBox(height: 20),
                Text(
                  'Address',
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 5),
                AppTextFields(
                  hint: 'Enter your address',
                  controller: addressController,
                  iconData: IconsaxPlusLinear.sms_edit,
                  validator: (value) =>
                      _validateField(value, 'Address'), // Validator
                ),
                const SizedBox(height: 20),
                Text(
                  'Business Reg. Number',
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 5),
                AppTextFields(
                  hint: 'Enter business reg number',
                  controller: businessRegNumberController,
                  iconData: IconsaxPlusLinear.document,
                  validator: (value) => _validateField(
                      value, 'Business Reg. Number'), // Validator
                ),
                const SizedBox(height: 20),
                Text(
                  'Website (optional)',
                  style: AppTextStyle.body(
                      size: 13, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 5),
                AppTextFields(
                  hint: 'Enter your company website',
                  controller: websiteController,
                  iconData: IconsaxPlusBold.global,
                  // Website field doesn't need validation as it's optional
                ),
                const SizedBox(height: 80),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerificationCode(),
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
                        // Navigation to Login screen goes here
                      },
                    style: AppTextStyle.body(
                      fontWeight: FontWeight.normal,
                      size: 14,
                      color: AppColor.primaryColor,
                    ),
                  )
                ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
