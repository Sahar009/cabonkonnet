import 'dart:developer';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/repository/file_upload_repository.dart';
import 'package:cabonconnet/repository/product_repository.dart';
import 'package:cabonconnet/views/home/home.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  var isBusy = false.obs;
  final ProductRepository productRepository =
      ProductRepository(databases: Databases(AppwriteConfig().client));
  final FileUploadRepository fileRepository = FileUploadRepository(
      bucketId: AppwriteConfig.postBukectId,
      storage: Storage(AppwriteConfig().client));
  final RxList<ProductModel> posts = <ProductModel>[].obs;
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
        await productRepository.getAllProducts();
    if (isSuccess) {
      if (fetchedPosts != null) {
        fetchedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        posts.assignAll(fetchedPosts);
      }
    } else {
      // Handle error (e.g., show a message)
   //   Get.snackbar('Error', message ?? 'An unknown error occurred');
    }
  }

  // Create a new post
  Future<void> createPostProduct({
    required String fundingType,
    required String productsName,
    required String productsDescription,
    required String productsLevel,
    required String productsGoal,
    required String productsImpact,
    required double fundNeeded,
    required List<String> hashtags,
    required List<XFile?> files,
  }) async {
    isBusy.value = true;
    List<String> imageUrls = [];

    for (var file in files) {
      try {
        var fileUrl =
            await fileRepository.uploadFile(File(file!.path), "Products");
        if (fileUrl != null) {
          imageUrls.add(fileUrl);
        }
      } catch (e) {
        Get.snackbar('Upload Error', 'Failed to upload image: ${file!.name}');
      }
    }

    String? userId = await AppLocalStorage.getCurrentUserId();

    ProductModel productModel = ProductModel(
      hashtags: hashtags,
      id: ID.unique(),
      name: productsName,
      description: productsDescription,
      level: productsLevel,
      goals: productsGoal,
      fundsNeeded: fundNeeded,
      impact: productsGoal,
      fundingType: fundingType,
      imageUrls: imageUrls,
      fundsGets: 0.0,
      createdAt: DateTime.now(),
    );

    final (isSuccess, message) =
        await productRepository.createProductProduct(productModel, userId!);
    isBusy.value = false;

    if (isSuccess) {
      // posts.add(post);
      //Get.snackbar('Success', 'Post created successfully');
      CustomSnackbar.success(
          title: "Product post successful",
          message:
              "The admin has been notified of your post and it will be seen once approved");
      Get.to(() => Home());
    } else {
      isBusy.value = false;

      CustomSnackbar.error(
          title: 'Error', message: message ?? 'Failed to create post');
    }
  }

  // Update an existing post
  Future<void> updatePost(ProductModel post) async {
    final isSuccess = await productRepository.updateProduct(post);
    if (isSuccess) {
      final index = posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        posts[index] = post; // Update the existing post in the list
        Get.snackbar('Success', 'Post updated successfully');
        Get.back();
      }
    } else {
      CustomSnackbar.error(title: 'Error', message: 'Failed to update post');
    }
  }

  Future<void> getPost(String postId) async {
    final (isSuccess, post, message) =
        await productRepository.getProduct(postId);
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
    final isSuccess = await productRepository.deleteProduct(postId);
    if (isSuccess) {
      posts.removeWhere((post) => post.id == postId);
      Get.snackbar('Success', 'Post deleted successfully');
    } else {
      CustomSnackbar.error(title: 'Error', message: 'Failed to delete post');
    }
  }

  // Toggle like status

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
                description: updatedPostData["description"],
                hashtags: updatedPostData['hashtags'],

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
