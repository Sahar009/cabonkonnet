import 'package:cabonconnet/views/home/home_page.dart';
import 'package:cabonconnet/views/home/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarContoller extends GetxController {
  RxInt currentIndex = 0.obs;

  List<Widget> screens = [
    const HomePage(),
    const Text('Events'),
    Container(),
    const Text('Chats'),
    const ProfileView()
  ];

  updateCurrentIndex(int value) {
    currentIndex.value = value;
  }

  bool checkCurrentState(int value) {
    return currentIndex.value == value;
  }
}
