import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/models/team_member_model.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/repository/team_repository.dart';
import 'package:get/get.dart';

class TeamController extends GetxController {
  var isBusy = false.obs;
  FileUploadRepository fileUploadRepository = FileUploadRepository(
    bucketId: AppwriteConfig.userFileBukectId,
    storage: AppwriteConfig().storage,
  );
  TeamRepository teamRepository =
      TeamRepository(databases: Databases(AppwriteConfig().client));
  final RxList<TeamMemberModel> teams = <TeamMemberModel>[].obs;
  RxString foundId = ''.obs;
  @override
  void onInit() {
    super.onInit();

    foundId.listen((ever) {
      if (ever.isNotEmpty) {
        log("Hlleo");
        fetchAllPosts();
      }
    });
    // setupRealtimePosts();
  }

  updateId(String founderId) {
    foundId.value = founderId;
  }

  Future<void> fetchAllPosts() async {
    final (isSuccess, fetchedPosts, message) =
        await teamRepository.getTeam(foundId.value);
    if (isSuccess) {
      if (fetchedPosts != null) {

        teams.assignAll(fetchedPosts);
      }
    } else {
      // Handle error (e.g., show a message)
      Get.snackbar('Error', message ?? 'An unknown error occurred');
    }
  }

  Future<void> createTeam(
      {required String teamName,
      required String teamEmail,
      required String teamPosition,
      required String teamLocation,
      required File? profilePic}) async {
    isBusy.value = true;
    String? imageUrl;

    if (profilePic != null) {
      try {
        var fileUrl = await fileUploadRepository.uploadFile(
            File(profilePic.path), "Post");
        if (fileUrl != null) {
          imageUrl = fileUrl;
        }
      } catch (e) {
        Get.snackbar('Upload Error', 'Failed to upload image: ');
      }
    }

    String? userId = await AppLocalStorage.getCurrentUserId();

    TeamMemberModel teamMemberModel = TeamMemberModel(
        fullName: teamName,
        email: teamEmail,
        id: ID.unique(),
        position: teamPosition,
        location: teamLocation,
        founderId: userId!,
        profilePic: imageUrl ?? '');
    teams.add(teamMemberModel);
    final (isSuccess, message) = await teamRepository.createTeam(
        teamMemberModel, teams.map((e) => e.id).toList());
    isBusy.value = false;

    if (isSuccess) {
      // teams.add(post);
      Get.back();
     //// CustomDialog.success(message: 'Post created successfully');
    } else {
      isBusy.value = false;
      // CustomDialog.error(
      //     title: 'Error', message: message ?? 'Failed to create post');
    }
  }
}
