import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/repository/search_repository.dart';
import 'package:get/get.dart';

class AppSearchController extends GetxController {
  final SearchRepository searchRepository =
      SearchRepository(client: AppwriteConfig().client);

  var searchResults = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> search(String keyword) async {
    isLoading(true);
    errorMessage('');
    searchResults.clear();

    try {
      // Fetch results from the repository
      final results = await searchRepository.search(keyword);

      // Remove duplicates based on a unique identifier (e.g., 'id')
      final uniqueResults =
          {for (var result in results) result['\$id']: result}.values.toList();

      searchResults.assignAll(uniqueResults); // Add only unique results
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
