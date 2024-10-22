import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/models/user_model.dart';

class AuthRepository {
  final Account account;
  final Databases database;
  final String userCollectionId;
  final String databaseId;

  AuthRepository(
      {required this.account,
      required this.database,
      required this.userCollectionId,
      required this.databaseId});

  // Register a new user
  Future<UserModel?> registerUser(String email, String password,
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
          role: role);

      await database.createDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: user.$id,
        data: userModel.toMap(),
      );

      return userModel;
    } catch (e) {
      print('Error registering user: $e');
      return null;
    }
  }

  // Login a user
  Future<UserModel?> loginUser(String email, String password) async {
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

      return UserModel.fromMap(userDoc.data);
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Save user data to the database
  Future<void> saveUserDetails(UserModel user) async {
    try {
      await database.createDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: user.id,
        data: user.toMap(),
      );
    } catch (e) {
      print('Error saving user details: $e');
    }
  }
}
