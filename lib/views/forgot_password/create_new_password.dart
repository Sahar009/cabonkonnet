import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
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
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                  hint: 'Enter New Password',
                  controller: addressController,
                  iconData: IconsaxPlusLinear.lock),
              const SizedBox(height: 20),
              Text(
                'Confirm Password',
                style:
                    AppTextStyle.body(size: 13, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 5),
              AppTextFields(
                  hint: 'Confirm your Password',
                  controller: addressController,
                  iconData: IconsaxPlusLinear.lock),
              const Spacer(),
              AppButton(
                onTab: () {},
                title: 'Reset',
              ),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}
