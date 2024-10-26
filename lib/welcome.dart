import 'package:cabonconnet/views/auth/register.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image(image: AssetImage(AppImages.smalllogo)),
              Row(
                children: [
                  Text(
                    'Welcome to CarbonConnect',
                    style: AppTextStyle.body(size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Tell us who you are...',
                    style: AppTextStyle.body(
                        size: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              const SizedBox(height: 45),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Register(
                                role: "product_owner",
                              )));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.black)),
                  child: Text(
                    'Founder',
                    style: AppTextStyle.body(size: 14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Register(role: "investor")));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.black)),
                  child: Text(
                    'Investor',
                    style: AppTextStyle.body(size: 14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColor.black)),
                child: Text(
                  'Events Planner',
                  style: AppTextStyle.body(size: 14),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    'Note: You cant undo your choice once selected',
                    style: AppTextStyle.body(
                        fontWeight: FontWeight.normal, size: 13),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
