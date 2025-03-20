import 'dart:io';

import 'package:travel/data/models/hotel_model.dart';
import 'package:travel/services/firebase_storage_service.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/toast.dart';

class HotelRepository {
  static final String collection = "hotels";

  static Future<List<HotelModel>?> getList() async {
    try{
      List<Map<String, dynamic>> data = await FirestoreService.getList(collection);
      return data.map((map) => HotelModel.fromJson(map)).toList();
    } catch(e){
      showToast(e.toString());
    }
    return null;
  }

  static Future<String?> uploadImage(File file) async{
    return await FirebaseStorageService.uploadFile(collection, file);
  }


}
