import 'package:cabonconnet/helpers/core.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBackBotton extends StatelessWidget {
  final String? pageTitle;
  final bool vertical;
  const AppBackBotton({
    super.key,
    this.pageTitle,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        45.toHeightWhiteSpacing(),
        vertical
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  5.toHeightWhiteSpacing(),
                  Text(
                    pageTitle ?? "",
                    style: AppTextStyle.soraBody(
                        size: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  5.toWidthWhiteSpacing(),
                  Text(
                    pageTitle ?? "",
                    style: AppTextStyle.soraBody(
                        size: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
        10.toHeightWhiteSpacing()
      ],
    );
  }
}
