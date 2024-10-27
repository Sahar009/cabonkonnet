import 'package:appwrite/appwrite.dart';

class AppwriteConfig {
  static String appwriteEndpoint = "https://cloud.appwrite.io/v1";
  static String projectId = "671737250034dc45f228";
  static String databaseId = "6717388600333d9d6235";
  static String userCollectionId = '6717d17b0019f7ec1a83';
  static String userFileBukectId = "67188621002cc7456b26";
  static String postBukectId = "671ddd77003c891557e5";
  static String postCollectionId = "671d256f0000bb1dc0b9";
  static String ss = "6718f9ed001ed7ba1571";
  static String postLikeCollectionId = "671df06100142deea281";
  static String postShareCollectionId = "671df06100142deea281";
  static String postCommentCollectionId = "671df06100142deea281";

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
    // Your project ID
// https://cloud.appwrite.io/v1/storage/buckets/67188621002cc7456b26/files/67188dfd2618c29f1f37/view?project=671737250034dc45f228
    return '$appwriteEndpoint/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';
  }
}
