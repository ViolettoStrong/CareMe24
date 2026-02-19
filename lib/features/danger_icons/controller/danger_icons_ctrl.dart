import 'dart:developer';
import 'dart:io';

import 'package:careme24/features/danger_icons/domain/danger_icon_props_usecase.dart';
import 'package:careme24/features/danger_icons/domain/danger_icons_data.dart';
import 'package:careme24/features/danger_icons/models/air_pollution_model.dart';
import 'package:careme24/features/danger_icons/models/danger_model.dart';
import 'package:careme24/features/danger_icons/models/pressure_wind_model.dart';
import 'package:careme24/features/danger_icons/models/weather_forecast_model.dart';
import 'package:careme24/repositories/dangerous_repository.dart';
import 'package:careme24/service/token_storage.dart';
import 'package:careme24/widgets/dangerous_icons/air_pollution.dart';
import 'package:careme24/widgets/dangerous_icons/pressure.dart';
import 'package:careme24/widgets/dangerous_icons/temperature.dart';
import 'package:careme24/widgets/dangerous_icons/widgets/info_icon.dart';
import 'package:careme24/widgets/dangerous_icons/wind.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

bool newIconsShownThisSession = true;

class DangerIconsCtrl with ChangeNotifier {
  SharedPreferences? sharedPreferences;
  WebSocketChannel? channel;

  List<DangerModel> _fetchedIcons = [];

  List<DangerModel> _defaultIcons = [];
  List<String> _fetchedLastIcons = [];
  List<String> _deletedIcons = [];

  List<DangerModel> icons = [];
  List<DangerModel> newIcons = [];
  List<DangerModel> notifIcons = [];
  String city = '';

  List<Map<String, dynamic>> _iconsData = [];
  List<Map<String, dynamic>> _weatherIconsData = [];

  late AirQualityResponse airQuality;
  late WeatherForecast weatherForecast;
  late PressureAndWindData pressureAndWind;

  DangerIconsCtrl() {
    init();
  }

  init() {
    airQuality = AirQualityResponse(
      list: [],
      haveData: false,
    );

    weatherForecast = WeatherForecast(
      currentTemperature: 0,
      forecast: [],
      haveData: false,
    );

    pressureAndWind = PressureAndWindData(
      currentPressure: 0,
      currentWindSpeed: 0,
      currentWindDirection: 0,
      pressureList: [],
      date: [],
      windDirectionList: [],
      windSpeedList: [],
      haveData: false,
    );
    final Map<String, String> dangerLevelsByType = {
      "Солнечная радиация": "В норме",
      "Радиактивный фон": "В норме",
      "Электромагнитное излучение": "В норме",
      "Аллерген": 'В норме',

      "Цунами": "Не активно",
      "Торнадо смерч": "Безопасно",
      "Землятрясение": "Безопасно",
      "Крупный град": "Не активно",
      "Гололёд": "Не активно",
      "Сильный туман": "Не активно",
      "Снежная лавина": "Не активно",
      "Камнепад / Оползень": "Не активно",
      "Извержение вулкана": "Не активно",
      "Пожар": "Безопасно",
      "Наводнение": "Безопасно",
      "Террористическая опасность": "Безопасно",
      "Воздушная тревога": "Безопасно",
      "Химическое заражение": "Безопасно",
      "Вирусное / бактериологическое заражение": "Безопасно",
    };

    _defaultIcons = [];
    for (var d in dataIcons) {
      final type = d['incident_type']?.toString() ?? '';
      final dangerLevel =
          dangerLevelsByType[type] ?? 'Безопасно'; // default value

      _defaultIcons.add(DangerModel(
        incidentType: type,
        country: 'country',
        city: 'city',
        comment: 'comment',
        type: 'type',
        dangerLevel: dangerLevel,
      ));
    }
    _defaultIcons.add(DangerModel(
      incidentType: "Аллерген",
      country: 'country',
      city: 'city',
      comment: 'comment',
      type: 'type',
      dangerLevel: "В норме",
    ));
    _sortIcons();
  }

  initDangerIcons() async {
    try {
      String? token = await TokenManager.getToken();

      channel?.sink.close();
      channel = null;

      final wsUrl = Uri.parse(
          'ws://v2290783.hosted-by-vdsina.ru/api/location/ws?token=$token');
      channel = WebSocketChannel.connect(wsUrl);

      await channel?.ready;

      channel?.stream.listen(
        _onMessage,
        onError: (error) {
          debugPrint("WebSocket Error: $error");
        },
        onDone: () {
          debugPrint("WebSocket connection closed");
        },
      );
    } on WebSocketException catch (e) {
      debugPrint(e.message);
      debugPrint('Error initializing danger icons: ${e.toString()}');
    }
  }

  _onMessage(message) async {
    final msg = json.decode(message);
    // log(msg.toString());
    if (msg['type'] == 'initial_zones' && msg['data'] != null) {
      // Position? location = await _getPosition();
      _fetchedIcons = List<DangerModel>.from(
        msg['data'].map(
          (e) => DangerModel.fromJson(
            e,
            isAct: false,
          ),
        ),
      );
      // print(_fetchedIcons.length);

      log("initial icons len: ${_fetchedIcons.length}");
      await _checkForNewIcons();
      _sortIcons();
    }
    if (msg['type'] == 'location_update' && msg['data']?['zones'] != null) {
      // print(_fetchedIcons.length);
      // print(msg);
      _fetchedIcons = List<DangerModel>.from(
        msg['data']['zones'].map(
          (e) => DangerModel.fromJson(
            e,
            isAct: true,
          ),
        ),
      );

      print(_fetchedIcons.length);

      await _checkForNewIcons();
      _sortIcons();
    }
  }

  _sendPosition(double? lat, double? lon) async {
    try {
      Position location = await Geolocator.getCurrentPosition();
      channel?.sink.add(
        json.encode({
          'lat': location.latitude,
          'lng': location.longitude,
        }),
      );
      print('sent position: ${location.latitude}, ${location.longitude}');
    } catch (e) {
      debugPrint('Error sending position: ${e.toString()}');
    }
  }

  String getGololodLevel(double temperatur) {
    
    if ((temperatur >= 1 && temperatur <= 4) ||
        (temperatur >= -15 && temperatur <= -10)) {
      return 'Повышенный';
    } else if (temperatur < 1 && temperatur > -10) {
      return 'Опасный';
    } else {
      return 'Не активно';
    }
  }

  Future<Position?> _getPosition() async {
    try {
      Position location = await Geolocator.getCurrentPosition();
      log('Current position: lat: ${location.latitude}, lon: ${location.longitude}');
      return location;
    } catch (e) {
      debugPrint('Error getting position: ${e.toString()}');
      return null;
    }
  }

  fetchData({
    required double lat,
    required double lon,
    required String city,
  }) async {
    this.city = city;
    try {
      _sendPosition(lat, lon);
      // _fetchedIcons = await Api.getDangerIcons({'lat': lat, 'lon': lon});
      // //test 1

      // // if (_fetchedIcons.length > 3) {
      // //   _fetchedIcons[0].isActive = true;
      // //   _fetchedIcons[2].isActive = true;
      // // }

      // //
      // _fetchedIcons = _fetchedIcons
      //     .where(
      //       (element) => element.isActive,
      //     )
      //     .toList();

      airQuality = await DangerousInfoRepository.fetchAirPollution({
        'lat': lat,
        'lon': lon,
        'appid': 'bc8da4c6dae7528e50d211256438d6fd',
      });

      weatherForecast = await DangerousInfoRepository.fetchWeather({
        'lat': lat,
        'lon': lon,
        'appid': 'bc8da4c6dae7528e50d211256438d6fd',
        'units': 'metric',
      });
      final gololodLevel = getGololodLevel(
        weatherForecast.currentTemperature.toDouble(),
      );

      _fetchedIcons.removeWhere((e) => e.incidentType == 'Гололёд');
      if (gololodLevel == 'Повышенный' || gololodLevel == 'Опасный') {
        _fetchedIcons.add(
          DangerModel(
            incidentType: 'Гололёд',
            country: 'country',
            city: city,
            comment: 'Температурные условия',
            type: 'weather',
            dangerLevel: gololodLevel,
            isActive: true,
          ),
        );
      }

      pressureAndWind = await DangerousInfoRepository.fetchPressure({
        'latitude': lat,
        'longitude': lon,
        'hourly': 'pressure_msl,wind_speed_10m,wind_direction_10m',
        'forecast_days': 7,
      });

      int airPollutionIndex =
          airQuality.list.isNotEmpty ? airQuality.list[0].aqi : 0;
      int temperatureIndex =
          getTempIndex(weatherForecast.currentTemperature.toInt());
      int pressureIndex =
          getPressureIndex(pressureAndWind.currentPressure.toInt());
      int windIndex = getSpeedIndex(pressureAndWind.currentWindSpeed);
      for (var icon in _defaultIcons) {
        if (icon.incidentType == "Гололёд") {
          final level = getGololodLevel(
            weatherForecast.currentTemperature.toDouble(),
          );
          _defaultIcons[_defaultIcons.indexOf(icon)] = DangerModel(
            incidentType: icon.incidentType,
            country: icon.country,
            city: icon.city,
            comment: icon.comment,
            type: icon.type,
            dangerLevel: level,
            isActive: level != 'Не активно',
          );
          break;
        }
      }

      _weatherIconsData = [
        {
          'widget': AirPollutionIcon(
            airQualityResponse: airQuality,
            city: city,
          ),
          'index': airPollutionIndex,
          'isActive': true,
        },
        {
          'widget': TemperatureIcon(
            weatherForecast: weatherForecast,
            city: city,
          ),
          'index': temperatureIndex,
          'isActive': true,
        },
        {
          'widget': PressureIcon(
            pressureAndWindData: pressureAndWind,
            city: city,
          ),
          'index': pressureIndex,
          'isActive': true,
        },
        {
          'widget': WindIcon(
            pressureAndWindData: pressureAndWind,
            city: city,
          ),
          'index': windIndex,
          'isActive': true,
        }
      ];

      // if (iconsData.isEmpty) {
      //   iconsData = List.from(weatherIconsData);
      // }
      // await _checkForNewIcons();
      // _sortIcons();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  int _getOrderByDangerLevel(String level) {
    if (level == 'В норме') return 0;
    if (level == 'Не активно') return 2;
    if (level == 'Безопасно') return 1;
    return 3; // fallback
  }

  _sortIcons() {
    _fetchedIcons.sort((a, b) => a.dangerIndex.compareTo(b.dangerIndex));

    icons = List.from(_defaultIcons);
    for (int i = 0; i < _fetchedIcons.length; i++) {
      for (int j = 0; j < icons.length; j++) {
        if (_fetchedIcons[i].incidentType == icons[j].incidentType) {
          icons[j] = _fetchedIcons[i];
        }
      }
    }

    _iconsData.clear();
    for (var icon in icons) {
      _iconsData.add({
        'widget': InfoIcon(
          icon: icon,
          city: icon.city,
        ),
        'index': getDangerIndex(icon.dangerLevel),
        'isActive': icon.isActive,
      });
    }

    _iconsData.sort((a, b) {
      final orderA = _getOrderByDangerLevel(
        (a['widget'] as InfoIcon).icon.dangerLevel,
      );
      final orderB = _getOrderByDangerLevel(
        (b['widget'] as InfoIcon).icon.dangerLevel,
      );
      return orderA.compareTo(orderB);
    });

    print('iconsdata length: ${_iconsData.length}');
    notifyListeners();
  }

  _checkForNewIcons() async {
    sharedPreferences ??= await SharedPreferences.getInstance();

    _fetchedLastIcons = sharedPreferences!.getStringList('lastIcons') ?? [];

    for (var icon in _fetchedIcons) {
      if (!_fetchedLastIcons.contains(icon.incidentType)) {
        newIcons.add(icon);
      }
    }
    sharedPreferences!.setStringList(
      'lastIcons',
      _fetchedIcons.map((e) => e.incidentType).toList(),
    );

    notifIcons = List.from(_fetchedIcons);
    if (newIconsShownThisSession) {
      newIcons = List.from(_fetchedIcons);
    } else {
      newIcons.clear();
    }
  }

  removeDangerNotification(String type) async {
    notifIcons.removeWhere((element) => element.incidentType == type);
    notifyListeners();

    _deletedIcons.add(type);
    sharedPreferences ??= await SharedPreferences.getInstance();
    sharedPreferences!.setStringList('deletedDangerIcons', _deletedIcons);
  }

  removeNewDangerIcon(String type) {
    newIcons.removeWhere((element) => element.incidentType == type);
    notifyListeners();
  }

  List<Map<String, dynamic>> get iconsData {
    List<Map<String, dynamic>> icons = [
      ..._weatherIconsData,
      ..._iconsData,
    ];

    icons.sort((a, b) {
      if (a['isActive'] == b['isActive']) {
        return b['index']
            .compareTo(a['index']); // Sort by index if isActive is the same
      }
      return a['isActive'] ? -1 : 1; // isActive = true comes first
    });

    return icons;
  }
}
