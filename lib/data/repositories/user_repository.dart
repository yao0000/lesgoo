import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/models/user_model.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/services/firebase_storage_service.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class UserRepository {
  static final String collection = "users";

  static Future<void> save(String id, Map<String, dynamic> data) async {
    try {
      await FirestoreService.post(
        collection,
        AuthService.getCurrentUser()!.uid,
        data,
      );
    } catch (e) {
      showToast(e.toString());
    }
  }

  static Future<UserModel?> getUser(String id) async {
    try {
      DocumentSnapshot doc = await FirestoreService.getItem(collection, id);
      UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      return user;
    } catch (e) {
      showToast(e.toString());
    }
    return null;
  }

  // Fetch user as a stream for real-time updates
  static Stream<UserModel?> getUserStream(String id) {
    return FirestoreService.itemListener(collection, id).map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  static Future<String> uploadPhoto(File file) async {
    String fileName =
        AuthService.getCurrentUser()!.uid + path.extension(file.path);
    String url = await FirebaseStorageService.uploadFile(
      collection,
      file,
      fileName: fileName,
    );
    return url;
  }

  static Future<bool> update() async {
    return await FirestoreService.updateDocument(
      collection,
      AuthService.getCurrentUser()!.uid,
      Global.user.toJson(),
    );
  }

  static Future<bool> delete({required String userUid}) async {
    try {
      final HttpsCallable services = FirebaseFunctions.instance.httpsCallable(
        "deleteUserById",
      );
      await services.call(<String, dynamic>{'uid': userUid});
      await FirestoreService.deleteById(collection, userUid);
      return true;
    } catch (e) {
      showToast(e.toString());
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  static Future<List<UserModel>> getList() async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getList(
        collection,
      );
      return data.map((map) => UserModel.fromJson(map)).toList();
    } catch (e) {
      showToast(e.toString());
      return [];
    }
  }
}
