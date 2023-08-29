import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String userId;
  final String org;
  final String orgId;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<dynamic> groupId;
  UserModel({
    required this.name,
    required this.userId,
    required this.org,
    required this.orgId,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'org': org,
      'orgId': orgId,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      userId: map['userId'] ?? '',
      org: map['org'] ?? '',
      orgId: map['orgId'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<dynamic>.from(map['groupId']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
