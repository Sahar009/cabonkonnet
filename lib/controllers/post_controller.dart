import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/repository/post_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  var isBusy = false.obs;
  final PostRepository postRepository =
      PostRepository(databases: Databases(AppwriteConfig().client));
  final FileUploadRepository fileRepository = FileUploadRepository(
      bucketId: AppwriteConfig.postBukectId,
      storage: Storage(AppwriteConfig().client));
  final RxList<PostModel> posts = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
  }

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    final (isSuccess, fetchedPosts, message) =
        await postRepository.getAllPosts();
    print(fetchedPosts?.length);
    if (isSuccess) {
      if (fetchedPosts != null) {
        posts.assignAll(fetchedPosts);
      }
    } else {
      // Handle error (e.g., show a message)
      Get.snackbar('Error', message ?? 'An unknown error occurred');
    }
  }

  // Create a new post
  Future<void> createPost({
    required String content,
    required List<String> hashtags,
    required List<XFile> files,
  }) async {
    isBusy.value = true;
    List<String> imageUrls = [];

    for (var file in files) {
      try {
        var fileUrl = await fileRepository.uploadFile(File(file.path), "Post");
        if (fileUrl != null) {
          imageUrls.add(fileUrl);
        }
      } catch (e) {
        Get.snackbar('Upload Error', 'Failed to upload image: ${file.name}');
      }
    }

    String? userId = await AppLocalStorage.getCurrentUserId();

    PostModel post = PostModel(
      content: content,
      hashtags: hashtags,
      id: ID.unique(),
      imageUrls: imageUrls,
      createdAt: DateTime.now(),
    );

    final (isSuccess, message) = await postRepository.createPost(post, userId!);
    isBusy.value = false;

    if (isSuccess) {
      posts.add(post);
      Get.snackbar('Success', 'Post created successfully');
    } else {
      isBusy.value = false;

      Get.snackbar('Error', message ?? 'Failed to create post');
    }
  }

  // Update an existing post
  Future<void> updatePost(PostModel post) async {
    final isSuccess = await postRepository.updatePost(post);
    if (isSuccess) {
      final index = posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        posts[index] = post; // Update the existing post in the list
        Get.snackbar('Success', 'Post updated successfully');
      }
    } else {
      Get.snackbar('Error', 'Failed to update post');
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    final isSuccess = await postRepository.deletePost(postId);
    if (isSuccess) {
      posts.removeWhere((post) => post.id == postId);
      Get.snackbar('Success', 'Post deleted successfully');
    } else {
      Get.snackbar('Error', 'Failed to delete post');
    }
  }



    // Toggle like status
  Future<void> toggleLike(String postId) async {
    // Get the current user ID (Assuming you have a local storage function for this)
    String? userId = await AppLocalStorage.getCurrentUserId();
    if (userId == null) {
    //  Get.snackbar('Error', 'User is not logged in');
      return;
    }

    // Call the toggleLikePost function from your repository
    final isLiked = await postRepository.toggleLikePost(userId, postId);

    // Find the post in the local list and update it
    final index = posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      PostModel post = posts[index];

      // Update the likes count and local UI
      if (isLiked) {
        post.likes?.add(userId); // Add the user's ID to likes
       // Get.snackbar('Liked', 'You liked the post');
      } else {
        post.likes?.remove(userId); // Remove the user's ID from likes
       // Get.snackbar('Unliked', 'You unliked the post');
      }

      // Update the posts list to refresh the UI
      posts[index] = post;
    }
  }
}
