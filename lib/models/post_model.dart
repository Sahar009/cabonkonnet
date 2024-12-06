// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cabonconnet/models/user_model.dart';

class PostModel {
  final String id;
  final UserModel? user; // Changed from userId to user
  final String content;
  final List<String> hashtags;
  final List<String> imageUrls;
  final DateTime createdAt;
  final int? commentCount; // You can change this type as needed
  final List<dynamic>? sharedBy; // You can change this type as needed
  final List<String>? likes; // You can change this type as needed

  PostModel({
    required this.id,
    this.user,
    required this.content,
    required this.hashtags,
    required this.imageUrls,
    required this.createdAt,
    this.commentCount,
    this.sharedBy,
    this.likes,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['\$id'] as String,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
     
     
      content: map['content'] as String,
      hashtags: List<String>.from((map['hashtags'] as List<dynamic>? ?? [])),
      imageUrls: List<String>.from((map['imageUrls'] as List<dynamic>? ?? [])),
      createdAt: DateTime.parse(map['createdAt']),
      commentCount: (map['commentCount']),
      sharedBy: List<dynamic>.from((map['sharedBy'] as List<dynamic>? ?? [])),
      likes: List<String>.from((map['likes'] as List? ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'hashtags': hashtags,
      'imageUrls': imageUrls,
      
      'createdAt': createdAt.millisecondsSinceEpoch,
      'commentCount': commentCount,
      'sharedBy': sharedBy,
    };
  }

  PostModel copyWith({
    String? id,
    UserModel? user,
    String? content,
    List<String>? hashtags,
    List<String>? imageUrls,
    DateTime? createdAt,
    int? commentCount,
    List<dynamic>? sharedBy,
    List<dynamic>? likes,
  }) {
    return PostModel(
        id: id ?? this.id,
        user: user ?? this.user,
     
        content: content ?? this.content,
        hashtags: hashtags ?? this.hashtags,
        imageUrls: imageUrls ?? this.imageUrls,
        createdAt: createdAt ?? this.createdAt,
        commentCount: commentCount ?? this.commentCount,
        sharedBy: sharedBy ?? this.sharedBy,
        likes: likes != null ? List<String>.from(likes) : this.likes);
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, user: $user, content: $content,  hashtags: $hashtags, imageUrls: $imageUrls, createdAt: $createdAt, commentCount: $commentCount, sharedBy: $sharedBy)';
  }
}
