import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:travel/data/models/car_model.dart';
import 'package:travel/services/firebase_storage_service.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/toast.dart';

class CarRepository {
  static final String _collection = "cars";

  static Future<bool> post({required CarModel data}) async {
    try {
      return await FirestoreService.post(_collection, data.uid, data.toJson());
    } catch (e) {
      showToast("Save failed: ${e.toString()}");
      return false;
    }
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

  static Future<CarModel?> getItem(String uid) async {
    try {
      DocumentSnapshot doc = await FirestoreService.getItem(_collection, uid);
      CarModel data = CarModel.fromJson(doc.data() as Map<String, dynamic>);
      return data;
    } catch (e) {
      showToast(e.toString());
    }
    return null;
  }

  static Future<List<CarModel>> getList() async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getList(
        _collection,
      );
      return data.map((map) => CarModel.fromJson(map)).toList();
    } catch (e) {
      showToast(e.toString());
    }
    return [];
  }
}

class CarBookingRepository {
  static final String _bookingCollection = "carsBooking";

  static Future<List<CarBookingModel>> getListById(String uid) async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getListByItemUid(
        collection: _bookingCollection,
        itemUid: uid,
      );
      return data.map((map) => CarBookingModel.fromJson(map)).toList();
    } catch (e) {
      if (e.toString() == "Exception: No data found") {
        return [];
      }
      showToast(e.toString());
    }
    return [];
  }

  static Future<List<CarBookingModel>> getListByUser(String userUid) async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getListByUser(
        _bookingCollection,
        userUid,
      );

      return data.map((map) => CarBookingModel.fromJson(map)).toList();
    } catch (e) {
      if (e.toString() == "Exception: No data found") {
        return [];
      }
      showToast(e.toString());
    }
    return [];
  }

  static Future<bool> post({required CarBookingModel data}) async {
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
