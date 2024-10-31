import 'package:cabonconnet/constant/app_images.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/views/auth/register_continue.dart';
import 'package:cabonconnet/views/auth/verification_code.dart';
import 'package:cabonconnet/views/home/home.dart';
import 'package:cabonconnet/views/onboarding/onboarding.dart';
import 'package:cabonconnet/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController = Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());
  AppLocalStorage appLocalStorage = AppLocalStorage();
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      appLocalStorage.getOnBoarding().then((value) {
        if (value == "true") {
          authController.authRepository.account.get().then((value) async {
            if (value.emailVerification) {
              AppLocalStorage.setCurrentUserId(value.$id);

              await profileController.getUserDetails();
              UserModel? user = profileController.userModelRx.value;

              if (user != null &&
                  (user.companyName == null || user.country == null)) {
                Get.to(
                    () => UpdateUserDetails(userModel: user, role: user.role));
              } else {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              }
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
