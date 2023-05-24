import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:world_time/blocs/world_time_list/world_time_list_bloc.dart';

part 'search_filter_event.dart';
part 'search_filter_state.dart';

class SearchFilterBloc extends Bloc<SearchFilterEvent, SearchFilterState> {
  final WorldTimeListBloc worldTimeListBloc;

  late StreamSubscription streamSubscription;
  SearchFilterBloc({required this.worldTimeListBloc})
      : super(SearchFilterState.initial()) {
    streamSubscription = worldTimeListBloc.stream
        .listen((WorldTimeListState worldTimeListState) {
      setFilterAndSearch(Filter.all, '');
    });

    // on<SearchEvent>((event, emit) {
    //   emit(state.copyWith(searchTerm: event.searchTerm, filter: event.filter));
    // });
  }

  void setFilterAndSearch(Filter filter, String searchTerm) {
    // Created a switch case for different filter.

    List<dynamic> filteredList;
    switch (filter) {
      // If the Filter tab is 'active'.
      case Filter.africa:
        // We filter out the todo that do not completed
        filteredList = worldTimeListBloc.state.timeData
            .where((value) => value.contains('Africa'))
            .toList();

        break;
      case Filter.asia:
        // We filter out the todo that do not completed
        filteredList = worldTimeListBloc.state.timeData
            .where((value) => value.contains("Asia"))
            .toList();

        break;
      case Filter.america:
        // We filter out the todo that do not completed
        filteredList = worldTimeListBloc.state.timeData
            .where((value) => value.contains('America'))
            .toList();

        break;
      case Filter.australia:
        // We filter out the todo that do not completed
        filteredList = worldTimeListBloc.state.timeData
            .where((value) => value.contains('Australia'))
            .toList();

        break;
      case Filter.antartica:
        // We filter out the todo that do not completed
        filteredList = worldTimeListBloc.state.timeData
            .where((value) => value.contains('Antartica'))
            .toList();

        break;
      case Filter.europe:
        // We filter out the todo that do not completed
        filteredList = worldTimeListBloc.state.timeData
            .where((value) => value.contains('Europe'))
            .toList();

        break;

      // If the Filter tab is 'all'.
      // We include all of todo list.
      case Filter.all:
      default:
        filteredList = worldTimeListBloc.state.timeData;
        break;
    }

    // After that we make sure that is textfield is not empty. If it is not empty. We filter again based on the value on the textfields.
    filteredList = filteredList
        .where(
            (value) => value.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    emit(state.copyWith(filteredTodo: filteredList));
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
