import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:travel/data/models/hotel_model.dart';
import 'package:travel/services/firebase_storage_service.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/toast.dart';

class HotelRepository {
  static final String _collection = "hotels";

  static Future<List<HotelModel>?> getList() async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getList(
        _collection,
      );
      return data.map((map) => HotelModel.fromJson(map)).toList();
    } catch (e) {
      showToast(e.toString());
    }
    return null;
  }

  static Future<String?> uploadImage(File file) async {
    return await FirebaseStorageService.uploadFile(_collection, file);
  }
}

class HotelBookingRepository {
  static final String _bookingCollection = "hotelsBooking";

  static Future<bool> post({
    required String hotelUid,
    required String userUid,
    required DateTime startDate,
    required DateTime endDate,
    required int roomCount,
    required String totalPrice,
  }) async {
    try {
      Map<String, dynamic> bookingData = {
        'userUid': userUid,
        'hotelUid': hotelUid,
        'startDate': startDate,
        'endDate': endDate,
        'roomCount': roomCount,
        'price': totalPrice,
        'createdAt': DateTime.now(),
      };
      return await FirestoreService.insert(
        collection: _bookingCollection,
        data: bookingData,
      );
    } catch (e) {
      showToast("Booking failed: ${e.toString()}");
      return false;
    }
  }
}
