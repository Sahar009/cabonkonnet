import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  int currentIndex = 0;

  List<Widget> screens = [
    const Text('Home'),
    const Text('Events'),
    const Text('Post'),
    const Text('Chats'),
    const Text('Profile')
  ];

  updateCurrentIndex(int value) {
    currentIndex = value;
    notifyListeners();
  }

  bool checkCurrentState(int value) {
    return currentIndex == value;
  }
}
