import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel/data/models/hotel_model.dart';
import 'package:travel/services/firebase_storage_service.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/toast.dart';
import 'package:path/path.dart' as path;

class HotelRepository {
  static final String _collection = "hotels";

  static Future<bool> post({required HotelModel data}) async {
    try {
      return await FirestoreService.post(_collection, data.uid, data.toJson());
    } catch (e) {
      showToast("Save failed: ${e.toString()}");
      return false;
    }
  }

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

  static Future<bool> delete({required String uid}) async {
    try {
      return await FirestoreService.deleteById(_collection, uid);
    } catch (e) {
      showToast("Delete failed: ${e.toString()}");
      return false;
    }
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

  static Future<String> uploadPhoto({
    required XFile xFile,
    required String filename,
  }) async {
    File file = File(xFile.path);
    try {
      return await FirebaseStorageService.uploadFile(
        _collection,
        file,
        fileName: '$filename${path.extension(file.path)}',
      );
    } catch (e) {
      showToast(e.toString());
      return '';
    }
  }
}

class HotelBookingRepository {
  static final String _bookingCollection = "hotelsBooking";

  static Future<List<HotelBookingModel>> getListByHotelId(
    String hotelUid,
  ) async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getListByItemUid(
        collection: _bookingCollection,
        itemUid: hotelUid,
      );
      return data.map((map) => HotelBookingModel.fromJson(map)).toList();
    } catch (e) {
      if (e.toString() == "Exception: No data found") {
        return [];
      }
      showToast(e.toString());
    }
    return [];
  }

  static Future<List<HotelBookingModel>> getListByUser(String userUid) async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getListByUser(
        _bookingCollection,
        userUid,
      );

      return data.map((map) => HotelBookingModel.fromJson(map)).toList();
    } catch (e) {
      if (e.toString() == "Exception: No data found") {
        return [];
      }
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
