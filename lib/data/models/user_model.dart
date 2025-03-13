//import 'dart:convert';

class UserModel {
  final String uid;
  final String username;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String country;
  final String role;
  final String password;

  UserModel({
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    required this.country,
    required this.gender,
    required this.phone,
    required this.role,
    this.password = "",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'email': email,
      'country': country,
      'gender': gender,
      'phone': phone,
      'role': role,
    };
  }
}
