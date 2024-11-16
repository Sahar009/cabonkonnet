import 'dart:developer';

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
  late Realtime realtime;
  // Set busy state utility
  Future<void> _setBusyState(Future<void> Function() action) async {
    try {
      isBusy.value = true;
      await action();
    } finally {
      isBusy.value = false;
    }
  }

  // Fetch all comments for a specific post
  Future<void> fetchComments(String postId) async {
    await _setBusyState(() async {
      final (isSuccess, fetchedComments, message) =
          await commentRepository.getCommentsByPostId(postId);

      if (isSuccess) {
        comments.assignAll(fetchedComments ?? []);
      } else {
        Get.snackbar('Error', message ?? 'Failed to fetch comments');
      }
    });
  }

  // Add a new comment to a post
  Future<void> addComment({
    required String postId,
    required String content,
  }) async {
    await _setBusyState(() async {
      try {
        String? userId = await AppLocalStorage.getCurrentUserId();
        if (userId == null) throw 'User not logged in';

        CommentModel comment = CommentModel(
          id: ID.unique(),
          postId: postId,
          userId: userId,
          content: content,
          userFullName: profileController.userModelRx.value?.fullName,
          userProfileImage: profileController.userModelRx.value?.profileImage,
          createdAt: DateTime.now(),
        );

        // Optimistically add comment locally
        comments.add(comment);

        final (isSuccess, message) =
            await commentRepository.createComment(comment);
        if (!isSuccess) {
          comments.remove(comment); // Rollback in case of failure
          // Get.snackbar('Error', message ?? 'Failed to add comment');
        }
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    });
  }

  Future<void> likeComment(String commentId, String userId) async {
    // Find the current comment
    final index = comments.indexWhere((comment) => comment.id == commentId);
    if (index == -1) return; // Comment not found

    // Update the like count in the local state for immediate UI feedback
    final currentLikes = comments[index].likes ?? [];

    if (currentLikes.contains(userId)) {
      currentLikes.remove(userId);
    } else {
      currentLikes.add(userId);
    }
    comments[index] = comments[index].copyWith(likes: currentLikes);
    comments.refresh();

    // Send the updated like count to Appwrite
    await commentRepository.updateCommentLikes(commentId, currentLikes);
  }

  // Update an existing comment
  Future<void> updateComment(String commentId, String updatedContent) async {
    await _setBusyState(() async {
      final (isSuccess, message) =
          await commentRepository.updateComment(commentId, updatedContent);

      if (isSuccess) {
        final index = comments.indexWhere((comment) => comment.id == commentId);
        if (index != -1) {
          comments[index] = comments[index].copyWith(content: updatedContent);
          comments.refresh(); // Refresh the observable list
        }
        Get.snackbar('Success', 'Comment updated successfully');
      } else {
        Get.snackbar('Error', message ?? 'Failed to update comment');
      }
    });
  }

  // Delete a comment
  Future<void> deleteComment(String commentId) async {
    await _setBusyState(() async {
      final (isSuccess, message) =
          await commentRepository.deleteComment(commentId);

      if (isSuccess) {
        comments.removeWhere((comment) => comment.id == commentId);
        Get.snackbar('Success', 'Comment deleted successfully');
      } else {
        Get.snackbar('Error', message ?? 'Failed to delete comment');
      }
    });
  }

  void setupRealtimeComments(String postId) {
    realtime = Realtime(AppwriteConfig().client);

    // Subscribe to comment document changes in the specific post's comments collection
    realtime
        .subscribe([
          'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.postCommentCollectionId}.documents'
        ])
        .stream
        .listen((RealtimeMessage event) {
          try {
            log('Comment event received: ${event.events.toString()}');

            // Handle new comment creation
            if (event.events
                .contains('databases.*.collections.*.documents.*.create')) {
              final newCommentData = event.payload;

              // Ensure the comment is for the specified post
              if (newCommentData['postId'] == postId) {
                log('New comment created for post $postId. Adding to list.');

                CommentModel newComment = CommentModel.fromMap(newCommentData);
                comments.add(newComment); // Add new comment to the list
                comments.refresh(); // Refresh UI
              }
            }

            // Handle comment updates
            else if (event.events
                .contains('databases.*.collections.*.documents.*.update')) {
              final updatedCommentData = event.payload;
              final commentId = updatedCommentData['\$id'];

              // Ensure the comment is for the specified post
              if (updatedCommentData['postId'] == postId) {
                log('Updating comment with ID: $commentId for post $postId.');

                // Find and update the specific comment in the list
                final index = comments.indexWhere((c) => c.id == commentId);
                if (index != -1) {
                  comments[index] = comments[index].copyWith(
                    content: updatedCommentData['content'],
                    // Add additional fields here if needed
                  );
                  comments.refresh(); // Refresh UI
                } else {
                  log('Comment with ID: $commentId not found.');
                }
              }
            }

            // Handle comment deletion
            else if (event.events
                .contains('databases.*.collections.*.documents.*.delete')) {
              final commentId = event.payload['\$id'];

              log('Deleting comment with ID: $commentId for post $postId.');
              comments.removeWhere((comment) =>
                  comment.id == commentId); // Remove the comment from the list
              comments.refresh(); // Refresh UI
            }
          } catch (e) {
            log('Error processing realtime comment event: $e');
          }
        });
  }
}
