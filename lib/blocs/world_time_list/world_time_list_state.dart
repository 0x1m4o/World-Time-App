// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'world_time_list_bloc.dart';

class WorldTimeListState extends Equatable {
  List<dynamic> timeData;
  WorldTimeListState({
    required this.timeData,
  });

  factory WorldTimeListState.initial() {
    return WorldTimeListState(timeData: []);
  }

  @override
  List<Object> get props => [timeData];

  @override
  bool get stringify => true;

  WorldTimeListState copyWith({
    List<dynamic>? timeData,
  }) {
    return WorldTimeListState(
      timeData: timeData ?? this.timeData,
    );
  }
}

class WorldTimeListModelsState extends Equatable {
  TimeData? timeDataModels;
  WorldTimeListModelsState({
    this.timeDataModels,
  });

  @override
  List<Object> get props => [timeDataModels!];

  @override
  bool get stringify => true;

  WorldTimeListModelsState copyWith({
    TimeData? timeDataModels,
  }) {
    return WorldTimeListModelsState(
      timeDataModels: timeDataModels ?? this.timeDataModels,
    );
  }
}
