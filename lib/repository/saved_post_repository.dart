import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';

class SavedPostRepository {
  final Databases _databases;

  SavedPostRepository({required Databases databases}) : _databases = databases;

  Future<(bool isSuccess, String? message)> savePost(
      String postId, String? userId) async {
    try {
      // First, check if a document with the same postId and userId already exists
      final queryResult = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.savedPostCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.equal('postId', postId),
        ],
      );

      // If the document exists, return immediately with a message
      if (queryResult.documents.isNotEmpty) {
        return (false, 'Post already saved by this user.');
      }

      // If no such document exists, proceed to create the new document
      await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.savedPostCollectionId,
        documentId: ID.unique(),
        data: {'userId': userId, 'post': postId, "postId": postId},
      );

      return (true, 'Post saved successfully.');
    } catch (e) {
      // Handle any errors that may occur during the operation
      return (false, 'Error saving post: $e');
    }
  }

  // Method to retrieve saved posts by user
  Future<List<Document>> getUserSavedPosts(String userId) async {
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.savedPostCollectionId,
      queries: [Query.equal('userId', userId)],
    );
    return result.documents;
  }
}
