import 'dart:math';

class CircleZone {
  final double centerLat;
  final double centerLon;
  final double radiusKm;

  CircleZone({
    required this.centerLat,
    required this.centerLon,
    required this.radiusKm,
  });
}

class LocationUtils {
  // Функция для вычисления расстояния между двумя координатами (в км)
  static double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Радиус Земли в км
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

// Converts degrees to radians
  static double _degToRad(double degree) {
    return degree * pi / 180;
  }

  static bool isInZone(double lat, double lon, CircleZone zone) {
    final distance = _haversine(lat, lon, zone.centerLat, zone.centerLon);
    if (distance <= zone.radiusKm) {
      return true;
    }
    return false;
  }
}
