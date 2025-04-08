import 'package:travel/data/models/flight_model.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/toast.dart';

class FlightRepository {
  static final String _collection = "flights";

  static Future<List<ScheduleModel>> getFlightSchedule() async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getList(
        _collection,
      );
      return data.map((map) => ScheduleModel.fromJson(map)).toList();
    } catch (e) {
      showToast(e.toString());
      return [];
    }
  }
}

class FlightBookingRepository {
  static final String _bookingCollection = "flightsBooking";

  static Future<bool> post({required FlightBookingModel data}) async {
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

  static Future<List<FlightBookingModel>> getListByUser(String userUid) async {
try {
      List<Map<String, dynamic>> data = await FirestoreService.getListByUser(
        _bookingCollection,
        userUid,
      );

      return data.map((map) => FlightBookingModel.fromJson(map)).toList();
    } catch (e) {
      showToast(e.toString());
    }
    return [];
  }
}
