import 'package:travel/data/models/car_model.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/toast.dart';

class CarRepository {
  static final String _collection = "cars";

  static Future<List<CarModel>> getList() async {
    try {
      List<Map<String, dynamic>> data = await FirestoreService.getList(_collection);
      return data.map((map) => CarModel.fromJson(map)).toList();
    } catch (e) {
      showToast(e.toString());
    }
    return [];
  }
}
