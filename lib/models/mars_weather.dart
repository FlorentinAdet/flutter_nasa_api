class MarsWeather {
  final double? temperature;
  final double? pressure;
  final double? windSpeed;
  final String? windDirection;

  MarsWeather({
    required this.temperature,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
  });

  factory MarsWeather.fromJson(Map<String, dynamic> json) {
    return MarsWeather(
      temperature: json['AT']?['av']?.toDouble(),
      pressure: json['PRE']?['av']?.toDouble(),
      windSpeed: json['HWS']?['av']?.toDouble(),
      windDirection: json['WD']?['most_common']?['compass_point'],
    );
  }
}
