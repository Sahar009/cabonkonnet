import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/models/user_model.dart';

class AuthRepository {
  final Account account;
  final Databases database;
  final String userCollectionId;
  final String databaseId;

  AuthRepository({
    required this.account,
    required this.database,
    required this.userCollectionId,
    required this.databaseId,
  });

  // Register a new user
  Future<(bool, UserModel?, String)> registerUser(String email, String password,
      String fullName, String phoneNumber, String role) async {
    try {
      // Create a new account in Appwrite
      final user = await account.create(
        userId: 'unique()', // Automatically generates a unique ID
        email: email,
        password: password,
      );

      // Save user details to the database
      UserModel userModel = UserModel(
        id: user.$id,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        role: role,
      );

      await database.createDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: user.$id,
        data: userModel.toMap(),
      );

      // Return a record with success = true and userModel
      return (true, userModel, "Register Sucessfuly");
    } on AppwriteException catch (e) {
      print('Error registering user: ${e.message}');
      // Return a record with success = false and null for userModel
      return (false, null, 'Error registering user: ${e.message}');
    } catch (e) {
      print('An unexpected error occurred: $e');
      // Return a record with success = false and null for userModel
      return (false, null, 'An unexpected error occurred: $e');
    }
  }

  //Login a user
 Future<(bool, UserModel?, String)> loginUser(String email, String password) async {
  try {
    // Attempt to login the user
    final session = await account.createEmailPasswordSession(
        email: email, password: password);

    // Retrieve the user details from the database
    final userDoc = await database.getDocument(
      databaseId: databaseId,
      collectionId: userCollectionId,
      documentId: session.userId,
    );

    var userModel = UserModel.fromMap(userDoc.data);

    // Return positional records
    return (true, userModel, "Login Successfully");
  } on AppwriteException catch (e) {
    print('Error logging in: ${e.message}');
    // Return positional records in case of an error
    return (false, null, 'Error logging in: ${e.message}');
  } catch (e) {
    print('An unexpected error occurred: $e');
    return (false, null, 'An unexpected error occurred: $e');
  }
}



  
}
