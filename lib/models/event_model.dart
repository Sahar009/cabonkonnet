import 'dart:convert';

import 'package:cabonconnet/models/user_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class EventModel {
  final String id;
  final String title;
  final String description;
  final String accessType; // Free or Paid
  final double? ticketPrice; // Nullable, only for paid events
  final DateTime date;
  final String organizerId; // ID of the user creating the event
  final String imageUrl;
  final String location;
  final String? address;
  final UserModel? organizer;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.accessType,
    this.ticketPrice,
    required this.date,
    required this.organizerId,
    required this.imageUrl,
    required this.location,
    required this.address,
    this.organizer,
  });

  /// Converts the EventModel instance into a Map for Appwrite.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'accessType': accessType,
      'ticketPrice': ticketPrice,
      'date': date.toIso8601String(),
      'organizerId': organizerId,
      'imageUrl': imageUrl,
      'location': location,
      'address': address,
      'organizer': organizerId,
    };
  }

  /// Factory constructor to create an EventModel from a Map.
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['\$id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      accessType: map['accessType'] as String,
      ticketPrice:
          map['ticketPrice'] != null ? map['ticketPrice'] as double : null,
      date: DateTime.parse(map['date'] as String),
      organizerId: map['organizerId'] as String,
      imageUrl: map['imageUrl'] as String,
      location: map['location'] as String,
      address: map['address'] != null ? map['address'] as String : null,
      organizer: map['organizer'] != null
          ? UserModel.fromMap(map['organizer'] as Map<String, dynamic>)
          : null,
    );
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? accessType,
    double? ticketPrice,
    DateTime? date,
    String? organizerId,
    String? imageUrl,
    String? location,
    String? address,
    UserModel? organizer,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      accessType: accessType ?? this.accessType,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      date: date ?? this.date,
      organizerId: organizerId ?? this.organizerId,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      address: address ?? this.address,
      organizer: organizer ?? this.organizer,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, description: $description, accessType: $accessType, ticketPrice: $ticketPrice, date: $date, organizerId: $organizerId, imageUrl: $imageUrl, location: $location, address: $address, organizer: $organizer)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.accessType == accessType &&
        other.ticketPrice == ticketPrice &&
        other.date == date &&
        other.organizerId == organizerId &&
        other.imageUrl == imageUrl &&
        other.location == location &&
        other.address == address &&
        other.organizer == organizer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        accessType.hashCode ^
        ticketPrice.hashCode ^
        date.hashCode ^
        organizerId.hashCode ^
        imageUrl.hashCode ^
        location.hashCode ^
        address.hashCode ^
        organizer.hashCode;
  }
}
