import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/services/firebase_auth_service.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class TripRepository {
  static final String _collection = "trips";

  static Future<bool> post({required TripModel data}) async {
    try {
      Map<String, dynamic> listedModel = {
        Timestamp.now().millisecondsSinceEpoch.toString(): data.toJson(),
      };
      return await FirestoreService.post(
        _collection,
        AuthService.getCurrentUser()!.uid,
        listedModel,
      );
    } catch (e) {
      showToast("Failed ${e.toString()}");
      return false;
    }
  }

  static Future<bool> delete(String tripUid) async {
    try {
      FirebaseFirestore.instance
          .collection(_collection)
          .doc(AuthService.getCurrentUser()!.uid)
          .update({tripUid: FieldValue.delete()});
      return true;
    } catch (e) {
      showToast("Failed ${e.toString()}");
      return false;
    }
  }

  static Future<List<TripModel>> getList() async {
    try {
      DocumentSnapshot snapshot = await FirestoreService.getItem(
        _collection,
        AuthService.getCurrentUser()!.uid,
      );

      List<TripModel> trips = [];
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.isEmpty) {
        return [];
      }

      List<TripSchedule> schedules = [];

      for (var entry in data.entries) {
        schedules = [];
        if (entry.value is Map<String, dynamic> &&
            entry.value.containsKey("dayList")) {
          List<dynamic> dayListData = entry.value["dayList"];
          List<TripSchedule> dayList =
              dayListData.map((day) {
                return TripSchedule(
                  date: (day["date"] as Timestamp).toDate(),
                  detailsList:
                      (day["detailsList"] as List<dynamic>).map((detail) {
                        return TripDetails(
                          time: TimeOfDay(
                            hour: detail["time"] ~/ 3600,
                            minute: (detail["time"] % 3600) ~/ 60,
                          ),
                          task: detail["task"],
                        );
                      }).toList(),
                );
              }).toList();
          schedules.addAll(dayList);

          trips.add(
          TripModel(
            uid: entry.key,
            name: entry.value["name"] ?? "Unnamed Trip",
            startDate:
                entry.value["startDate"] != null
                    ? (entry.value["startDate"] as Timestamp).toDate()
                    : DateTime.now(),
            endDate:
                entry.value["endDate"] != null
                    ? (entry.value["endDate"] as Timestamp).toDate()
                    : DateTime.now(),
            budget: (entry.value["budget"] ?? 0.0).toDouble(), // Add this line
            dayList: schedules,
          ),
        );
        }
      }

      return trips;
    } catch (e) {
      if (e.toString() == "Exception: No data found") {
        return [];
      }
      showToast("Failed ${e.toString()}");
      return [];
    }
  }
}
