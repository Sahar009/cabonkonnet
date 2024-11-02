// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appwrite/models.dart';

import 'package:cabonconnet/models/message.dart';
import 'package:cabonconnet/models/user_model.dart';

class ChatRoom {
  final String id;
  final String type; // e.g., "direct" or "group"
  final List<UserModel> participants;
  final String name;
  final Message? lastMessage;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.type,
    required this.participants,
    required this.name,
    this.lastMessage,
    required this.createdAt,
  });

  factory ChatRoom.fromDocument(Document doc) {
    return ChatRoom(
      id: doc.$id,
      type: doc.data['type'],
      participants: (doc.data['participants'] as List)
          .map((participant) => UserModel.fromMap(participant))
          .toList(),
      name: doc.data['name'],
      lastMessage: doc.data['lastMessage'] != null
          ? Message.fromMap(doc.data['lastMessage'])
          : null,
      createdAt: DateTime.parse(doc.$createdAt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'participants': participants.map((p) => p.toMap()).toList(),
      'name': name,
      'lastMessage': lastMessage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ChatRoom copyWith({
    String? id,
    String? type,
    List<UserModel>? participants,
    String? name,
    Message? lastMessage,
    DateTime? createdAt,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
