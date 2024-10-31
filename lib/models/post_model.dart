// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cabonconnet/models/product_model.dart';
import 'package:cabonconnet/models/user_model.dart';

class PostModel {
  final String id;
  final UserModel? user; // Changed from userId to user
  final ProductModel? product;
  final String content;
  final bool isProduct;
  final List<String> hashtags;
  final List<String> imageUrls;
  final DateTime createdAt;
  final int? commentCount; // You can change this type as needed
  final List<dynamic>? sharedBy; // You can change this type as needed
  final List<dynamic>? likes; // You can change this type as needed

  PostModel({
    required this.id,
    this.user,
    this.product,
    required this.content,
    required this.hashtags,
    required this.imageUrls,
    required this.createdAt,
    this.isProduct = false,
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
      product: map['product'] != null
          ? ProductModel.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      isProduct: map["isProduct"],
      content: map['content'] as String,
      hashtags: List<String>.from((map['hashtags'] as List<dynamic>? ?? [])),
      imageUrls: List<String>.from((map['imageUrls'] as List<dynamic>? ?? [])),
      createdAt: DateTime.parse(map['createdAt']),
      commentCount: (map['commentCount']),
      sharedBy: List<dynamic>.from((map['sharedBy'] as List<dynamic>? ?? [])),
      likes: List<dynamic>.from((map['likes'] as List<dynamic>? ?? [])),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'hashtags': hashtags,
      'imageUrls': imageUrls,
      "isProduct": isProduct,
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
    List<dynamic>? like,
  }) {
    return PostModel(
      id: id ?? this.id,
      user: user ?? this.user,
      isProduct: isProduct,
      content: content ?? this.content,
      hashtags: hashtags ?? this.hashtags,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      commentCount: commentCount ?? this.commentCount,
      sharedBy: sharedBy ?? this.sharedBy,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, user: $user, content: $content, isProduct:$isProduct, product:$product hashtags: $hashtags, imageUrls: $imageUrls, createdAt: $createdAt, commentCount: $commentCount, sharedBy: $sharedBy)';
  }
}
