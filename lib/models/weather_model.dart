class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double minTemp;
  final double maxTemp;

  Weather({
    required this.cityName,
    required this.mainCondition,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      maxTemp: json['main']['temp_max'].toDouble(),
      minTemp: json['main']['temp_min'].toDouble(),
    );
  }
}
