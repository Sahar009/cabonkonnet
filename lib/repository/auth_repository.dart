import 'dart:convert';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:http/http.dart' as http;

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

  final String baseUrl = "https://671a6e5a6c7d04cf15aa.appwrite.global";

  // Action constants
  static const String actionSendOtp = "sendOtp";
  static const String actionVerifyOtp = "verifyOtp";
  static const String actionUpdatePassword = "updatePassword";

  // Register a new user
  Future<(bool, UserModel?, String)> registerUser(
      {required String email,
      required String password,
      required String fullName,
      required String phoneNumber,
      required String role}) async {
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
      AppLocalStorage.setCurrentUserId(user.$id);

      await database.createDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: user.$id,
        data: userModel.toMap(),
      );

      // Send OTP for verification
      sendOtp(email: email, isFirstVerify: true);

      return (true, userModel, "Registration successful");
    } on AppwriteException catch (e) {
      log('Error registering user: ${e.message}');
      return (false, null, 'Error registering user: ${e.message}');
    } catch (e) {
      log('An unexpected error occurred: $e');
      return (false, null, 'An unexpected error occurred: $e');
    }
  }

  // Login a user
  Future<(bool, UserModel?, String)> loginUser(
      String email, String password) async {
    try {
      account.deleteSessions();
      // Attempt to login the user
      final session = await account.createEmailPasswordSession(
          email: email, password: password);

      // Retrieve the user details from the database
      final userDoc = await database.getDocument(
        databaseId: databaseId,
        collectionId: userCollectionId,
        documentId: session.userId,
      );

      AppLocalStorage.setCurrentUserId(session.userId);
      var userModel = UserModel.fromMap(userDoc.data);
      return (true, userModel, "Login successful");
    } on AppwriteException catch (e) {
      log('Error logging in: ${e.message}');
      return (false, null, 'Error logging in: ${e.message}');
    } catch (e) {
      log('An unexpected error occurred: $e');
      return (false, null, 'An unexpected error occurred: $e');
    }
  }

  // Send OTP
  Future<(bool, String)> sendOtp({
    required String email,
    required bool isFirstVerify,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "action": actionSendOtp,
          "email": email,
          "isFirstVerify": isFirstVerify,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["status"]) {
          return (true, "OTP sent successfully: ${data['message']}");
        } else {
          log("OTP sending failed: ${data['message']}");
          return (false, "Error: ${data['message']}");
        }
      } else {
        log("Failed to send OTP. Status code: ${response.statusCode}");
        return (
          false,
          "Failed to send OTP. Status code: ${response.statusCode}"
        );
      }
    } catch (e) {
      log("Error sending OTP: ${e.toString()}");
      return (false, "Error sending OTP: ${e.toString()}");
    }
  }

  // Verify OTP
  Future<(bool, bool?, String)> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "action": actionVerifyOtp,
          "email": email,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["status"]) {
          if (data["message"] == "User verified successfully!") {
            return (true, null, data['message'].toString());
          }
          log("OTP verified successfully: ${data['message']}");
          AppLocalStorage.setRecoverToken(data['token']);
          return (true, true, data['message'].toString());
        } else {
          log("OTP verification failed: ${data['message']}");
          return (false, null, data['message'].toString());
        }
      } else {
        log("Failed to verify OTP. Status code: ${response.statusCode}");
        return (false, null, "Failed to verify OTP");
      }
    } catch (e) {
      log("Error verifying OTP: ${e.toString()}");
      return (false, null, "Error verifying OTP: ${e.toString()}");
    }
  }

  // Update password
  Future<(bool, String)> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    var token = await AppLocalStorage.getReoverToken();
    if (token == null) {
      return (false, "Reverify user");
    }
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "action": actionUpdatePassword,
          "email": email,
          "new_password": newPassword,
          "token": token,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status']) {
          log("Password updated successfully!");
          return (true, "Password updated successfully!");
        } else {
          log("Error: ${data['message']}");
          return (false, "Error: ${data['message']}");
        }
      } else {
        log("Server Error: ${response.body}");
        return (false, "Server error: ${response.body}");
      }
    } catch (e) {
      log("Error: $e");
      return (false, "Error: $e");
    }
  }
}
