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

  static Future<bool> insert({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).add(data);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<DocumentSnapshot<Object?>> getItem(
    collection,
    String id,
  ) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collection).doc(id).get();

      if (doc.exists) {
        return doc;
      } else {
        throw Exception("No data found");
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getListByUser(
    String collection,
    String userUid,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> doc =
          await _firestore
              .collection(collection)
              .where("userUid", isEqualTo: userUid)
              .get();

      if (doc.docs.isEmpty) {
        throw Exception("No data found");
      }

      return doc.docs.map((doc) {
        Map<String, dynamic> docData = doc.data();
        docData['uid'] = doc.id;
        return docData;
      }).toList();
      
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getList(String collection) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collection).get();
      List<Map<String, dynamic>> data =
          snapshot.docs.map((doc) {
            Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
            docData['uid'] = doc.id;
            return docData;
          }).toList();

      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> delete(
    String collection,
    String docId,
    String subDocId,
  ) async {
    try {
      String doc = docId + (subDocId.isEmpty ? "" : "/$subDocId");
      //await _firestore.collection(collection).doc(doc).delete();
      _firestore.collection(collection).doc(doc).collection('').doc().delete();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // real-time listener
  static Stream<DocumentSnapshot<Object?>> itemListener(
    String collection,
    String id,
  ) {
    return _firestore.collection(collection).doc(id).snapshots();
  }
}
