class Components {
  final num co;
  final num no;
  final num no2;
  final num o3;
  final num so2;
  final num pm2_5;
  final num pm10;
  final num nh3;

  Components({
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
  });

  factory Components.fromJson(Map<String, dynamic> json) {
    return Components(
      co: json['co'] ?? 0,
      no: json['no'] ?? 0,
      no2: json['no2'] ?? 0,
      o3: json['o3'] ?? 0,
      so2: json['so2'] ?? 0,
      pm2_5: json['pm2_5'] ?? 0,
      pm10: json['pm10'] ?? 0,
      nh3: json['nh3'] ?? 0,
    );
  }
}

class AirQuality {
  final int aqi;
  final Components components;
  final int dt;

  AirQuality({
    required this.aqi,
    required this.components,
    required this.dt,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      aqi: json['main']['aqi'] ?? 0,
      components: json['components'] != null
          ? Components.fromJson(json['components'])
          : Components(
              co: 0, no: 0, no2: 0, o3: 0, so2: 0, pm2_5: 0, pm10: 0, nh3: 0),
      dt: json['dt'] ?? 0,
    );
  }
}

class AirQualityResponse {
  final bool haveData;
  final List<AirQuality> list;

  AirQualityResponse({
    required this.haveData,
    required this.list,
  });

  factory AirQualityResponse.fromJson(Map<String, dynamic> json) {
    return AirQualityResponse(
      haveData: true,
      list: (json['list'] as List)
          .map((item) => AirQuality.fromJson(item))
          .toList(),
    );
  }
}
