import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/data/models/hotel_model.dart';
import 'package:travel/services/firebase_storage_service.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/toast.dart';

class HotelRepository {
  static final String _collection = "hotels";

  static Future<HotelModel?> getItem(String uid) async {
    try {
      DocumentSnapshot doc = await FirestoreService.getItem(_collection, uid);
      HotelModel data = HotelModel.fromJson(doc.data() as Map<String, dynamic>);
      return data;
    } catch (e) {
      showToast(e.toString());
    }
    return null;
  }

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

  static Future<List<HotelBookingModel>> getListByUser(String userUid) async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getListByUser(
        _bookingCollection,
        userUid,
      );

      return data.map((map) => HotelBookingModel.fromJson(map)).toList();
    } catch (e) {
      showToast(e.toString());
    }
    return [];
  }

  static Future<bool> post({required HotelBookingModel data}) async {
    try {
      return await FirestoreService.insert(
        collection: _bookingCollection,
        data: data.toJson(),
      );
    } catch (e) {
      showToast("Booking failed: ${e.toString()}");
      return false;
    }
  }

  static Future<bool> delete({required String uid}) async {
    try {
      return await FirestoreService.deleteById(_bookingCollection, uid);
    } catch (e) {
      showToast("Delete failed: ${e.toString()}");
      return false;
    }
  }
}
