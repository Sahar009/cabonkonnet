import 'dart:io';

import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/repository/user_repository.dart';
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
      storage: AppwriteConfig().storage);
  Future updateUser({
    required UserModel userModel,
    required String address,
    required String contry,
    required String companyName,
    String? busRegNum,
    String? website,
    File? bankstat,
    File? validId,
  }) async {
    try {
      isBusy.value = true;
      if (validId != null && bankstat != null) {
        String? validUrl = await fileUploadRepository.uploadFile(
            validId, "${userModel.fullName} Valid Id");
        String? bankUrl = await fileUploadRepository.uploadFile(
            bankstat, "${userModel.fullName} Bank Statement ");

        var user = userModel.copyWith(
            address: address,
            companyName: companyName,
            website: website,
            businessRegNumber: busRegNum,
            country: contry,
            idCardUrl: validUrl,
            bankStatementUrl: bankUrl);
        await userRepository.updateUserDetails(user);
      } else {
        var user = userModel.copyWith(
            address: address,
            companyName: companyName,
            website: website,
            businessRegNumber: busRegNum,
            country: contry);
        await userRepository.updateUserDetails(user);
      }
    } catch (e) {
    } finally {
      isBusy.value = false;
    }
  }
}
