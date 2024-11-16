import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/constant/local_storage.dart';
import 'package:cabonconnet/helpers/custom_snackbar.dart';
import 'package:cabonconnet/repository/interest_repository.dart';
import 'package:cabonconnet/views/home/home.dart';
import 'package:get/get.dart';

class InterestController extends GetxController {
  InterestRepository interestRepository =
      InterestRepository(databases: Databases(AppwriteConfig().client));
  RxList userIntrest = [].obs;
  final RxList interests = [].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchAllInterest();
  }



  // Fetch all posts
  Future<void> fetchAllInterest() async {
    final (isSuccess, fetchedPosts, message) =
        await interestRepository.getAllInterest();
    if (isSuccess) {
      if (fetchedPosts != null) {
        // fetchedPosts.sort((a, b) => b['\$createdAt'].compareTo(a['\$createdAt']));
        interests.assignAll(fetchedPosts);
      }
    } else {
      // Handle error (e.g., show a message)
      Get.snackbar('Error', message ?? 'An unknown error occurred');
    }
  }

  addOrRemove(dynamic value) {
    if (userIntrest.contains(value)) {
      userIntrest.remove(value);
    } else {
      userIntrest.add(value);
    }
  }

  bool check(dynamic value) {
    return userIntrest.contains(value);
  }

  updateInterest() async {
    String? userId = await AppLocalStorage.getCurrentUserId();
    if (userIntrest.isEmpty || userIntrest.length < 3) {
      CustomSnackbar.error(message: "The minimum interest you can choose is 3.");
    }

    if (userId != null) {
      final success =
          await interestRepository.updateInterest(userIntrest, userId);
      if (success) {
        CustomSnackbar.success(message: "Interest updated succesfully");
        Get.to(() => Home());
      } else {
        CustomSnackbar.error(message: "Error upadating interest");
      }
    }
  }
}
