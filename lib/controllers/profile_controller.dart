import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/repository/user_repository.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  UserModel? _userModel;
  final Rx<UserModel?> userModelRx = Rx<UserModel?>(null);
  final Rx<UserModel?> currentUserModelRx = Rx<UserModel?>(null);
  final Rx<RealtimeSubscription?> _subscription =
      Rx<RealtimeSubscription?>(null);

  UserRepository userRepository = UserRepository(
    database: Databases(AppwriteConfig().client),
    databaseId: AppwriteConfig.databaseId,
    userCollectionId: AppwriteConfig.userCollectionId,
  );

  final FileUploadRepository fileRepository = FileUploadRepository(
      bucketId: AppwriteConfig.postBukectId,
      storage: Storage(AppwriteConfig().client));

  final Realtime realtime = Realtime(AppwriteConfig().client);
  var userId = ''.obs;
  reload() {
    if (currentUserModelRx.value == null) {
      getCurrentUserDetails();
      log("reloading user details");
    }
  }

  updateUserId(String user) {
    userId.value = user;
    getUserDetails(user);
  }

  @override
  void onInit() {
    super.onInit();
    getUserDetails(null);
    getRealTimeUpdate();
  }

  logout() {
    userModelRx.value = null;
    currentUserModelRx.value = null;
  }

  Future<UserModel?> getUserDetails(String? userId) async {
    final (isSuccess, userModel) =
        await userRepository.getUserDetails(this.userId.value);
    if (isSuccess) {
      _userModel = userModel;
      userModelRx.value = _userModel;
    }

    return userModelRx.value;
  }

  Future<UserModel?> getCurrentUserDetails() async {
    String? userId = await AppLocalStorage.getCurrentUserId();

    if (userId != null) {
      final (isSuccess, userModel) =
          await userRepository.getUserDetails(userId);
      if (isSuccess) {
        _userModel = userModel;
        currentUserModelRx.value = _userModel;
      }
    }
    return currentUserModelRx.value;
  }

  Future<void> updateUserDetails(File file) async {
    String? userId = await AppLocalStorage.getCurrentUserId();
    String? coverUrl;
    if (userId != null) {
  

      if (_userModel?.coverImage != null) {
        String? fileId = AppwriteConfig.getFileIdFromUrl(
            currentUserModelRx.value!.coverImage!);

        if (fileId != null) {
          await fileRepository.delectFile(fileId);
        }
      }

      coverUrl = await fileRepository.uploadFile(
        file,
        "${currentUserModelRx.value?.fullName} Cover Image",
      );

      final (success, updatedUserModel, message) =
          await userRepository.updateCoverImage(coverUrl!);

      if (success) {
        // Successfully updated user details
        CustomSnackbar.success(message: 'User details updated successfully!');
      }
    }
  }

  void getRealTimeUpdate() async {
    String? userId = await AppLocalStorage.getCurrentUserId();

    if (userId != null) {
      // Subscribe to real-time updates
      _subscription.value = realtime.subscribe(
        [
          'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.userCollectionId}.documents.$userId'
        ],
      );

      _subscription.value!.stream.listen((event) async {
        // Fetch the updated user data
        await getUserDetails(event.payload['\$id']);
      });
    }
  }

  @override
  void onClose() {
    _subscription.value?.close();
    super.onClose();
  }
}
