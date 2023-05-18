import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String? time; // The time in that location
  String? url; // URL Location for the API Endpoint
  bool? isDayTime;

  WorldTime({this.url});

  Future<void> getTime() async {
    Uri apiUrl =
        Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=$url');

    try {
      var response = await http.get(apiUrl);
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        // Get Properties from data

        String datetime = data['dateTime'];

        int hour = data['hour'];

        DateTime now = DateTime.parse(datetime);

        isDayTime = hour > 6 && hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
      }
    } catch (e) {
      print('Caught error $e');
    }
  }
}

WorldTime instance = WorldTime(
  url: 'Asia/Jakarta',
);
