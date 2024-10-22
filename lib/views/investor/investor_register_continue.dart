import 'package:cabonconnet/views/product_owner/verification_code.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:file_picker/file_picker.dart';

class InvestorRegisterContinue extends StatefulWidget {
  const InvestorRegisterContinue({super.key});

  @override
  State<InvestorRegisterContinue> createState() =>
      _InvestorRegisterContinueState();
}

class _InvestorRegisterContinueState extends State<InvestorRegisterContinue> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? bankStatementPath;
  String? idCardPath;

  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

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
                  controller: companyNameController,
                  iconData: IconsaxPlusLinear.bank,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your company name';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              Text(
                'Country',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                  hint: 'Enter country',
                  controller: countryController,
                  iconData: IconsaxPlusBold.cloud,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  }),
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
                  iconData: IconsaxPlusLinear.sms_edit,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              Text(
                'Upload your bank statement or tax return',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _pickFile('bank_statement'),
                child: AppTextFields(
                  hint:
                      bankStatementPath ?? 'Tap to upload your bank statement',
                  controller: TextEditingController(),
                  iconData: IconsaxPlusLinear.document,
                  isPassword: false,
                  validator: null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Upload valid ID card',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _pickFile('id_card'),
                child: AppTextFields(
                  hint: idCardPath ?? 'Tap to upload your ID card',
                  controller: TextEditingController(),
                  iconData: IconsaxPlusBold.document,
                  isPassword: false,
                  validator: null,
                ),
              ),
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
