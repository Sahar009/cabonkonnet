import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/models/user_model.dart';

import '../constant/local_storage.dart';

class UserRepository {
  final Databases database;
  final String userCollectionId;
  final String databaseId;

  UserRepository({
    required this.database,
    required this.userCollectionId,
    required this.databaseId,
  });

  Future<(bool, UserModel?, String)> updateUserDetails(UserModel user) async {
    try {
       String? userId = await AppLocalStorage.getCurrentUserId();
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: userId ?? user.id,
        data: user.toMap(),
      );
      return (true, user, "Update successful");
    } on AppwriteException catch (e) {
      return (false, null, 'Error saving user details: ${e.message}');
    } catch (e) {
      return (false, null, 'An unexpected error occurred: $e');
    }
  }

  Future<(bool, UserModel?)> getUserDetails(String userId) async {
    try {
      var doc = await database.getDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: userId,
      );

      UserModel userModel = UserModel.fromMap(doc.data);
      return (
        true,
        userModel,
      );
    } on AppwriteException catch (e) {
      log(e.toString());

      return (
        false,
        null,
      );
    } catch (e) {
      return (
        false,
        null,
      );
    }
  }

  Future<(bool, UserModel?, String)> getConrrentDetails(UserModel user) async {
    try {
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: user.id,
        data: user.toMap(),
      );
      return (true, user, "Update successful");
    } on AppwriteException catch (e) {
      return (false, null, 'Error saving user details: ${e.message}');
    } catch (e) {
      return (false, null, 'An unexpected error occurred: $e');
    }
  }
}
