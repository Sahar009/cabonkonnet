import 'dart:developer';
import 'dart:io';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/repository/user_repository.dart';
import 'package:cabonconnet/views/auth/interest_section.dart';
import 'package:cabonconnet/views/home/home.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var isBusy = false.obs;
  final UserRepository userRepository = UserRepository(
    database: AppwriteConfig().databases,
    userCollectionId: AppwriteConfig.userCollectionId,
    databaseId: AppwriteConfig.databaseId,
  );
  FileUploadRepository fileUploadRepository = FileUploadRepository(
    bucketId: AppwriteConfig.userFileBukectId,
    storage: AppwriteConfig().storage,
  );
  ProfileController profileController = Get.put(ProfileController());

  Future updateUser({
    required UserModel userModel,
    required String address,
    required String country,
    required String companyName,
    String? busRegNum,
    String? website,
    File? bankStat,
    File? validId,
    String? teamNumber,
  }) async {
    try {
      isBusy.value = true;
      String? validUrl;
      String? bankUrl;

      // Upload files if they are provided
      if (validId != null) {
        validUrl = await fileUploadRepository.uploadFile(
          validId,
          "${userModel.fullName} Valid ID",
        );
      }

      if (bankStat != null) {
        bankUrl = await fileUploadRepository.uploadFile(
          bankStat,
          "${userModel.fullName} Bank Statement",
        );
      }

      // Create a copy of the user model with updated fields
      var user = userModel.copyWith(
          address: address,
          companyName: companyName,
          website: website,
          businessRegNumber: busRegNum,
          country: country,
          idCardUrl: validUrl,
          bankStatementUrl: bankUrl,
          teamNumber: teamNumber);

      // Update user details
      final (isSuccess, updatedUserModel, message) =
          await userRepository.updateUserDetails(user);

      if (isSuccess) {
        // SCustomSnackbaruccessfully updated user details
        CustomSnackbar.success(message: 'User details updated successfully!');
        profileController.getUserDetails();
        if (updatedUserModel?.interests != null &&
            updatedUserModel!.interests!.isNotEmpty) {
          Get.offAll(() => Home());
        } else {
          Get.offAll(() => const InterestSection());
        }
      } else {
        // Handle failure to update user details
        CustomSnackbar.success(message: message, title: 'Error');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isBusy.value = false;
    }
  }

  Future updateUserAndBussines({
    required UserModel userModel,
    File? bussnessLogo,
    File? profilePic,
  }) async {
    try {
      isBusy.value = true;
      String? bussnessLogoUrl;
      String? profilePicUrl;

      // Upload files if they are provided
      if (bussnessLogo != null) {
        if (userModel.businessLogoUrl != null) {
          String? fileId =
              AppwriteConfig.getFileIdFromUrl(userModel.businessLogoUrl!);
          if (fileId != null) {
            await fileUploadRepository.delectFile(fileId);
          }
        }
        bussnessLogoUrl = await fileUploadRepository.uploadFile(
          bussnessLogo,
          "${userModel.companyName} Logo ",
        );
      }

      if (profilePic != null) {
        if (userModel.profileImage != null) {
          String? fileId =
              AppwriteConfig.getFileIdFromUrl(userModel.profileImage!);
          if (fileId != null) {
            await fileUploadRepository.delectFile(fileId);
          }
        }
        profilePicUrl = await fileUploadRepository.uploadFile(
          profilePic,
          "${userModel.fullName} Profile Pic",
        );
      }

      // Create a copy of the user model with updated fields
      var user = userModel.copyWith(
        businessLogoUrl: bussnessLogoUrl,
        profileImage: profilePicUrl,
      );

      // Update user details
      final (isSuccess, updatedUserModel, message) =
          await userRepository.updateUserDetails(user);

      if (isSuccess) {
        // Successfully updated user details

        CustomSnackbar.success(message: 'User details updated successfully!');
        profileController.getUserDetails();
        if (updatedUserModel?.interests != null &&
            updatedUserModel!.interests!.isNotEmpty) {
          Get.offAll(() => Home());
        } else {
          Get.offAll(() => const InterestSection());
        }
      } else {
        // Handle failure to update user details

        CustomSnackbar.error(message: message, title: 'Error');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isBusy.value = false;
    }
  }
}
