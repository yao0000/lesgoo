import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String uid;
  final String name;
  final String about;
  final String address;
  final double price;
  final double rating;
  final String imageUrl;

  final List<String> gallery;

  RestaurantModel({
    required this.uid,
    required this.name,
    required this.about,
    required this.address,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.gallery,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      about: json['about'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0.00).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      gallery:
          (json['gallery'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'about': about,
      'address': address,
      'price': price,
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }
}

class RestaurantBookingModel {
  String bookingUid;
  String itemUid;
  String userUid;
  DateTime time;
  int pax;
  String amount;
  DateTime createdTime;

  RestaurantBookingModel({
    required this.itemUid,
    required this.userUid,
    required this.time,
    required this.pax,
    required this.amount,
    DateTime? createdTime,
    String? bookingUid,
  }) : createdTime = createdTime ?? DateTime.now(),
       bookingUid = bookingUid ?? "";

  factory RestaurantBookingModel.fromJson(Map<String, dynamic> json) {
    return RestaurantBookingModel(
      bookingUid: json['uid'] ?? '',
      itemUid: json['itemUid'] ?? '',
      userUid: json['userUid'] ?? '',
      time: (json['time'] as Timestamp).toDate(),
      pax: (json['pax'] ?? 1) as int,
      amount: json['amount'] ?? 'Unknown',
      createdTime:
          json['createdTime'] != null
              ? (json['createdTime'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemUid': itemUid,
      'userUid': userUid,
      'time': time,
      'pax': pax,
      'amount': amount,
      'createdTime': createdTime,
    };
  }
}
