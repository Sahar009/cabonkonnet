// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TeamMemberModel {
  final String id;
  final String fullName;
  final String founderId;
  final String email;
  final String position;
  final String location;
  final String profilePic;
  TeamMemberModel({
    required this.id,
    required this.fullName,
    required this.founderId,
    required this.email,
    required this.position,
    required this.location,
    required this.profilePic,
  });

  TeamMemberModel copyWith({
    String? id,
    String? fullName,
    String? founderId,
    String? email,
    String? position,
    String? location,
    String? profilePic,
  }) {
    return TeamMemberModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      founderId: founderId ?? this.founderId,
      email: email ?? this.email,
      position: position ?? this.position,
      location: location ?? this.location,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'founderId': founderId,
      'email': email,
      'position': position,
      'location': location,
      'profilePic': profilePic,
    };
  }

  factory TeamMemberModel.fromMap(Map<String, dynamic> map) {
    return TeamMemberModel(
      id: map['\$id'] as String,
      fullName: map['fullName'] as String,
      founderId: map['founderId'] as String,
      email: map['email'] as String,
      position: map['position'] as String,
      location: map['location'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamMemberModel.fromJson(String source) =>
      TeamMemberModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TeamMemberModel(id: $id, fullName: $fullName, founderId: $founderId, email: $email, position: $position, location: $location, profilePic: $profilePic)';
  }

  @override
  bool operator ==(covariant TeamMemberModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.founderId == founderId &&
        other.email == email &&
        other.position == position &&
        other.location == location &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        founderId.hashCode ^
        email.hashCode ^
        position.hashCode ^
        location.hashCode ^
        profilePic.hashCode;
  }
}
