import 'package:cloud_firestore/cloud_firestore.dart';

class HotelModel {
  final String uid;
  final String about;
  final String address;
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final String imageFacility;

  final List<String> gallery;

  HotelModel({
    required this.uid,
    required this.about,
    required this.address,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageFacility,
    required this.imageUrl,
    required this.gallery,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      uid: json['uid'] ?? '',
      about: json['about'] ?? '',
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.00).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageFacility: json['imageFacility'] ?? '',
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
      'about': about,
      'address': address,
      'name': name,
      'price': price,
      'rating': rating,
    };
  }
}

class HotelBookingModel {
  String bookingUid;
  String itemUid;
  String userUid;
  DateTime startDate;
  DateTime endDate;
  int roomCount;
  int totalDays;
  String amount;
  DateTime createdTime;

  HotelBookingModel({
    required this.itemUid,
    required this.userUid,
    required this.startDate,
    required this.endDate,
    required this.roomCount,
    required this.totalDays,
    required this.amount,
    DateTime? createdTime,
    String? bookingUid,
  }) : createdTime = createdTime ?? DateTime.now(),
       bookingUid = bookingUid ?? "";

  factory HotelBookingModel.fromJson(Map<String, dynamic> json) {
    return HotelBookingModel(
      bookingUid: json["uid"] ?? "",
      itemUid: json['itemUid'] ?? "",
      userUid: json['userUid'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      roomCount: json['roomCount'] as int,
      totalDays: json['totalDays'] as int,
      amount: json['amount'] ?? '',
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
      'startDate': startDate,
      'endDate': endDate,
      'roomCount': roomCount,
      'totalDays': totalDays,
      'amount': amount,
      'createdTime': createdTime,
    };
  }
}
