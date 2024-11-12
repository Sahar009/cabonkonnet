import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/helpers/custom_dialog.dart';
import 'package:cabonconnet/repository/saved_post_repository.dart';
import 'package:get/get.dart';

class SavedPostController extends GetxController {
  final SavedPostRepository savedPostRepository =
      SavedPostRepository(databases: Databases(AppwriteConfig().client));
  final RxList<dynamic> savedPostsList = <dynamic>[].obs;
  var isBusy = false.obs;

  // Method to save a post with duplicate check
  Future<void> savePost(String postId) async {
    // Retrieve the current user ID
    String? userId = await AppLocalStorage.getCurrentUserId();

    // Check if the user ID is null
    if (userId == null) {
      CustomDialog.error(
        title: 'Error',
        message: 'User not found. Please log in.',
      );
      return;
    }

    // Attempt to save the post and check if it already exists
    final (isSuccess, message) =
        await savedPostRepository.savePost(postId, userId);

    if (isSuccess) {
      // Show success dialog if the post was saved successfully
      CustomDialog.success(
        message: 'Post saved successfully.',
      );
    } else {
      // Show error dialog if there was an error or post already exists
      CustomDialog.error(
        title: 'Error',
        message: message ?? 'Failed to save the post.',
      );
    }
  }

  // Method to fetch saved posts for the user
  Future<void> getUserSavedPosts(String? userId) async {
    if (userId == null) {
      CustomDialog.error(
          title: 'Error', message: 'User not found. Please log in.');
      return;
    }

    try {
      isBusy.value = true;
      final savedPosts = await savedPostRepository.getUserSavedPosts(userId);
      savedPostsList.assignAll(savedPosts.map((doc) => doc.data).toList());
      CustomDialog.success(message: 'Saved posts retrieved successfully.');
    } catch (e) {
      CustomDialog.error(
          title: 'Error',
          message: 'Failed to retrieve saved posts: ${e.toString()}');
    } finally {
      isBusy.value = false;
    }
  }
}
