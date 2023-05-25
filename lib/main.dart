import 'dart:convert';

import 'package:flutter/material.dart' hide Router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_time/blocs/search_filter/search_filter_bloc.dart';
import 'package:world_time/blocs/world_time_list/world_time_list_bloc.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/loading.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
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
      },
    ),
  ));
  final router = _router();

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(router);

  io.serve(handler, 'localhost', 3000);
}

Router _router() {
  final router = Router();

  router.get('/api/time', (shelf.Request request) async {
    final timeZone = request.url.queryParameters['timeZone'] ?? 'Asia/Jakarta';
    final apiUrl =
        'https://timeapi.io/api/Time/current/zone?timeZone=$timeZone';

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

        return shelf.Response.ok(json.encode(timeData),
            headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      print('Error: $e');
    }

    return shelf.Response.internalServerError();
  });

  router.get('/api/timezone', (shelf.Request request) async {
    final apiUrl = 'https://timeapi.io/api/TimeZone/AvailableTimeZones';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return shelf.Response.ok(response.body,
            headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      print('Error: $e');
    }

    return shelf.Response.internalServerError();
  });

  return router;
}
