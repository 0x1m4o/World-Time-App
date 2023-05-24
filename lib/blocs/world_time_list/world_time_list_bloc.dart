import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_time/data/models/time_data.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

part 'world_time_list_event.dart';
part 'world_time_list_state.dart';

class WorldTimeListBloc extends Bloc<WorlTimeListEvent, WorldTimeListState> {
  WorldTimeListBloc() : super(WorldTimeListState.initial()) {
    on<FetchWorldTimeList>((event, emit) async {
      final apiUrl =
          Uri.parse('https://world-time-app-nine.vercel.app/api/timezone');

      final response = await http.get(apiUrl, headers: {});
      print('Response ${response.statusCode}');
      if (response.statusCode == 200) {
        List<dynamic> timeData = json.decode(response.body);
        // print(timeData.cast<String>());
        emit(state.copyWith(timeData: timeData));
      }
    });
  }
}

class WorldTimeListModelsBloc
    extends Bloc<WorlTimeListEvent, WorldTimeListModelsState> {
  WorldTimeListModelsBloc() : super(WorldTimeListModelsState()) {
    on<ChangeWorldTimeList>((event, emit) {
      emit(state.copyWith(timeDataModels: state.timeDataModels));
    });
  }
}
