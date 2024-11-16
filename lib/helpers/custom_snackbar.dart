import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static error({String title = 'Fail', String message = 'Some Error Occor'}) {
    Get.snackbar("Success", 'Successfully logged out',
        messageText: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Color(0xffFF4E4E),
          ),
        ),
        titleText: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xffFF4E4E),
          ),
        ),
        icon: Container(
          margin: const EdgeInsets.only(left: 13),
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: Color(0xffFF5D52),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            size: 18,
            color: Colors.white,
          ),
        ),
        // padding: EdgeInsets.symmetric(horizontal: 20),
        // borderColor: Color(0xffC1F3D3),
        colorText: const Color(0xffFF4E4E),
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: const Color(0xffFFD6D6));
  }

  static success(
      {String title = 'Success', String message = 'Successfully logged out'}) {
    Get.snackbar("Success", 'Successfully logged out',
        messageText: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Color(0xff005304),
          ),
        ),
        titleText: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff005304),
          ),
        ),
        icon: Container(
          margin: const EdgeInsets.only(left: 13),
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: Color(0xff35C74D),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 18,
            color: Colors.white,
          ),
        ),
        // padding: EdgeInsets.symmetric(horizontal: 20),
        // borderColor: Color(0xffC1F3D3),
        colorText: const Color(0xff005304),
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: const Color(0xffC1F3D3));
  }
}
