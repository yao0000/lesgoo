import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.password = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
