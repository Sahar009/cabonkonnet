import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/constant/appwrite_config.dart';
import 'package:cabonconnet/models/team_member_model.dart';

class TeamRepository {
  final Databases databases;
  const TeamRepository({required this.databases});

  Future<(bool isSuccess, String? message)> createTeam(
      TeamMemberModel team, List teams) async {
    try {
      final Document document = await databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId:
            AppwriteConfig.teamCollectionId, // Your post collection ID
        documentId: team.id, // Unique ID for the document
        data: team.toMap(),
      );
      await databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.userCollectionId,
          documentId: team.founderId,
          data: {"teamMembers": teams});
      return (true, document.$id); // Return true and the document ID
    } catch (e) {
      return (false, e.toString()); // Return false and the error message
    }
  }

  Future<(bool isSuccess, List<TeamMemberModel>? teams, String? message)>
      getTeam(String foundId) async {
    try {
      final documents = await databases.listDocuments(
          databaseId: AppwriteConfig.databaseId,
          collectionId:
              AppwriteConfig.teamCollectionId, // Your post collection ID
          queries: [Query.equal("founderId", foundId)]);
      List<TeamMemberModel> teams = documents.documents
          .map((e) => TeamMemberModel.fromMap(e.data))
          .toList();
      return (true, teams, ""); // Return true and the document ID
    } catch (e) {
      return (false, null, e.toString()); // Return false and the error message
    }
  }
}
