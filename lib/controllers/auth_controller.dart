import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/auth_repository.dart';
import 'package:cabonconnet/views/auth/create_new_password.dart';
import 'package:cabonconnet/views/auth/login.dart';
import 'package:cabonconnet/views/auth/register_continue.dart';
import 'package:cabonconnet/views/auth/verification_code.dart';
import 'package:cabonconnet/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var isBusy = false.obs;
  final AuthRepository authRepository = AuthRepository(
    account: AppwriteConfig().account,
    database: AppwriteConfig().databases,
    userCollectionId: AppwriteConfig.userCollectionId,
    databaseId: AppwriteConfig.databaseId,
  );

  var otpStatus = "".obs;
  final _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;
  var userRole;
  // Register a new user
  Future<void> registerUser({required String role}) async {
    isBusy.value = true;
    try {
      // Store the password for later use in login
      final (isSuccess, userModel, message) = await authRepository.registerUser(
          email: emailController.text,
          password: passwordController.text,
          fullName: fullNameController.text,
          phoneNumber: phoneController.text,
          role: role);

      if (isSuccess && userModel != null) {
        Get.snackbar("Registration", message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.check),
            colorText: Colors.green);
        isBusy.value = false;
        // Navigate to OTP Verification Screen
        Get.to(() => VerificationCode(
              isFirstVerify: true,
              email: emailController.text,
              password: passwordController.text,
            ));
      } else {
        Get.snackbar('Error', message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error),
            colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.error),
        colorText: Colors.red,
      );
    } finally {
      isBusy.value = false;
    }
  }

  Future resendOtp() async {}

  // Login the user and navigate to Profile Update if navigateToProfile is true
  Future<void> loginUser(String email, String password,
      {bool navigateToProfile = false}) async {
    isBusy.value = true;
    try {
      final (status, userModel, message) =
          await authRepository.loginUser(email, password);

      if (status) {
        // Navigate to Profile Update page after successful login
        if (navigateToProfile) {
          Get.off(() => UpdateUserDetails(
                role: _user.value?.role ?? userModel!.role,
                userModel: _user.value ?? userModel!,
              )); // Navigate to Profile Update Page
        } else {
          Get.offAll(() => Home()); // Navigate to Home if not updating profile
        }
      } else {
        Get.snackbar('Error', message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error),
            colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error),
          colorText: Colors.red);
    } finally {
      isBusy.value = false;
    }
  }

  // Send OTP
  Future<void> sendOtp(String email, bool isFirstVerify) async {
    isBusy.value = true;
    try {
      final (status, message) = await authRepository.sendOtp(
        email: email,
        isFirstVerify: isFirstVerify,
      );

      if (status) {
        isBusy.value = false; // Set to false before redirect

        Get.snackbar("OTP Sent", message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.check),
            colorText: Colors.green);
      } else {
        isBusy.value = false; // Set to false before redirect

        Get.snackbar('Error', message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error),
            colorText: Colors.red);
      }
      isBusy.value = false; // Set to false before redirect
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error),
          colorText: Colors.red);
    } finally {
      isBusy.value = false;
    }
  }

  // Verify OTP and then call loginUser
  Future<void> verifyOtp(String email, String otp, String password) async {
    isBusy.value = true;
    if (otp.length != 4) {
      Get.snackbar('Error', "Input Valid OTP",
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error),
          colorText: Colors.red);
      isBusy.value = false;
      return;
    }

    try {
      final (status, isRecover, message) =
          await authRepository.verifyOtp(email: email, otp: otp);
      otpStatus.value = message;
      if (status) {
        Get.snackbar("OTP Verified", message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.check),
            colorText: Colors.green);

        if (isRecover == true) {
          Get.off(() => CreateNewPassword(
                email: email,
              ));
        }

        if (password.isNotEmpty) {
          final (statu, userModel, message) =
              await authRepository.loginUser(email, password);

          if (statu) {
            Get.off(() => UpdateUserDetails(
                  role: _user.value?.role ?? userModel!.role,
                  userModel: _user.value ?? userModel!,
                ));
          }
        } else {
          Get.snackbar('Error', "Password not found, please retry login.",
              snackPosition: SnackPosition.BOTTOM,
              icon: const Icon(Icons.error),
              colorText: Colors.red);
          Get.to(() => const Login());
        }
      } else {
        Get.snackbar('Error', message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error),
            colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'OTP verification failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error),
          colorText: Colors.red);
    } finally {
      isBusy.value = false;
    }
  }

  Future forgotpassword(String email) async {
    try {
      isBusy.value = true;

      final (status, message) = await authRepository.sendOtp(
        email: email,
        isFirstVerify: false,
      );

      if (status) {
        Get.snackbar("OTP Sent", message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.check),
            colorText: Colors.green);
        isBusy.value = false;
        Get.to(() => VerificationCode(
              email: email,
              isFirstVerify: false,
              password: "",
            ));
      } else {
        isBusy.value = false;
        Get.snackbar('Error', message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error),
            colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error),
          colorText: Colors.red);
    } finally {
      isBusy.value = false;
    }
  }

  // Update Password
  Future<void> updatePassword(
    String email,
    String newPassword,
  ) async {
    isBusy.value = true;
    try {
      final (status, message) = await authRepository.updatePassword(
        email: email,
        newPassword: newPassword,
      );

      if (status) {
        Get.snackbar("Success", message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.check),
            colorText: Colors.green);
        Get.offAll(() => const Login());
      } else {
        Get.snackbar('Error', message,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error),
            colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.error),
          colorText: Colors.red);
    } finally {
      isBusy.value = false;
    }
  }

  // Logout function
  Future<void> logoutUser() async {
    _user.value = null;
    Get.snackbar('Success', 'Successfully logged out',
        icon: const Icon(Icons.logout), colorText: Colors.green);
    Get.offAllNamed('/login');
  }
}
