import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/auth_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AppwriteConfig appWriteConfig = AppwriteConfig();
  final AuthRepository authRepository = AuthRepository(
    account: AppwriteConfig().account,
    database: AppwriteConfig().databases,
    userCollectionId: AppwriteConfig.userCollectionId,
    databaseId: AppwriteConfig.databaseId,
  );
  var _user = Rx<UserModel?>(null); // Reactive user variable
  UserModel? get user => _user.value; // Getter for user

  // Register a new user and save to the database
  Future<void> registerUser(
    String email,
    String password,
    String fullName,
    String phoneNumber, {
    String? companyName,
    String? address,
    String? businessRegNumber,
    String? website,
  }) async {
    try {
      _user.value = await authRepository.registerUser(
          email, password, fullName, phoneNumber, address!);
      // Optionally handle success (e.g., navigate to another screen)
      if (_user.value != null) {
        Get.offAllNamed('/home'); // Navigate to home after registration
      }
    } catch (e) {
      // Handle registration errors
      Get.snackbar('Error', 'Registration failed: $e');
    }
  }

  // Login the user and fetch details
  Future<void> loginUser(String email, String password) async {
    try {
      _user.value = await authRepository.loginUser(email, password);
      if (_user.value != null) {
        Get.offAllNamed('/home'); // Navigate to home after login
      }
    } catch (e) {
      // Handle login errors
      Get.snackbar('Error', 'Login failed: $e');
    }
  }

  // Save user details to the database
  Future<void> saveUserDetails(UserModel user) async {
    try {
      await authRepository.saveUserDetails(user);
    } catch (e) {
      // Handle saving errors
      Get.snackbar('Error', 'Failed to save user details: $e');
    }
  }

  // Logout function
  Future<void> logoutUser() async {
    _user.value = null;
    // Optionally navigate to login screen
    Get.offAllNamed('/login');
  }
}
