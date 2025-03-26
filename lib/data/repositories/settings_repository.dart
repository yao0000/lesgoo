import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/services/firestore_service.dart';
import 'package:travel/ui/widgets/widgets.dart';

class SettingsRepository {
  static final String _collection = "APP_Settings";

  static Future<List<String>> getCountryList() async {
    try {
      DocumentSnapshot data = await FirestoreService.getItem(_collection, "country_list");
      return (data['list'] as List<dynamic>).map((e) => e.toString()).toList();

    } catch (e) {
      showToast(e.toString());
    }
    return [];
  }
  
}