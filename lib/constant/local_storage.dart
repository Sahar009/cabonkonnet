import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLocalStorage {
  String onBoadringKey = "hshjs";
  static String onRecoverKey = "jhdhjkahk";

  static final storage = new FlutterSecureStorage();

  Future<String?> getOnBoarding() async {
    String? value = await storage.read(key: onBoadringKey);
    return value;
  }

  Future setOnboard() async {
    await storage.write(key: onBoadringKey, value: "true");
  }

  static Future<String?> getReoverToken() async {
    String? value = await storage.read(key: onRecoverKey);
    return value;
  }

  static Future setRecoverToken(String token) async {
    await storage.write(key: onRecoverKey, value: token);
  }
}
