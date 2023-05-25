import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_time/blocs/search_filter/search_filter_bloc.dart';
import 'package:world_time/blocs/world_time_list/world_time_list_bloc.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/loading.dart';

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
        child: Text('Handle API call for timeZone: $timeZone'),
      ),
    );
  }
}

class ApiTimeZoneHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Handle the API call for /api/timezone
    // You can use the WorldTime class or any other approach to handle the logic

    return Scaffold(
      body: Center(
        child: Text('Handle API call for /api/timezone'),
      ),
    );
  }
}
