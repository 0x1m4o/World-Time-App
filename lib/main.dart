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
      },
    ),
  ));
}
