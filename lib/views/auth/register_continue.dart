import 'dart:io';
import 'package:cabonconnet/constant/country.dart';
import 'package:cabonconnet/controllers/user_controller.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class UpdateUserDetails extends StatefulWidget {
  final String role;
  final UserModel userModel;
  const UpdateUserDetails(
      {super.key, required this.userModel, required this.role});

  @override
  State<UpdateUserDetails> createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController businessRegNumberController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  UserController userController = UserController();

  String? bankStatementPath;
  String? idCardPath;
  String? _selectedTeamSize;

  String? selectedCountry;
  final List<String> _teamSizes = [
    '1 - 10',
    '20 - 30',
    '40 - 50',
    '50 - above',
  ];
  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        if (type == 'bank_statement') {
          bankStatementPath = result.files.single.path;
        } else if (type == 'id_card') {
          idCardPath = result.files.single.path;
        }
      });
    }
  }

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
      body: Obx(() {
        return userController.isBusy.value
            ? const Loading()
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: _formKey, // Attach the form key
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text(
                            'Register',
                            style: AppTextStyle.body(size: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Please fill in all information correctly',
                            style: AppTextStyle.body(
                                size: 15, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Name of company',
                            style: AppTextStyle.body(
                                size: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          AppTextFields(
                            hint: 'Enter your company name',
                            controller: companyNameController,
                            iconData: IconsaxPlusLinear.bank,
                            validator: (value) => _validateField(
                                value, 'Company name'), // Validator
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Country',
                            style: AppTextStyle.body(
                                size: 15, fontWeight: FontWeight.w500),
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
                                size: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black),
                            decoration: InputDecoration(
                              hintText: 'Select country',
                              hintStyle: AppTextStyle.body(
                                  size: 12,
                                  fontWeight: FontWeight.w500,
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
                                size: 15, fontWeight: FontWeight.w500),
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
                          widget.role == "founder"
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Business Reg. Number',
                                      style: AppTextStyle.body(
                                          size: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5),
                                    AppTextFields(
                                      hint: 'Enter business reg number',
                                      controller: businessRegNumberController,
                                      iconData: IconsaxPlusLinear.document,
                                      validator: (value) => _validateField(
                                          value,
                                          'Business Reg. Number'), // Validator
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Website (optional)',
                                      style: AppTextStyle.body(
                                          size: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5),
                                    AppTextFields(
                                      hint: 'Enter your company website',
                                      controller: websiteController,
                                      iconData: IconsaxPlusBold.global,
                                      // Website field doesn't need validation as it's optional
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'No of team members',
                                      style: AppTextStyle.body(
                                          size: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: _teamSizes.length,
                                            itemBuilder: (context, index) {
                                              return RadioListTile<String>(
                                                title: Text(
                                                  _teamSizes[index],
                                                  style: AppTextStyle.body(
                                                      size: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                value: _teamSizes[index],
                                                groupValue: _selectedTeamSize,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedTeamSize = value;
                                                  });
                                                },
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: -2,
                                                        vertical: -4),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: -4),
                                              );
                                            })),
                                    const SizedBox(height: 60),
                                    AppButton(onTab: () {
                                      if (_formKey.currentState!.validate()) {
                                        userController.updateUser(
                                            userModel: widget.userModel,
                                            address: addressController.text,
                                            country: selectedCountry!,
                                            companyName:
                                                companyNameController.text,
                                            website: websiteController.text,
                                            busRegNum:
                                                businessRegNumberController
                                                    .text,
                                            teamNumber: _selectedTeamSize);
                                      }
                                    }),
                                    const SizedBox(height: 30),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Upload your bank statement or tax return',
                                      style: AppTextStyle.body(
                                          size: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () => _pickFile('bank_statement'),
                                      child: AppTextFields(
                                        onTab: () =>
                                            _pickFile('bank_statement'),
                                        isReadOnly: true,
                                        hint: bankStatementPath ??
                                            'Tap to upload your bank statement',
                                        controller: TextEditingController(),
                                        iconData: IconsaxPlusLinear.document,
                                        isPassword: false,
                                        validator: null,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Upload valid ID card',
                                      style: AppTextStyle.body(
                                          size: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () => _pickFile('id_card'),
                                      child: AppTextFields(
                                        onTab: () => _pickFile('id_card'),
                                        isReadOnly: true,
                                        hint: idCardPath ??
                                            'Tap to upload your ID card',
                                        controller: TextEditingController(),
                                        iconData: IconsaxPlusBold.document,
                                        isPassword: false,
                                        validator: null,
                                      ),
                                    ),
                                    const SizedBox(height: 80),
                                    AppButton(onTab: () {
                                      if (_formKey.currentState!.validate()) {
                                        userController.updateUser(
                                            userModel: widget.userModel,
                                            address: addressController.text,
                                            country: selectedCountry!,
                                            website: websiteController.text,
                                            busRegNum:
                                                businessRegNumberController
                                                    .text,
                                            companyName:
                                                companyNameController.text,
                                            bankStat: File(bankStatementPath!),
                                            validId: File(idCardPath!));
                                      }
                                    }),
                                    const SizedBox(height: 30),
                                  ],
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
