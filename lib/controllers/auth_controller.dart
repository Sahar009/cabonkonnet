import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/nav_bar_contoller.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/custom_dialog.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/auth_repository.dart';
import 'package:cabonconnet/views/auth/create_new_password.dart';
import 'package:cabonconnet/views/auth/interest_section.dart';
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
  ProfileController profileController = Get.put(ProfileController());
  var otpStatus = "".obs;
  final _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;
//  var userRole;
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
        CustomDialog.error(title: 'Error', message: message);
      }
    } catch (e) {
      CustomDialog.error(
        title: 'Error',
        message: 'An error occurred: ${e.toString()}',
      );
    } finally {
      isBusy.value = false;
    }
  }

  Future resendOtp() async {}

  // Login the user and navigate to Profile Update if navigateToProfile is true
  Future<void> loginUser(
    String email,
    String password,
  ) async {
    isBusy.value = true;
    try {
      final (status, userModel, message) =
          await authRepository.loginUser(email, password);

      if (status) {
        // Navigate to Profile Update page after zsuccessful login
        authRepository.account.get().then((value) async {
          if (value.emailVerification) {
            if (userModel != null &&
                (userModel.companyName == null || userModel.country == null)) {
              Get.to(() => UpdateUserDetails(
                  userModel: userModel, role: userModel.role));
            } else if (userModel != null &&
                (userModel.interests == null || userModel.interests!.isEmpty)) {
              Get.to(() => const InterestSection());
            } else {
              Get.offAll(() => Home());
            }
          } else {
            sendOtp(value.email, true);
            Get.to(
              () => VerificationCode(
                email: value.email,
                isFirstVerify: true,
                password: password,
              ),
            );
          }
        });
      } else {
        CustomDialog.error(title: 'Error', message: message);
      }
    } catch (e) {
      CustomDialog.error(
        title: 'Error',
        message: 'Login failed: ${e.toString()}',
      );
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
        CustomDialog.success(title: "OTP Sent", message: message);
      } else {
        isBusy.value = false; // Set to false before redirect

        CustomDialog.error(title: 'Error', message: message);
      }
      isBusy.value = false; // Set to false before redirect
    } catch (e) {
      CustomDialog.error(
          title: 'Error', message: 'Failed to send OTP: ${e.toString()}');
    } finally {
      isBusy.value = false;
    }
  }

  // Verify OTP and then call loginUser
  Future<void> verifyOtp(String email, String otp, String password) async {
    isBusy.value = true;
    if (otp.length != 4) {
      CustomDialog.error(title: 'Error', message: "Input Valid OTP");
      isBusy.value = false;
      return;
    }

    try {
      final (status, isRecover, message) =
          await authRepository.verifyOtp(email: email, otp: otp);
      otpStatus.value = message;
      if (status) {
        CustomDialog.success(title: "OTP Verified", message: message);

        if (isRecover == true) {
          Get.off(() => CreateNewPassword(
                email: email,
              ));

          return;
        }

        if (password.isNotEmpty) {
          final (statu, userModel, message) =
              await authRepository.loginUser(email, password);

          if (statu) {
            Get.off(() => UpdateUserDetails(
                  role: _user.value?.role ?? userModel!.role,
                  userModel: _user.value ?? userModel!,
                ));
            return;
          }
        } else {
          CustomDialog.error(
              title: 'Error',
              message: "Password not found, please retry login.");

          Get.to(() => const Login());
          return;
        }
      } else {
        CustomDialog.error(title: 'Error', message: message);
        return;
      }
    } catch (e) {
      CustomDialog.error(
        title: 'Error',
        message: 'OTP verification failed: ${e.toString()}',
      );
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
        CustomDialog.success(title: "OTP Sent", message: message);

        isBusy.value = false;
        Get.to(() => VerificationCode(
              email: email,
              isFirstVerify: false,
              password: "",
            ));
      } else {
        isBusy.value = false;
        CustomDialog.error(title: 'Error', message: message);
      }
    } catch (e) {
      CustomDialog.error(
        title: 'Error',
        message: 'Failed to send OTP: ${e.toString()}',
      );
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
        CustomDialog.success(message: message);

        Get.offAll(() => const Login());
      } else {
        CustomDialog.error(title: 'Error', message: message);
      }
    } catch (e) {
      CustomDialog.error(
        title: 'Error',
        message: 'Failed to update password: ${e.toString()}',
      );
    } finally {
      isBusy.value = false;
    }
  }

  // Logout function
  Future<void> logoutUser() async {
    _user.value = null;

    await AppLocalStorage.logout();
    await authRepository.account.deleteSessions();
    Get.put(NavBarContoller()).currentIndex(0);
    Get.put(ProfileController()).logout();
    CustomDialog.success(message: 'Successfully logged out');
    Get.offAll(() => const Login());
  }
}
