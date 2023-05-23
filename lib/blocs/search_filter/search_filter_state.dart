// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'search_filter_bloc.dart';

enum Filter { all, asia, africa, america, antartica, australia, europe }

class SearchFilterState extends Equatable {
  String searchTerm;
  Filter filter;
  List<dynamic> filteredTodo;

  SearchFilterState({
    required this.searchTerm,
    required this.filter,
    required this.filteredTodo,
  });

  factory SearchFilterState.initial() {
    return SearchFilterState(
        searchTerm: '', filter: Filter.all, filteredTodo: []);
  }

  @override
  List<Object> get props => [searchTerm, filter, filteredTodo];

  SearchFilterState copyWith({
    String? searchTerm,
    Filter? filter,
    List<dynamic>? filteredTodo,
  }) {
    return SearchFilterState(
      searchTerm: searchTerm ?? this.searchTerm,
      filter: filter ?? this.filter,
      filteredTodo: filteredTodo ?? this.filteredTodo,
    );
  }

  @override
  bool get stringify => true;
}
