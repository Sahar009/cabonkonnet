import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/controllers/profile_controller.dart';
import 'package:cabonconnet/models/comment_model.dart';
import 'package:cabonconnet/repository/comment_repository.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final CommentRepository commentRepository =
      CommentRepository(databases: Databases(AppwriteConfig().client));
  ProfileController profileController = Get.put(ProfileController());

  var isBusy = false.obs;
  final RxList<CommentModel> comments = <CommentModel>[].obs;

  // Fetch all comments for a specific post
  Future<void> fetchComments(String postId) async {
    isBusy.value = true;

    final (isSuccess, fetchedComments, message) =
        await commentRepository.getCommentsByPostId(postId);
    isBusy.value = false;

    if (isSuccess) {
      if (fetchedComments != null) {
        comments.assignAll(fetchedComments);
      }
    } else {
      Get.snackbar('Error', message ?? 'Failed to fetch comments');
    }
  }

  // Add a new comment to a post
  Future<void> addComment({
    required String postId,
    required String content,
  }) async {
    isBusy.value = true;
    String? userId = await AppLocalStorage.getCurrentUserId();

    CommentModel comment = CommentModel(
      id: ID.unique(),
      postId: postId,
      userId: userId!,
      content: content,
      userFullName: profileController.userModelRx.value?.fullName,
      userProfileImage: profileController.userModelRx.value?.profileImage,
      createdAt: DateTime.now(),
    );

    comments.add(comment);

    await commentRepository.createComment(comment);
    isBusy.value = false;
  }

  // Update an existing comment
  Future<void> updateComment(String commentId, String updatedContent) async {
    isBusy.value = true;

    final (isSuccess, message) =
        await commentRepository.updateComment(commentId, updatedContent);
    isBusy.value = false;

    if (isSuccess) {
      final index = comments.indexWhere((comment) => comment.id == commentId);
      if (index != -1) {
        comments[index].copyWith(content: updatedContent);

        comments.refresh();
      }
     Get.snackbar('Success', 'Comment updated successfully');
    } else {
      Get.snackbar('Error', message ?? 'Failed to update comment');
    }
  }

  // Delete a comment
  Future<void> deleteComment(String commentId) async {
    isBusy.value = true;

    final (isSuccess, message) =
        await commentRepository.deleteComment(commentId);
    isBusy.value = false;

    if (isSuccess) {
      comments.removeWhere((comment) => comment.id == commentId);
      Get.snackbar('Success', 'Comment deleted successfully');
    } else {
      Get.snackbar('Error', message ?? 'Failed to delete comment');
    }
  }
}
