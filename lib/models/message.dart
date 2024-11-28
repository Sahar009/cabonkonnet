// ignore_for_file: public_member_api_docs, sort_constructors_first
// message.dart
import 'dart:convert';
import 'package:appwrite/models.dart';
import 'package:cabonconnet/models/user_model.dart';

class Message {
  final String id;
  final String chatRoomId;
  final UserModel sender;
  final String content;
  final String status; // e.g., "sent", "received", "read"
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.chatRoomId,
    required this.sender,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromDocument(Document doc) {
    return Message(
      id: doc.$id,
      chatRoomId: doc.data['chatRoomId'],
      sender:   UserModel.fromMap( doc.data['sender']),
      content: doc.data['content'],
      status: doc.data['status'],
      createdAt: DateTime.parse(doc.data['\$createdAt']),
      updatedAt: DateTime.parse(doc.data['\$updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chatRoomId': chatRoomId,
      'sender': sender.toMap(),
      'content': content,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Message copyWith({
    String? id,
    String? chatRoomId,
    UserModel? sender,
    String? content,
    String? status,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['\$id'] as String,
      chatRoomId: map['chatRoomId'] as String,
      sender: UserModel.fromMap(map['sender'] as Map<String, dynamic>),
      content: map['content'] as String,
      status: map['status'] as String,
      updatedAt: DateTime.parse(map['\$updatedAt']),
      createdAt: DateTime.parse(map['\$createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, chatRoomId: $chatRoomId, sender: $sender, content: $content, status: $status, createdAt: $createdAt)';
  }
}
