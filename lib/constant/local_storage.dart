import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLocalStorage {
  String onBoadringKey = "hshjs";

  final storage = new FlutterSecureStorage();

  Future<String?> getOnBoarding() async {
    String? value = await storage.read(key: onBoadringKey);
    return value;
  }

  Future setOnboard() async {
    await storage.write(key: onBoadringKey, value: "true");
  }
}
