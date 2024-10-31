import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/comment_model.dart';

class CommentRepository {
  final Databases databases;

  CommentRepository({required this.databases});

  // Create a new comment
  Future<(bool isSuccess, String? message)> createComment(
      CommentModel comment) async {
    try {
      await databases.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.postCommentCollectionId,
          documentId: comment.id,
          data: {
            "content": comment.content,
            "postId": comment.postId,
            "user": comment.userId
          });

      // Fetch the current comment count
      final postDocument = await databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCollectionId,
        documentId: comment.postId,
      );

      int currentCommentCount = postDocument.data['commentCount'] ?? 0;
      // Increment the comment count locally
      currentCommentCount += 1;
      // Update the post document with the new comment count
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCollectionId,
        documentId: comment.postId,
        data: {
          'commentCount': currentCommentCount,
        },
      );
      return (true, 'Comment created successfully');
    } catch (e) {
      return (false, e.toString());
    }
  }

  // Fetch all comments for a specific post
  Future<(bool isSuccess, List<CommentModel>? comments, String? message)>
      getCommentsByPostId(String postId) async {
    try {
      final models.DocumentList documents = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCommentCollectionId,
        queries: [Query.equal('postId', postId)],
      );
      var d = documents.documents.map((e) => e.data);
      log(d.toString());

      List<CommentModel> comments = documents.documents
          .map((doc) => CommentModel.fromMap(doc.data))
          .toList();

      return (true, comments, 'Comments fetched successfully');
    } catch (e) {
      return (false, null, e.toString());
    }
  }

  // Update a comment by ID
  Future<(bool isSuccess, String? message)> updateComment(
      String commentId, String content) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCommentCollectionId,
        documentId: commentId,
        data: {
          'content': content,
        },
      );
      return (true, 'Comment updated successfully');
    } catch (e) {
      return (false, e.toString());
    }
  }

  // Delete a comment by ID
  Future<(bool isSuccess, String? message)> deleteComment(
      String commentId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCommentCollectionId,
        documentId: commentId,
      );
      return (true, 'Comment deleted successfully');
    } catch (e) {
      return (false, e.toString());
    }
  }
}
