import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/controllers/nav_bar_contoller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Home extends StatelessWidget {
  NavBarContoller contoller = Get.put(NavBarContoller());
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: contoller.screens[contoller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: contoller.currentIndex.value,
          onTap: contoller.updateCurrentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  IconsaxPlusLinear.home,
                  color: contoller.checkCurrentState(0)
                      ? AppColor.black
                      : AppColor.grey,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  IconsaxPlusLinear.calendar_2,
                  color: contoller.checkCurrentState(1)
                      ? AppColor.black
                      : AppColor.grey,
                ),
                label: 'Events'),
            BottomNavigationBarItem(
                icon: Icon(
                  IconsaxPlusLinear.add_square,
                  color: contoller.checkCurrentState(2)
                      ? AppColor.black
                      : AppColor.grey,
                ),
                label: 'Post'),
            BottomNavigationBarItem(
                icon: Icon(
                  IconsaxPlusLinear.message_minus,
                  color: contoller.checkCurrentState(3)
                      ? AppColor.black
                      : AppColor.grey,
                ),
                label: 'Chats'),
            BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage(AppImages.smallpicture2),
                  color: contoller.checkCurrentState(4)
                      ? AppColor.black
                      : AppColor.grey,
                ),
                label: 'Profile'),
          ],
        ),
      );
    });
  }
}
