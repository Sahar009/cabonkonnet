import 'package:cabonconnet/constant/app_color.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 0.8,
      decoration: const BoxDecoration(color: AppColor.primaryColor),
    );
  }
}
