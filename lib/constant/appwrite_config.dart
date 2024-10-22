import 'package:appwrite/appwrite.dart';

class AppwriteConfig {
  static String projectId = "671737250034dc45f228";
  static String databaseId = "6717388600333d9d6235";
  static String userCollectionId = '671738970021b19aefb7';

  late Client _client;
  late Account _account;
  late Databases _databases;

  AppwriteConfig() {
    _client = Client().setProject(projectId);

    _account = Account(_client);
    _databases = Databases(client);
  }

  // Getter to access the client
  Client get client => _client;

  // Getter to access the account
  Account get account => _account;
  // Getter to access the databases
  Databases get databases => _databases;
}
