import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/models/post_model.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/product_model.dart';

class ProductRepository {
  final Databases databases;

  ProductRepository({required this.databases});

  // Create a new post
  Future<(bool isSuccess, String? message)> createProductPost(
      ProductModel product, PostModel post, String userId) async {
    try {
      await databases.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId:
              AppwriteConfig.productCollectionId, // Your post collection ID
          documentId: product.id, // Unique ID for the document
          data: product.toMap());

      final Document document = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId:
            AppwriteConfig.postCollectionId, // Your post collection ID
        documentId: post.id, // Unique ID for the document
        data: {
          'content': post.content,
          'hashtags': post.hashtags,
          'imageUrls': post.imageUrls,
          "product": product.id,
          "fundingType": product.fundingType,
          'createdAt':
              post.createdAt.toIso8601String(), // Ensure date is in ISO format
          'user': userId, // Store only the user ID
          'commentCount': post.commentCount,
          'sharedBy': post.sharedBy,
          "isProduct": true
        },
      );
      return (true, document.$id); // Return true and the document ID
    } catch (e) {
      return (false, e.toString()); // Return false and the error message
    }
  }

  // Retrieve a post by ID
  Future<(bool isSuccess, PostModel? post, String? message)> getPost(
      String postId) async {
    try {
      final Document document = await databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCollectionId,
        documentId: postId,
      );
      return (true, PostModel.fromMap(document.data), null);
    } catch (e) {
      return (false, null, e.toString());
    }
  }

  // Update a post
  Future<bool> updatePost(PostModel post) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCollectionId,
        documentId: post.id,
        data: post.toMap(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleLikePost(String userId, String postId) async {
    try {
      // Step 1: Check if the like already exists for this user and post
      final result = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postLikeCollectionId,
        queries: [
          Query.equal("user", userId),
          Query.equal("post", postId),
        ],
      );

      if (result.documents.isNotEmpty) {
        // Step 2: If the like exists, remove it (unlike the post)
        await databases.deleteDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.postLikeCollectionId,
          documentId: result
              .documents.first.$id, // Use the ID of the found like document
        );
        return false; // Post was unliked
      } else {
        // Step 3: If no previous like exists, create a new like document
        await databases.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.postLikeCollectionId,
          documentId: ID.unique(),
          data: {"user": userId, "post": postId},
        );
        return true; // Post was liked
      }
    } catch (e) {
      return false; // Return false if there's an error
    }
  }

  // Delete a post
  Future<bool> deletePost(String postId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCollectionId,
        documentId: postId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Fetch all posts (optional)
  Future<(bool isSuccess, List<PostModel>? posts, String? message)>
      getAllPosts() async {
    try {
      final documents = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCollectionId,
      );

      var d = documents.documents.map((e) => e.data);
      log(d.toString());

      List<PostModel> postList = documents.documents
          .map((doc) => PostModel.fromMap(doc.data))
          .toList();

      return (true, postList, null);
    } catch (e) {
      return (false, null, e.toString());
    }
  }
}
