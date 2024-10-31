import 'package:appwrite/appwrite.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/repository/chat_repository.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  ChatRepository chatRepository =
      ChatRepository(databases: Databases(AppwriteConfig().client));
}
