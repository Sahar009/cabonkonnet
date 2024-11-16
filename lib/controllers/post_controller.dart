import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/repository/post_repository.dart';
import 'package:cabonconnet/repository/product_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  var isBusy = false.obs;
  final PostRepository postRepository =
      PostRepository(databases: Databases(AppwriteConfig().client));
  final ProductRepository productRepository =
      ProductRepository(databases: Databases(AppwriteConfig().client));
  final FileUploadRepository fileRepository = FileUploadRepository(
      bucketId: AppwriteConfig.postBukectId,
      storage: Storage(AppwriteConfig().client));
  final RxList<PostModel> posts = <PostModel>[].obs;
  // Add a Realtime instance
  late Realtime realtime;
  @override
  void onInit() {
    super.onInit();
    setupRealtimePosts();
    fetchAllPosts();
  }

  // Fetch all posts
  Future<void> fetchAllPosts() async {
    final (isSuccess, fetchedPosts, message) =
        await postRepository.getAllPosts();
    if (isSuccess) {
      if (fetchedPosts != null) {
        fetchedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        posts.assignAll(fetchedPosts);
      }
    } else {
      // Handle error (e.g., show a message)
      Get.snackbar('Error', message ?? 'An unknown error occurred');
    }
  }

  // Create a new post
  Future<void> createPostProduct({
    required String productsName,
    required String productsDescription,
    required String productsLevel,
    required String productsGoal,
    required String productsImpact,
    required double fundNeeded,
    required List<String> hashtags,
    required List<XFile> files,
  }) async {
    isBusy.value = true;
    List<String> imageUrls = [];

    for (var file in files) {
      try {
        var fileUrl =
            await fileRepository.uploadFile(File(file.path), "Products");
        if (fileUrl != null) {
          imageUrls.add(fileUrl);
        }
      } catch (e) {
        Get.snackbar('Upload Error', 'Failed to upload image: ${file.name}');
      }
    }

    String? userId = await AppLocalStorage.getCurrentUserId();

    ProductModel productModel = ProductModel(
        id: ID.unique(),
        name: productsName,
        description: productsDescription,
        level: productsLevel,
        goals: productsGoal,
        fundsNeeded: fundNeeded,
        impact: productsGoal);

    PostModel post = PostModel(
      content: productsDescription,
      hashtags: hashtags,
      id: ID.unique(),
      imageUrls: imageUrls,
      createdAt: DateTime.now(),
    );

    final (isSuccess, message) =
        await productRepository.createProductPost(productModel, post, userId!);
    isBusy.value = false;

    if (isSuccess) {
      posts.add(post);
      Get.snackbar('Success', 'Post created successfully');
    } else {
      isBusy.value = false;

      Get.snackbar('Error', message ?? 'Failed to create post');
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
      Get.back();
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
        Get.back();
      }
    } else {
      Get.snackbar('Error', 'Failed to update post');
    }
  }

  Future<void> getPost(String postId) async {
    final (isSuccess, post) = await postRepository.getSinglePost(postId);
    if (isSuccess && post != null) {
      final index = posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        posts[index] = post; // Update the existing post in the list
      }
    } else {
      getPost(postId);
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
  Future<bool> toggleLike(String postId) async {
    // Get the current user ID (Assuming you have a local storage function for this)
    String? userId = await AppLocalStorage.getCurrentUserId();
    log("Liking");
    if (userId == null) {
      //  Get.snackbar('Error', 'User is not logged in');
      return false;
    }

    final index = posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      PostModel post = posts[index];

      // Update the likes count and local UI
      if (!post.likes!.contains(userId)) {
        post.likes?.add(userId); // Add the user's ID to likes
        log("Liked");

        posts[index] = post;
        postRepository.toggleLikePost(userId, post);
        return true;
      } else {
        log("disLiked");

        post.likes?.remove(userId); // Remove the user's ID from likes
        // Get.snackbar('Unliked', 'You unliked the post');
        posts[index] = post;
        postRepository.toggleLikePost(userId, post);
        return false;
      }
    }
    return false;
  }

  void setupRealtimePosts() {
    realtime = Realtime(AppwriteConfig().client);

    realtime
        .subscribe([
          'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.postCollectionId}.documents'
        ])
        .stream
        .listen((RealtimeMessage event) {
          log(event.events.toString());
          if (event.events
              .contains('databases.*.collections.*.documents.*.create')) {
            fetchAllPosts(); // Refetch all posts when a new post is created
          } else if (event.events
              .contains('databases.*.collections.*.documents.*.update')) {
            log(event.payload.toString());

            final updatedPostData = event.payload;
            final postId = updatedPostData['\$id'];

            // Find the existing post
            final index = posts.indexWhere((p) => p.id == postId);
            if (index != -1) {
              log("${event.payload["\$id"]}Is Found");

              // Update only specific fields using copyWith
              posts[index] = posts[index].copyWith(
                  commentCount: updatedPostData["commentCount"],
                  content: updatedPostData["content"],
                  hashtags: updatedPostData['hashtags'],
                  likes: updatedPostData["likes"]

                  // Add any additional fields that should be updated here
                  );
            }
            log(" $postId Is geting");

            getPost(postId);
          } else if (event.events
              .contains('databases.*.collections.*.documents.*.delete')) {
            final postId = event.payload['\$id'];
            posts.removeWhere(
                (post) => post.id == postId); // Remove deleted post
          }
        });
  }

  @override
  void onClose() {
    // Clean up real-time subscriptions when the controller is disposed

    super.onClose();
  }
}
