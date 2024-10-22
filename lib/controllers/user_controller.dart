import 'dart:io';

import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/user_repository.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository userRepository = UserRepository(
    database: AppwriteConfig().databases,
    userCollectionId: AppwriteConfig.userCollectionId,
    databaseId: AppwriteConfig.databaseId,
  );

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
      if (validId != null && bankstat != null) {}
      var user = userModel.copyWith(
          address: address,
          companyName: companyName,
          website: website,
          businessRegNumber: busRegNum);
      await userRepository.updateUserDetails(user);
    } catch (e) {}
  }
}
