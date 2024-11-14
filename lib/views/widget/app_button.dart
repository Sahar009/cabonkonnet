import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTab;
  final String title;
  final Color? color;
  final Color? textColor;
  final double textSize;
  final double? height;
  const AppButton(
      {super.key,
      required this.onTab,
      this.title = "Continue",
      this.color = AppColor.primaryColor,
      this.textColor = AppColor.white,
      this.textSize = 15,
      this.height = 45});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColor.primaryColor)),
        child: Text(
          title,
          style: AppTextStyle.soraBody(color: textColor, size: textSize),
        ),
      ),
    );
  }
}
