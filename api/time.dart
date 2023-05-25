import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> handler(Map<String, dynamic> query) async {
  final timeZone = query['timeZone'] ?? 'Asia/Jakarta';
  final apiUrl = 'https://timeapi.io/api/Time/current/zone?timeZone=$timeZone';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      final dateTime = data['date_time'];
      final hour = data['hour'];
      final isDayTime = hour > 6 && hour < 20;

      final timeData = {
        'dateTime': dateTime,
        'hour': hour,
        'isDayTime': isDayTime,
      };

      return json.encode(timeData);
    }
  } catch (e) {
    print('Error: $e');
  }

  return null;
}
