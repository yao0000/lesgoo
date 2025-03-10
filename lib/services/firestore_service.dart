import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> post(
    String collection,
    String id,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(id)
          .set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<DocumentSnapshot<Object?>> getItem(collection, String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collection).doc(id).get();

      if (doc.exists) {
        return doc;
      }
      else {
        throw Exception("No data found");
      }
    } catch (error) {
      rethrow;
    }
  }
}
