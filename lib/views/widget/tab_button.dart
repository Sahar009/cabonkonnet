import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;
  const TabButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(children: [
        Text(title,
            style: AppTextStyle.body(
                color: isActive ? AppColor.primaryColor : AppColor.black,
                size: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500)),
        Container(
          width: 87,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(5),
              topEnd: Radius.circular(5),
            ),
            color: isActive ? AppColor.primaryColor : null,
          ),
        )
      ]),
    );
  }
}
