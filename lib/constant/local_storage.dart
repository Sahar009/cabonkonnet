import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLocalStorage {
  String onBoadringKey = "hshjs";
  static String onRecoverKey = "jhdhjkahk";
  static String userIdKey = "hdhsalnadfs";

  static const storage = FlutterSecureStorage();

  Future<String?> getOnBoarding() async {
    String? value = await storage.read(key: onBoadringKey);
    return value;
  }

  static Future logout() async {
    await storage.delete(key: userIdKey);
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

  static Future<String?> getCurrentUserId() async {
    String? value = await storage.read(key: userIdKey);
    return value;
  }

  static Future setCurrentUserId(String token) async {
    await storage.write(key: userIdKey, value: token);
  }
}
