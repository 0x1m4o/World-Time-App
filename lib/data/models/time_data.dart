// ignore_for_file: public_member_api_docs, sort_constructors_first
class TimeData {
  String countryName;
  String countryTime;
  String continent;
  bool isDayTime;
  TimeData({
    required this.countryName,
    required this.countryTime,
    required this.continent,
    required this.isDayTime,
  });

  TimeData copyWith({
    String? countryName,
    String? countryTime,
    String? continent,
    bool? isDayTime,
  }) {
    return TimeData(
      countryName: countryName ?? this.countryName,
      countryTime: countryTime ?? this.countryTime,
      continent: continent ?? this.continent,
      isDayTime: isDayTime ?? this.isDayTime,
    );
  }

  @override
  String toString() {
    return 'TimeData(countryName: $countryName, countryTime: $countryTime, continent: $continent, isDayTime: $isDayTime)';
  }

  @override
  bool operator ==(covariant TimeData other) {
    if (identical(this, other)) return true;

    return other.countryName == countryName &&
        other.countryTime == countryTime &&
        other.continent == continent &&
        other.isDayTime == isDayTime;
  }

  @override
  int get hashCode {
    return countryName.hashCode ^
        countryTime.hashCode ^
        continent.hashCode ^
        isDayTime.hashCode;
  }
}
