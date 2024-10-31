import 'package:appwrite/appwrite.dart';

class AppwriteConfig {
  static String appwriteEndpoint = "https://cloud.appwrite.io/v1";
  static String projectId = "671737250034dc45f228";
  static String databaseId = "6717388600333d9d6235";
  static String userCollectionId = '6717d17b0019f7ec1a83';
  static String userFileBukectId = "67188621002cc7456b26";
  static String postBukectId = "671ddd77003c891557e5";
  static String postCollectionId = "672346d30033885ebc75";
  static String productCollectionId = "6723471d001494c80f00";
  static String chatRoomCollectionId = "6723d35b0001452827fb";
  static String messagesCollectionId = "6723d3ca002008ab424e";
  static String ss = "6718f9ed001ed7ba1571";
  static String postLikeCollectionId = "672348e50025a8d9d6cb";
  static String postShareCollectionId = "6723490a00245a40e093";
  static String postCommentCollectionId = "67234f8a003419eeccc7";

  late Client _client;
  late Account _account;
  late Databases _databases;
  late Storage _storage;

  AppwriteConfig() {
    _client = Client().setProject(projectId);
    _account = Account(_client);
    _databases = Databases(client);
    _storage = Storage(client);
  }

  // Getter to access the client
  Client get client => _client;

  // Getter to access the account
  Account get account => _account;
  // Getter to access the databases
  Databases get databases => _databases;

  Storage get storage => _storage;

  static String getFileUrl(String bucketId, String fileId) {
    return '$appwriteEndpoint/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';
  }
}
