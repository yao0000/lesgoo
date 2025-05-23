import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  String uid;
  String name;
  String plate;
  String address;
  double price;
  double seat;
  double rating;
  String imageUrl;

  List<String> gallery;

  CarModel({
    required this.uid,
    required this.name,
    required this.plate,
    required this.address,
    required this.price,
    required this.seat,
    required this.imageUrl,
    required this.gallery,
    required this.rating
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      uid: json['uid'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(), 
      name: json['name'] ?? '',
      plate: json['plate'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      seat: (json['seat'] ?? 1.0).toDouble(),
      address: json['address'] ?? '',
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
      'name': name,
      'plate': plate,
      'price': price,
      'seat': seat,
      'address': address,
      'imageUrl': imageUrl,
      'gallery': gallery,
      'rating': rating,
    };
  }
}

class CarBookingModel {
  String bookingUid;
  String itemUid;
  String userUid;
  DateTime startDate;
  DateTime endDate;
  int daysCount;
  String amount;
  DateTime createdTime;

  CarBookingModel({
    required this.itemUid,
    required this.userUid,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    required this.amount,
    DateTime? createdTime,
    String? bookingUid,
  }) : createdTime = createdTime ?? DateTime.now(),
       bookingUid = bookingUid ?? '';

  factory CarBookingModel.fromJson(Map<String, dynamic> json) {
    return CarBookingModel(
      bookingUid: json['uid'] ?? '',
      itemUid: json['itemUid'] ?? '',
      userUid: json['userUid'] ?? '',
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      daysCount: (json['daysCount'] ?? 1) as int,
      amount: json['amount'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemUid': itemUid,
      'userUid': userUid,
      'startDate': startDate,
      'endDate': endDate,
      'daysCount': daysCount,
      'amount': amount,
      'createdTime': createdTime,
    };
  }
}
