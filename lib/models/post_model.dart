// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cabonconnet/models/user_model.dart';

class PostModel {
  final String id;
  final UserModel? user; // Changed from userId to user
  final String content;
  final List<String> hashtags;
  final List<String> imageUrls;
  final DateTime createdAt;
  final List<dynamic>? comments; // You can change this type as needed
  final List<dynamic>? sharedBy; // You can change this type as needed
  final List<dynamic>? likes; // You can change this type as needed

  PostModel({
    required this.id,
    this.user,
    required this.content,
    required this.hashtags,
    required this.imageUrls,
    required this.createdAt,
    this.comments,
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
      hashtags: List<String>.from((map['hashtags'] as List<dynamic>)),
      imageUrls: List<String>.from((map['imageUrls'] as List<dynamic>)),
      createdAt: DateTime.parse(map['createdAt']),
      comments: List<dynamic>.from((map['comments'] as List<dynamic>)),
      sharedBy: List<dynamic>.from((map['sharedBy'] as List<dynamic>)),
      likes: List<dynamic>.from((map['likes'] as List<dynamic>? ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'hashtags': hashtags,
      'imageUrls': imageUrls,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'comments': comments,
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
    List<dynamic>? comments,
    List<dynamic>? sharedBy,
    List<dynamic>? like,
  }) {
    return PostModel(
      id: id ?? this.id,
      user: user ?? this.user,
      content: content ?? this.content,
      hashtags: hashtags ?? this.hashtags,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
      sharedBy: sharedBy ?? this.sharedBy,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, user: $user, content: $content, hashtags: $hashtags, imageUrls: $imageUrls, createdAt: $createdAt, comments: $comments, sharedBy: $sharedBy)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        other.content == content &&
        listEquals(other.hashtags, hashtags) &&
        listEquals(other.imageUrls, imageUrls) &&
        other.createdAt == createdAt &&
        listEquals(other.comments, comments) &&
        listEquals(other.sharedBy, sharedBy);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        content.hashCode ^
        hashtags.hashCode ^
        imageUrls.hashCode ^
        createdAt.hashCode ^
        comments.hashCode ^
        sharedBy.hashCode;
  }
}
