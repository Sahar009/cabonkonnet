// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cabonconnet/models/user_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String level;
  final String goals;
  final double fundsNeeded;
  final double fundsGets;
  final String impact;
  final String? fundingType;
  final List<String> hashtags;
  final List<String> imageUrls;
  final DateTime createdAt;
  final UserModel? user; // Changed from userId to user

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.goals,
    required this.fundsNeeded,
    required this.fundsGets,
    required this.impact,
    this.fundingType,
    required this.hashtags,
    required this.imageUrls,
    required this.createdAt,
    this.user,
  });

  // Factory method to create ProductModel from a map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['\$id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      level: map['level'] as String,
      goals: map['goals'] as String,
      fundsNeeded: map['fundsNeeded'].toDouble() as double,
      fundsGets: map['fundsGets'].toDouble() as double,
      impact: map['impact'] as String,
      fundingType:
          map['fundingType'] != null ? map['fundingType'] as String : null,
      hashtags: List<String>.from((map['hashtags'])),
      imageUrls: List<String>.from((map['imageUrls'])),
      createdAt: DateTime.parse(map['\$createdAt']),
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  // Method to convert ProductModel to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'level': level,
      'goals': goals,
      'fundsNeeded': fundsNeeded,
      'fundsGets': fundsGets,
      'impact': impact,
      'fundingType': fundingType,
      'hashtags': hashtags,
      'imageUrls': imageUrls,
    };
  }

  // Factory method to create ProductModel from JSON
  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Method to convert ProductModel to JSON
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, level: $level, goals: $goals, fundsNeeded: $fundsNeeded, fundsGets: $fundsGets, impact: $impact, fundingType: $fundingType, hashtags: $hashtags, imageUrls: $imageUrls, createdAt: $createdAt, user: $user)';
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? level,
    String? goals,
    double? fundsNeeded,
    double? fundsGets,
    String? impact,
    String? fundingType,
    List<String>? hashtags,
    List<String>? imageUrls,
    DateTime? createdAt,
    UserModel? user,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      goals: goals ?? this.goals,
      fundsNeeded: fundsNeeded ?? this.fundsNeeded,
      fundsGets: fundsGets ?? this.fundsGets,
      impact: impact ?? this.impact,
      fundingType: fundingType ?? this.fundingType,
      hashtags: hashtags ?? this.hashtags,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.level == level &&
        other.goals == goals &&
        other.fundsNeeded == fundsNeeded &&
        other.fundsGets == fundsGets &&
        other.impact == impact &&
        other.fundingType == fundingType &&
        listEquals(other.hashtags, hashtags) &&
        listEquals(other.imageUrls, imageUrls) &&
        other.createdAt == createdAt &&
        other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        level.hashCode ^
        goals.hashCode ^
        fundsNeeded.hashCode ^
        fundsGets.hashCode ^
        impact.hashCode ^
        fundingType.hashCode ^
        hashtags.hashCode ^
        imageUrls.hashCode ^
        createdAt.hashCode ^
        user.hashCode;
  }
}
