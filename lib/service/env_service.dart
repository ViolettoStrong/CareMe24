import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  late String apiUrl;
  late String openWeatherUrl;
  late String openMeteoUrl;

  EnvService._privateConstructor();

  static final EnvService _instance = EnvService._privateConstructor();

  factory EnvService() {
    return _instance;
  }
  Future<void> loadEnv() async {
    await dotenv.load(fileName: "assets/env.txt");
    setValue();
  }

  void setValue() {
    apiUrl = dotenv.env['API_URL'] ?? '';
    if (apiUrl.isEmpty) {
      throw Exception("API_URL не найден в .env файле");
    }
    openWeatherUrl = dotenv.env['OPENWEATHER_URL'] ?? '';
    if (openWeatherUrl.isEmpty) {
      throw Exception("OPENWEATHER_URL не найден в .env файле");
    }
    openMeteoUrl = dotenv.env['OPENMETEO_URL'] ?? '';
    if (openMeteoUrl.isEmpty) {
      throw Exception("OPENMETEO_URL не найден в .env файле");
    }
  }
}
