import 'dart:convert';
import 'package:http/http.dart' as http;

class FlightService {
  static const String apiUrl = "https://google-flights2.p.rapidapi.com/api/v1/searchFlights";
  static const Map<String, String> headers = {
    "x-rapidapi-key": "YOUR_RAPIDAPI_KEY", // Replace with your API Key
    "x-rapidapi-host": "google-flights2.p.rapidapi.com",
    "Content-Type": "application/json"
  };

  static Future<Map<String, dynamic>?> fetchFlights({
    required String from,
    required String to,
    required String date,
    String currency = "USD",
    int adults = 1,
    String cabinClass = "economy",
  }) async {
    final Map<String, dynamic> requestBody = {
      "from": from, // Example: "KUL" (Kuala Lumpur)
      "to": to, // Example: "LHR" (London Heathrow)
      "date": date, // Format: YYYY-MM-DD
      "currency": currency,
      "adults": adults,
      "cabinClass": cabinClass,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (error) {
      print("Request failed: $error");
      return null;
    }
  }
}
