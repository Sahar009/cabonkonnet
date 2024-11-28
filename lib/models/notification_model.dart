// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cabonconnet/enum/notification_type_enum.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type; // Using enum
  final String senderId;
  final String receiverId;
  final bool isRead;
  DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.senderId,
    required this.receiverId,
    required this.isRead,
    required this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? senderId,
    String? receiverId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'message': message,
      'type': type.appwriteValue, // Convert enum to string
      'senderId': senderId,
      'receiverId': receiverId,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['\$id'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      type: NotificationTypeExtension.fromAppwriteValue(
          map['type'] as String)!, // Pass the value to fromAppwriteValue
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      isRead: map['isRead'] as bool,
      createdAt: DateTime.parse(map['\$createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, type: $type, senderId: $senderId, receiverId: $receiverId, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.message == message &&
        other.type == type &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.isRead == isRead &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        message.hashCode ^
        type.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        isRead.hashCode ^
        createdAt.hashCode;
  }
}
