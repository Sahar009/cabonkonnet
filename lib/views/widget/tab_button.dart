
import 'package:cabonconnet/constant/app_color.dart';
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
        Text(title),
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
