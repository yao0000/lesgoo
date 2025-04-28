class UserModel {
  String uid;
  String username;
  String name;
  String email;
  String phone;
  String gender;
  String country;
  String role;
  String password;
  String imageUrl;

  List<bool> notifications;

  UserModel({
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    required this.country,
    required this.gender,
    required this.phone,
    required this.role,
    required this.notifications,
    this.imageUrl = "",
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
      notifications: (json["notifications"] as List<dynamic>).map((e) => e as bool).toList(),
      imageUrl: json['imageUrl'] ?? '',
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
      'imageUrl': imageUrl,
      'notifications': notifications
    };
  }
}
