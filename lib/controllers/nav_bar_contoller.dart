import 'package:cabonconnet/views/home/home_page.dart';
import 'package:cabonconnet/views/home/new_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarContoller extends GetxController {
  RxInt currentIndex = 0.obs;

  List<Widget> screens = [
    HomePage(),
    const Text('Events'),
    NewPost(),
    const Text('Chats'),
    const Text('Profile')
  ];

  updateCurrentIndex(int value) {
    currentIndex.value = value;
  }

  bool checkCurrentState(int value) {
    return currentIndex.value == value;
  }
}
