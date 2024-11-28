import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/product_model.dart';

class ProductRepository {
  final Databases databases;

  ProductRepository({required this.databases});

  // Create a new Product
  Future<(bool isSuccess, String? message)> createProductProduct(
      ProductModel product, String userId) async {
    try {
      var cred = await databases.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId:
              AppwriteConfig.productCollectionId, // Your Product collection ID
          documentId: product.id, // Unique ID for the document
          data: {"user": userId, ...product.toMap()});

      return (true, cred.$id); // Return true and the document ID
    } on AppwriteException catch (e) {
      log(e.message.toString());
      return (false, e.toString()); // Return false and the error message
    }
  }

  // Retrieve a Product by ID
  Future<(bool isSuccess, ProductModel? product, String? message)> getProduct(
      String productId) async {
    try {
      final Document document = await databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productCollectionId,
        documentId: productId,
      );
      return (true, ProductModel.fromMap(document.data), null);
    } catch (e) {
      return (false, null, e.toString());
    }
  }

  // Update a Product
  Future<bool> updateProduct(ProductModel product) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productCollectionId,
        documentId: product.id,
        data: product.toMap(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete a Product
  Future<bool> deleteProduct(String productId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.productCollectionId,
        documentId: productId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Fetch all Products (optional)
  Future<(bool isSuccess, List<ProductModel>? products, String? message)>
      getAllProducts() async {
    try {
      final documents = await databases.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.productCollectionId,
          queries: [Query.equal('status', 'approved')]   );

      var d = documents.documents.map((e) => e.data);
      log(d.toString());

      List<ProductModel> productList = documents.documents
          .map((doc) => ProductModel.fromMap(doc.data))
          .toList();

      return (true, productList, null);
    } catch (e) {
      return (false, null, e.toString());
    }
  }
}
