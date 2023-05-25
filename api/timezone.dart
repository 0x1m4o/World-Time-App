import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> handler() async {
  final apiUrl = 'https://timeapi.io/api/TimeZone/AvailableTimeZones';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.encode(response.body);
    }
  } catch (e) {
    print('Error: $e');
  }

  return null;
}
