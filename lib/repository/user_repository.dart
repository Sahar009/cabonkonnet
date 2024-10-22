import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/models/user_model.dart';

class UserRepository {
  final Databases database;
  final String userCollectionId;
  final String databaseId;

  UserRepository({
    required this.database,
    required this.userCollectionId,
    required this.databaseId,
  });

  Future<void> updateUserDetails(UserModel user) async {
    try {
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: user.id,
        data: user.toMap(),
      );
    } on AppwriteException catch (e) {
      print('Error saving user details: ${e.message}');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }
}
