// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  final String id;
  final String content;
  final String postId;
  final DateTime createdAt;
  final String userId;
  final String? userFullName;
  final String? userProfileImage;

  CommentModel({
    required this.id,
    required this.content,
    required this.postId,
    required this.createdAt,
    required this.userId,
    this.userFullName,
    this.userProfileImage,
  });

  factory CommentModel.fromMap(Map<String, dynamic> data) {
    return CommentModel(
      id: data["\$id"],
      content: data['content'] ?? '',
      postId: data['postId'],
      createdAt: DateTime.parse(data['\$createdAt']),
      userId: data['user']['\$id'], // Assuming user ID is available
      userFullName: data['user']['fullName'] ?? 'Unknown User',
      userProfileImage: data['user']['profileImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'postId': postId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
    };
  }

  CommentModel copyWith({
    String? content,
    String? postId,
    DateTime? createdAt,
    String? userId,
    String? userFullName,
    String? userProfileImage,
    String? id,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userFullName: userFullName ?? this.userFullName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(content: $content, postId: $postId, createdAt: $createdAt, userId: $userId, userFullName: $userFullName, userProfileImage: $userProfileImage)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.content == content &&
        other.postId == postId &&
        other.createdAt == createdAt &&
        other.userId == userId &&
        other.userFullName == userFullName &&
        other.userProfileImage == userProfileImage;
  }

  @override
  int get hashCode {
    return content.hashCode ^
        postId.hashCode ^
        createdAt.hashCode ^
        userId.hashCode ^
        userFullName.hashCode ^
        userProfileImage.hashCode;
  }
}
