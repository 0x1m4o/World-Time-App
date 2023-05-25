import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_time/blocs/search_filter/search_filter_bloc.dart';
import 'package:world_time/blocs/world_time_list/world_time_list_bloc.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/loading.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => WorldTimeListBloc(),
      ),
      BlocProvider(
        create: (context) => SearchFilterBloc(
            worldTimeListBloc: context.read<WorldTimeListBloc>()),
      )
    ],
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/location': (context) => ChooseLocation(),
        '/api/time': (context) => ApiTimeHandler(),
        '/api/timezone': (context) =>
            ApiTimeZoneHandler(), // New route handler for /api/timezone
      },
    ),
  ));
}

class ApiTimeHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final String? timeZone = params['timeZone'];

    if (timeZone == null) {
      return Scaffold(
        body: Center(
          child: Text('Missing timeZone query parameter'),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: fetchTimeData(timeZone),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('Time Data: ${snapshot.data}');
            }
          },
        ),
      ),
    );
  }

  Future<String> fetchTimeData(String timeZone) async {
    final url = 'https://timeapi.io/api/Time/current/zone?timeZone=$timeZone';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['dateTime'];
    } else {
      throw Exception('Failed to fetch time data');
    }
  }
}

class ApiTimeZoneHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: fetchTimeZones(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final timeZones = snapshot.data;
              return ListView.builder(
                itemCount: timeZones!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(timeZones[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<String>> fetchTimeZones() async {
    final url = 'https://timeapi.io/api/TimeZone/AvailableTimeZones';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to fetch time zones');
    }
  }
}
