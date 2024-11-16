import 'package:cabonconnet/controllers/auth_controller.dart';
import 'package:cabonconnet/views/auth/forgotpassword.dart';
import 'package:cabonconnet/constant/app_color.dart';
import 'package:cabonconnet/helpers/textstyles.dart';
import 'package:cabonconnet/views/widget/loading_widget.dart';
import 'package:cabonconnet/welcome.dart';
import 'package:cabonconnet/views/widget/app_button.dart';
import 'package:cabonconnet/views/widget/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return authController.isBusy.value
            ? const Center(child: Loading())
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),
                        Row(
                          children: [
                            Text(
                              'Login',
                              style: AppTextStyle.body(size: 22),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Welcome back',
                              style: AppTextStyle.body(
                                  size: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Email',
                          style: AppTextStyle.body(
                              size: 15, fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 5),
                        AppTextFields(
                            hint: 'Enter email address',
                            controller: emailController,
                            iconData: IconsaxPlusLinear.sms),
                        const SizedBox(height: 20),
                        Text(
                          'Password',
                          style: AppTextStyle.body(
                              size: 15, fontWeight: FontWeight.normal),
                        ),
                        AppTextFields(
                            hint: 'Enter password',
                            controller: passwordController,
                            isPassword: true,
                            iconData: IconsaxPlusLinear.lock),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Forgotpassword()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot Password?',
                                style: AppTextStyle.body(
                                    size: 14,
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 150),
                        AppButton(
                          onTab: () {
                            authController.loginUser(
                                emailController.text, passwordController.text);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => const Home()));
                          },
                          title: 'Continue',
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                              text: 'Dont have an account? ',
                              style: AppTextStyle.body(
                                  size: 14, fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                                text: 'Register',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Welcome()));
                                  },
                                style: AppTextStyle.body(
                                    fontWeight: FontWeight.normal,
                                    size: 14,
                                    color: AppColor.primaryColor))
                          ])),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
