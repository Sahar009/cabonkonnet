import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController addressController = TextEditingController();
  AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          return authController.isBusy.value
              ? const Loading()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      const Row(
                        children: [Icon(Icons.arrow_back_ios, size: 16)],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Register',
                            style: AppTextStyle.body(size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Please fill in all information correctly',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                        ],
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
                          controller: addressController,
                          iconData: IconsaxPlusLinear.sms),
                      const Spacer(),
                      AppButton(
                        onTab: () {
                          if (addressController.text.isEmail) {
                            authController
                                .forgotpassword(addressController.text.trim());
                          }
                        },
                        title: 'Reset Password',
                      ),
                      const SizedBox(height: 100)
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
