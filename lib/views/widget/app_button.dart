import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTab;
  final String title;
  final Color color;
  const AppButton(
      {super.key,
      required this.onTab,
      this.title = "Continue",
      this.color = AppColor.primaryColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 45,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(
          title,
          style: AppTextStyle.body(color: AppColor.white, size: 14),
        ),
      ),
    );
  }
}
