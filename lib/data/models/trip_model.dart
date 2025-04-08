import 'package:flutter/material.dart';

class TripModel {
  String? uid;
  String name;
  DateTime startDate;
  DateTime endDate;
  List<TripSchedule> dayList;

  TripModel({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.dayList,
    this.uid
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'startDate': startDate.toUtc(),
      'endDate': endDate.toUtc(),
      'dayList': dayList.map((day) => day.toJson()).toList(),
    };
  }

  bool isAnyNull() {
    for (TripSchedule schedule in dayList) {
      if (schedule.isAnyNull()) {
        return true;
      }
    }

    return false;
  }
}

class TripSchedule {
  DateTime? date;
  List<TripDetails>? detailsList;

  TripSchedule({this.date, List<TripDetails>? detailsList})
    : detailsList = detailsList ?? List.generate(3, (_) => TripDetails());

  Map<String, dynamic> toJson() {
    return {
      'date': date!.toUtc(),
      'detailsList': detailsList!.map((detail) => detail.toJson()).toList(),
    };
  }

  bool isAnyNull() {
    if (date == null) {
      return true;
    }
    if (detailsList == null) {
      return true;
    }
    for (TripDetails item in detailsList!) {
      if (item.isAnyNull()) {
        return true;
      }
    }
    return false;
  }
}

class TripDetails {
  TimeOfDay? time;
  String? task;

  TripDetails({this.time, this.task});

  Map<String, dynamic> toJson() {
    return {'time': time!.hour * 3600 + time!.minute * 60, 'task': task};
  }

  bool isAnyNull() {
    return time == null || task == null;
  }
}
