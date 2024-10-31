import 'dart:developer';
import 'dart:io';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/repository/user_repository.dart';
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
        // Successfully updated user details
        Get.snackbar(
          'Success',
          'User details updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => Home());
      } else {
        // Handle failure to update user details
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isBusy.value = false;
    }
  }
}
