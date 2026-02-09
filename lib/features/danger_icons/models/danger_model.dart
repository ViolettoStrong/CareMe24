import 'package:careme24/features/danger_icons/controller/location_utils.dart';
import 'package:careme24/features/danger_icons/domain/danger_icon_props_usecase.dart';
import 'package:careme24/features/danger_icons/models/geo_zone_model.dart';
import 'package:geolocator/geolocator.dart';

class DangerModel {
  final String incidentType;
  final String dangerLevel;
  final String country;
  final String city;
  final String comment;
  final String type;
  final double centerLat;
  final double centerLon;
  final double radius;
  bool isActive;
  late int dangerIndex;
  GeoZone? geoZone;

  DangerModel({
    required this.incidentType,
    required this.country,
    required this.city,
    required this.comment,
    required this.type,
    this.centerLat = 0.0,
    this.centerLon = 0.0,
    this.radius = 0.0,
    this.isActive = false,
    required this.dangerLevel,
    this.geoZone,
  }) {
    dangerIndex = getDangerIndex(dangerLevel);
  }

  factory DangerModel.fromJson(Map<String, dynamic> json,
      {Position? position, bool? isAct}) {
    // String dangerLv = json['danger_level']?.toString() ?? '';
    // bool isActive = json['isActive'] ?? false;
    bool isActive = isAct ?? false;
    final GeoZone? geoZone =
        json['type'] != null ? GeoZone.fromJson(json) : null;
    if (position != null && geoZone != null && geoZone.type == 'circle') {
      CircleZone circleZone = CircleZone(
        centerLat: geoZone.centerLat,
        centerLon: geoZone.centerLon,
        radiusKm: geoZone.radius * 10,
        // radiusKm: 10,
      );
      isActive = LocationUtils.isInZone(
          position.latitude, position.longitude, circleZone);
    }
    return DangerModel(
      incidentType: json['incident_type']?.toString() ?? '',
      // dangerLevel: dangerLv,
      // dangerIndex: getDangerIndex(dangerLv),
      dangerLevel: json['danger_level']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      centerLat: json['center_lat']?.toDouble() ?? 0.0,
      centerLon: json['center_lon']?.toDouble() ?? 0.0,
      radius: json['radius']?.toDouble() ?? 0.0,
      isActive: isActive,
      geoZone: geoZone,
    );
  }
}
