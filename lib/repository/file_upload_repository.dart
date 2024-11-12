import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';

class FileUploadRepository {
  final Storage storage;
  final String bucketId;

  FileUploadRepository({required this.storage, required this.bucketId});

  Future<String?> uploadFile(File file, String fileName) async {
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

      String fileUrl = AppwriteConfig.getFileUrl(bucketId, uploadedFile.$id);
      return fileUrl;
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> delectFile(String fileId) async {
    try {
      // Create the file and upload it to Appwrite
      await storage.deleteFile(
        bucketId: bucketId,
        fileId: fileId, // Generates a unique file ID
      );

      // Return the uploaded file information

      return true;
    } on AppwriteException {
      return false;
    } catch (e) {
      return false;
    }
  }
}
