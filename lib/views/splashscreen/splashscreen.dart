import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/views/auth/verification_code.dart';
import 'package:cabonconnet/views/home/home.dart';
import 'package:cabonconnet/views/onboarding/onboarding.dart';
import 'package:cabonconnet/welcome.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController = AuthController();
  AppLocalStorage appLocalStorage = AppLocalStorage();
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      appLocalStorage.getOnBoarding().then((value) {
        if (value == "true") {
          authController.authRepository.account.get().then((value) {
            if (value.emailVerification) {
              AppLocalStorage.setCurrentUserId(value.$id);
              Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => Home()));
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerificationCode(
                    email: value.email,
                    isFirstVerify: true,
                    password: "",
                  ),
                ),
              );
            }
          }).onError((s, ss) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Welcome()));
          });
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Onboarding1()));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image(image: AssetImage(AppImages.logo))],
        ),
      ),
    );
  }
}
