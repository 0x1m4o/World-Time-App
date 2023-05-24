import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:world_time/blocs/world_time_list/world_time_list_bloc.dart';
import 'package:world_time/data/models/time_data.dart';

class WorldTime {
  String? url; // URL Location for the API Endpoint
  String? time; // The time in that location
  bool? isDayTime;

  WorldTime({this.url = 'Asia/Jakarta'});

  Future<void> getTime() async {
    Uri apiUrl = Uri.parse('http://localhost:3000/api/time');

    try {
      var response = await http.get(apiUrl, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Methods": "GET,OPTIONS,PATCH,DELETE,POST,PUT",
        "Access-Control-Allow-Headers":
            "X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version",
        "Access-Control-Max-Age": "600"
        // HttpHeaders.authorizationHeader: "Jqt4v5pnSiqUM9lAF2sPRC0Z",
        // "key": "Access-Control-Allow-Origin", "value": "*"
        // "Content-Type": "application/json", 'Accept': 'application/json',
        // "Authorization": "Jqt4v5pnSiqUM9lAF2sPRC0Z",
        // "Access-Control-Allow-Origin": "*"
      });
      var data = json.decode(response.body);
      print(data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Get Properties from data

        String datetime = data['dateTime'];

        int hour = data['hour'];

        DateTime now = DateTime.parse(datetime);
        print(hour);
        isDayTime = hour > 6 && hour < 20 ? true : false;
        print(isDayTime);
        time = DateFormat.jm().format(now);

        await WorldTimeListModelsState(
            timeDataModels: TimeData(
                countryName: url!,
                countryTime: time!,
                continent: url!,
                isDayTime: isDayTime!));
      }
    } catch (e) {
      print('Caught error $e');
    }
  }
}
