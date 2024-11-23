// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String id; // Use UUID for unique identification
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role; // 'product_owner' or 'investor'

  // Product Owner Fields
  final String? companyName; // Nullable for investors
  final String? address; // Nullable for investors
  final String? businessRegNumber; // Nullable for product owners
  final String? website; // Nullable for product owners
  final String? country;
  final String? teamNumber;
  // Investor Fields
  final String? bankStatementUrl; // URL or path for bank statement
  final String? idCardUrl; // URL or path for ID card
  final String? profileImage;
  final String? coverImage;

  final List? interests;
  final String? bio;
  final List? teamMembers;
  final String? businessLogoUrl;

  UserModel(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.phoneNumber,
      required this.role,
      this.companyName,
      this.address,
      this.businessRegNumber,
      this.website,
      this.country,
      this.teamNumber,
      this.bankStatementUrl,
      this.idCardUrl,
      this.profileImage,
      this.interests,
      this.bio,
      this.teamMembers,
      this.businessLogoUrl,
      this.coverImage});

  // Method to convert UserModel to a Map for storage (e.g., in Firestore)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'companyName': companyName,
      'address': address,
      'businessRegNumber': businessRegNumber,
      'website': website,
      'country': country,
      'teamNumber': teamNumber,
      'bankStatementUrl': bankStatementUrl,
      'idCardUrl': idCardUrl,
      'profileImage': profileImage,
      'interests': interests,
      'bio': bio,
      'teamMembers': teamMembers,
      'businessLogoUrl': businessLogoUrl,
      "coverImage": coverImage
    };
  }

  // Factory method to create UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['\$id'] as String,
        fullName: map['fullName'] as String,
        email: map['email'] as String,
        phoneNumber: map['phoneNumber'] as String,
        role: map['role'] as String,
        companyName:
            map['companyName'] != null ? map['companyName'] as String : null,
        address: map['address'] != null ? map['address'] as String : null,
        businessRegNumber: map['businessRegNumber'] != null
            ? map['businessRegNumber'] as String
            : null,
        website: map['website'] != null ? map['website'] as String : null,
        country: map['country'] != null ? map['country'] as String : null,
        teamNumber:
            map['teamNumber'] != null ? map['teamNumber'] as String : null,
        bankStatementUrl: map['bankStatementUrl'] != null
            ? map['bankStatementUrl'] as String
            : null,
        idCardUrl: map['idCardUrl'] != null ? map['idCardUrl'] as String : null,
        profileImage:
            map['profileImage'] != null ? map['profileImage'] as String : null,
        interests:
            map['interests'] != null ? List.from(map['interests']) : null,
        bio: map['bio'] != null ? map['bio'] as String : null,
        teamMembers:
            map['teamMembers'] != null ? List.from(map['teamMembers']) : null,
        businessLogoUrl: map["businessLogoUrl"],
        coverImage: map['coverImage']);
  }

  UserModel copyWith(
      {String? id,
      String? fullName,
      String? email,
      String? phoneNumber,
      String? role,
      String? companyName,
      String? address,
      String? businessRegNumber,
      String? website,
      String? country,
      String? teamNumber,
      String? bankStatementUrl,
      String? idCardUrl,
      String? profileImage,
      List? interests,
      String? bio,
      String? businessLogoUrl,
      String? coverImage}) {
    return UserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        role: role ?? this.role,
        companyName: companyName ?? this.companyName,
        address: address ?? this.address,
        businessRegNumber: businessRegNumber ?? this.businessRegNumber,
        website: website ?? this.website,
        country: country ?? this.country,
        teamNumber: teamNumber ?? this.teamNumber,
        bankStatementUrl: bankStatementUrl ?? this.bankStatementUrl,
        idCardUrl: idCardUrl ?? this.idCardUrl,
        profileImage: profileImage ?? this.profileImage,
        interests: interests ?? this.interests,
        bio: bio ?? this.bio,
        businessLogoUrl: businessLogoUrl ?? this.bankStatementUrl,
        coverImage: coverImage ?? coverImage);
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, role: $role, companyName: $companyName, address: $address, businessRegNumber: $businessRegNumber, website: $website, country: $country, teamNumber: $teamNumber, bankStatementUrl: $bankStatementUrl, idCardUrl: $idCardUrl, profileImage: $profileImage, interests: $interests, bio: $bio, teamMembers: $teamMembers)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.role == role &&
        other.companyName == companyName &&
        other.address == address &&
        other.businessRegNumber == businessRegNumber &&
        other.website == website &&
        other.country == country &&
        other.teamNumber == teamNumber &&
        other.bankStatementUrl == bankStatementUrl &&
        other.idCardUrl == idCardUrl &&
        other.profileImage == profileImage &&
        other.interests == interests &&
        other.bio == bio &&
        other.teamMembers == teamMembers;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        role.hashCode ^
        companyName.hashCode ^
        address.hashCode ^
        businessRegNumber.hashCode ^
        website.hashCode ^
        country.hashCode ^
        teamNumber.hashCode ^
        bankStatementUrl.hashCode ^
        idCardUrl.hashCode ^
        profileImage.hashCode ^
        interests.hashCode ^
        bio.hashCode ^
        teamMembers.hashCode;
  }
}
