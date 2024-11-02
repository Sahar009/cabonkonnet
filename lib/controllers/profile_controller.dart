import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/user_repository.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  UserModel? _userModel;
  final Rx<UserModel?> userModelRx = Rx<UserModel?>(null);
  final Rx<RealtimeSubscription?> _subscription =
      Rx<RealtimeSubscription?>(null);

  UserRepository userRepository = UserRepository(
    database: Databases(AppwriteConfig().client),
    databaseId: AppwriteConfig.databaseId,
    userCollectionId: AppwriteConfig.userCollectionId,
  );

  final Realtime realtime = Realtime(AppwriteConfig().client);

reload(){
  if(_userModel == null || userModelRx.value == null){
    getUserDetails();
  }
}


  @override
  void onInit() {
    super.onInit();
    getUserDetails();
     getRealTimeUpdate();
  }

  logout() {
    userModelRx.value = null;
  }

  Future<void> getUserDetails() async {
    String? userId = await AppLocalStorage.getCurrentUserId();
    log(userId.toString());
    if (userId != null) {
      final (isSuccess, userModel) =
          await userRepository.getUserDetails(userId);
      if (isSuccess) {
        _userModel = userModel;
        userModelRx.value = _userModel;
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
        await getUserDetails();
      });
    }
  }

  @override
  void onClose() {
    _subscription.value?.close();
    super.onClose();
  }
}
