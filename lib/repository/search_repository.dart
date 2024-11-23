import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';

class SearchRepository {
  final Client client;
  final Databases database;

  // Constructor to initialize Appwrite client and database
  SearchRepository({required this.client}) : database = Databases(client);

  Future<List<Map<String, dynamic>>> search(String keyword) async {
    try {
      // Perform search queries
      final DocumentList searchUsers = await database.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.userCollectionId,
        queries: [Query.search('fullName', keyword)],
      );

      final DocumentList searchProducts = await database.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.postCollectionId,
        queries: [Query.search('content', keyword)],
      );

      final DocumentList searchEvents = await database.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.eventCollectionId,
        queries: [Query.search('title', keyword)],
      );

      // Combine results into one list
      List<Map<String, dynamic>> combinedResults = [];
      combinedResults.addAll(
          searchUsers.documents.map((doc) => {'type': 'user', ...doc.data}));
      combinedResults.addAll(searchProducts.documents
          .map((doc) => {'type': 'product', ...doc.data}));
      combinedResults.addAll(
          searchEvents.documents.map((doc) => {'type': 'event', ...doc.data}));

      return combinedResults;
    } on AppwriteException catch (e) {
      throw Exception('AppwriteException: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
