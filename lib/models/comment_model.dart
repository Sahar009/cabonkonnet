// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CommentModel {
  final String id;
  final String content;
  final String postId;
  final DateTime createdAt;
  final String userId;
  final String? userFullName;
  final String? userProfileImage;
  final List<String>? likes;

  CommentModel({
    required this.id,
    required this.content,
    required this.postId,
    required this.createdAt,
    required this.userId,
    this.userFullName,
    this.userProfileImage,
    this.likes,
  });

  CommentModel copyWith({
    String? id,
    String? content,
    String? postId,
    DateTime? createdAt,
    String? userId,
    String? userFullName,
    String? userProfileImage,
    List<String>? likes,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userFullName: userFullName ?? this.userFullName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'postId': postId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
      'userFullName': userFullName,
      'userProfileImage': userProfileImage,
      'likes': likes,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['\$id'] as String,
      content: map['content'] as String,
      postId: map['postId'] as String,
      createdAt: DateTime.parse(map['\$createdAt']),
      userId: map['user']['\$id'], // Assuming user ID is available
      userFullName: map['user']['fullName'] ?? 'Unknown User',
      userProfileImage: map['user']['profileImage'],
      likes: map['likes'] != null ? List.from((map['likes'] as List)) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, content: $content, postId: $postId, createdAt: $createdAt, userId: $userId, userFullName: $userFullName, userProfileImage: $userProfileImage, likes: $likes)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.content == content &&
        other.postId == postId &&
        other.createdAt == createdAt &&
        other.userId == userId &&
        other.userFullName == userFullName &&
        other.userProfileImage == userProfileImage &&
        listEquals(other.likes, likes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        content.hashCode ^
        postId.hashCode ^
        createdAt.hashCode ^
        userId.hashCode ^
        userFullName.hashCode ^
        userProfileImage.hashCode ^
        likes.hashCode;
  }
}
