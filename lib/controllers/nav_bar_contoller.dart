import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/views/chat/chatandforum.dart';
import 'package:cabonconnet/views/events/events.dart';
import 'package:cabonconnet/views/home/home_page.dart';
import 'package:cabonconnet/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarContoller extends GetxController {
  RxInt currentIndex = 0.obs;

  String? userId;

  @override
  onInit() {
    AppLocalStorage.getCurrentUserId().then((value) {
      userId = value;
    });
    super.onInit();
  }

  List<Widget> screens() {
    return [
      const HomePage(),
      const EventsPage(),
      Container(),
      const ChatAndForum(),
      userId == null
          ? Container()
          : ProfileView(
              userId: userId!,
              isEditable: true,
            )
    ];
  }

  updateCurrentIndex(int value) {
    currentIndex.value = value;
  }

  bool checkCurrentState(int value) {
    return currentIndex.value == value;
  }
}
