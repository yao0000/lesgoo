import 'package:travel/data/models/airport_model.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class AirportRepository {
  static final String collection = "airports";

  static Future<List<AirportModel>?> getList() async {
    try{
      List<Map<String, dynamic>> data = await FirestoreService.getList(collection);

      return data.map((map) => AirportModel.fromJson(map)).toList();
    }catch(e){
      showToast(e.toString());
    }
    return null;
  }
}
