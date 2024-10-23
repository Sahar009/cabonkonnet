import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class FileUploadService {
  final Storage storage;
  final String bucketId;

  FileUploadService({required this.storage, required this.bucketId});

  Future<models.File?> uploadFile(File file, String fileName) async {
    try {
      // Create the file and upload it to Appwrite
      final uploadedFile = await storage.createFile(
        bucketId: bucketId,
        fileId: 'unique()', // Generates a unique file ID
        file: InputFile.fromPath(
          path: file.path, // Path to the file
          filename: fileName, // Optional file name
        ),
      );

      // Return the uploaded file information
      print('File uploaded successfully: ${uploadedFile.$id}');
      return uploadedFile;
    } on AppwriteException catch (e) {
      print('Failed to upload file: ${e.message}');
      return null;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null;
    }
  }
}
