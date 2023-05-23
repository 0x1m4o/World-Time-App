// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'world_time_list_bloc.dart';

abstract class WorlTimeListEvent extends Equatable {
  const WorlTimeListEvent();

  @override
  List<Object> get props => [];
}

class ChangeWorldTimeList extends WorlTimeListEvent {
  String countryName;
  ChangeWorldTimeList({
    required this.countryName,
  });

  factory ChangeWorldTimeList.initial() {
    return ChangeWorldTimeList(countryName: 'Asia/Jakarta');
  }

  ChangeWorldTimeList copyWith({
    String? countryName,
  }) {
    return ChangeWorldTimeList(
      countryName: countryName ?? this.countryName,
    );
  }

  @override
  bool operator ==(covariant ChangeWorldTimeList other) {
    if (identical(this, other)) return true;

    return other.countryName == countryName;
  }

  @override
  int get hashCode => countryName.hashCode;

  @override
  String toString() => 'ChangeWorldTimeList(countryName: $countryName)';
}

class FetchWorldTimeList extends WorlTimeListEvent {}
