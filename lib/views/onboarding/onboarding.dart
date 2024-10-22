import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/welcome.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:flutter/material.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Skip',
                    style: AppTextStyle.body(size: 14),
                  ),
                  const Icon(Icons.arrow_forward, size: 22)
                ],
              ),
              SizedBox(
                height: 600,
                child: PageView(
                  controller: controller,
                  children: [
                    OnboardingWidget(
                      imagePath: AppImages.first,
                      title: "Meet Up The Right ",
                      title2: "Investors",
                      subTitle:
                          "Meet with the right investors to invest in your product and make it a reality.',",
                    ),
                    OnboardingWidget(
                      imagePath: AppImages.second,
                      title: "Showcase your solution and ",
                      title2: "get Funded",
                      subTitle:
                          'Showcase your sustainable environmental solutions for humanity ',
                    ),
                    OnboardingWidget(
                        imagePath: AppImages.third,
                        title: "Set Up sustainable renewable energy  ",
                        title2: "Events",
                        subTitle:
                            'Get to host your  events and get the necessary support you need.'),
                  ],
                ),
              ),
              AppButton(
                onTab: () {
                  if (controller.page == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Welcome()));
                  } else {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String title2;
  final String subTitle;
  const OnboardingWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.title2,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Image(
          image: AssetImage(imagePath),
          height: 300,
        ),
        const SizedBox(height: 40),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: title,
                style: AppTextStyle.body(color: AppColor.black),
                children: [
                  TextSpan(
                    text: title2,
                    style: AppTextStyle.body(color: AppColor.primaryColor),
                  )
                ])),
        const SizedBox(height: 20),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: AppTextStyle.body(fontWeight: FontWeight.normal, size: 13),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
