import 'package:travel/data/models/restaurant_model.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class RestaurantRepository {
  static final String collection = "restaurants";

  static Future<List<RestaurantModel>?> getList() async {
    try{
      List<Map<String, dynamic>> data = await FirestoreService.getList(collection);

      return data.map((map) => RestaurantModel.fromJson(map)).toList();
    }catch(e){
      showToast(e.toString());
    }
    return null;
  }
}
