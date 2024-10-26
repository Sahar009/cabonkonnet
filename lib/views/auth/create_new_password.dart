import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CreateNewPassword extends StatefulWidget {
  final String email;
  const CreateNewPassword({super.key, required this.email});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: authController.isBusy.value
            ? Loading()
            : Center(
                child: Padding(
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
                            'Create new password',
                            style: AppTextStyle.body(size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Create a new password',
                            style: AppTextStyle.body(
                                size: 13, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'New Password',
                        style: AppTextStyle.body(
                            size: 13, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 5),
                      AppTextFields(
                          hint: 'Enter New Password',
                          isPassword: true,
                          controller: passwordController,
                          iconData: IconsaxPlusLinear.lock),
                      const SizedBox(height: 20),
                      Text(
                        'Confirm Password',
                        style: AppTextStyle.body(
                            size: 13, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 5),
                      AppTextFields(
                          hint: 'Confirm your Password',
                          controller: cPasswordController,
                          isPassword: true,
                          iconData: IconsaxPlusLinear.lock),
                      const Spacer(),
                      AppButton(
                        onTab: () {
                          if (passwordController.text ==
                              cPasswordController.text) {
                            authController.updatePassword(
                                widget.email, cPasswordController.text);
                          } else {
                            Get.snackbar(
                              "Confirm Password",
                              "Password must be confirmed",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 100)
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
