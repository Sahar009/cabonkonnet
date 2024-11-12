import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:get/get.dart';

class InterestRepository {
  final Databases databases;

  InterestRepository({required this.databases});

// Fetch all posts (optional)
  Future<(bool isSuccess, List? posts, String? message)> getAllInterest() async {
    try {
      final documents = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.interestCollectionId,
       
      );

      var d = documents.documents.map((e) => e.data).toList();
      log(d.toString());

      return (true, d, null);
    } catch (e) {
      return (false, null, e.toString());
    }
  }

  Future<bool> updateInterest(RxList userIntrest, String userId) async {
    try {
      final documents = await databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.userCollectionId,
          documentId: userId,
          data: {
            "interests": userIntrest.map((intrest) => intrest["\$id"]).toList()
          });

      return true;
    } catch (e) {
      log('Error ${e.toString()}');
      return false;
    }
  }
}
