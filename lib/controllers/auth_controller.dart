import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/user_model.dart';
import 'package:cabonconnet/repository/auth_repository.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isBusy = false.obs;
  final AuthRepository authRepository = AuthRepository(
    account: AppwriteConfig().account,
    database: AppwriteConfig().databases,
    userCollectionId: AppwriteConfig.userCollectionId,
    databaseId: AppwriteConfig.databaseId,
  );
  var _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;

// Register a new user
  Future<void> registerUser(String email, String password, String fullName,
      String phoneNumber, String role) async {
    isBusy.value = true;
    try {
      // Call the repository method, which returns a record (bool, UserModel?)
      final (isSuccess, userModel, message) = await authRepository.registerUser(
          email, password, fullName, phoneNumber, role);

      if (isSuccess && userModel != null) {
        // Assign the user model to the reactive variable if registration is successful
        _user.value = userModel;
        Get.snackbar("title", message);
        // Navigate to home after successful registration
      } else {
        // Handle registration failure (e.g., show error message)
        Get.snackbar('Error', message);
      }
    } catch (e) {
      // Handle any unexpected errors
      Get.snackbar('Error', 'An error occurred: ${e.toString()}');
    } finally {
      isBusy.value = false; // Set isBusy to false once done
    }
  }

  // Login the user
  Future<void> loginUser(String email, String password) async {
    isBusy.value = true;
    try {
      // Destructure the positional record
      final (status, userModel, message) =
          await authRepository.loginUser(email, password);

      if (status) {
        _user.value = userModel; // Set the user value if login is successful
        Get.offAllNamed('/home'); // Navigate to home if login is successful
      } else {
        Get.snackbar('Error', message); // Show error message
      }
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isBusy.value = false;
    }
  }

  // Save user details to the databas

  // Logout function
  Future<void> logoutUser() async {
    _user.value = null;
    Get.snackbar('Success', 'Successfully logged out');
    Get.offAllNamed('/login');
  }
}
