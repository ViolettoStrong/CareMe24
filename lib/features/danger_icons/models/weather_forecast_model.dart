class WeatherData {
  final String dateTime;
  final num temperature;

  WeatherData({required this.dateTime, required this.temperature});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      dateTime: json['dt_txt'] ?? '',
      temperature: json['main']?['temp'] ?? 0,
    );
  }
}

class WeatherForecast {
  final bool haveData;
  final num currentTemperature;
  final List<WeatherData> forecast;

  WeatherForecast(
      {required this.currentTemperature,
      required this.forecast,
      required this.haveData});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    List<WeatherData> forecastList = (json['list'] as List)
        .map((item) => WeatherData.fromJson(item))
        .toList();

    num currentTemp = forecastList[0].temperature;

    return WeatherForecast(
      haveData: true,
      currentTemperature: currentTemp,
      forecast: forecastList,
    );
  }
}
