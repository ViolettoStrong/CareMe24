class GeoZone {
  final String type;
  final double centerLat;
  final double centerLon;
  final double radius;
  final double topLat;
  final double topLon;
  final double leftLat;
  final double leftLon;
  final double rightLat;
  final double rightLon;
  final double topLeftLat;
  final double topLeftLon;
  final double topRightLat;
  final double topRightLon;
  final double bottomLeftLat;
  final double bottomLeftLon;
  final double bottomRightLat;
  final double bottomRightLon;

  GeoZone({
    required this.type,
    required this.centerLat,
    required this.centerLon,
    required this.radius,
    required this.topLat,
    required this.topLon,
    required this.leftLat,
    required this.leftLon,
    required this.rightLat,
    required this.rightLon,
    required this.topLeftLat,
    required this.topLeftLon,
    required this.topRightLat,
    required this.topRightLon,
    required this.bottomLeftLat,
    required this.bottomLeftLon,
    required this.bottomRightLat,
    required this.bottomRightLon,
  });

  factory GeoZone.fromJson(Map<String, dynamic> json) {
    return GeoZone(
      type: json['type'] ?? '',
      centerLat: (json['center_lat'] ?? 0).toDouble(),
      centerLon: (json['center_lon'] ?? 0).toDouble(),
      radius: (json['radius'] ?? 0).toDouble(),
      topLat: (json['top_lat'] ?? 0).toDouble(),
      topLon: (json['top_lon'] ?? 0).toDouble(),
      leftLat: (json['left_lat'] ?? 0).toDouble(),
      leftLon: (json['left_lon'] ?? 0).toDouble(),
      rightLat: (json['right_lat'] ?? 0).toDouble(),
      rightLon: (json['right_lon'] ?? 0).toDouble(),
      topLeftLat: (json['top_left_lat'] ?? 0).toDouble(),
      topLeftLon: (json['top_left_lon'] ?? 0).toDouble(),
      topRightLat: (json['top_right_lat'] ?? 0).toDouble(),
      topRightLon: (json['top_right_lon'] ?? 0).toDouble(),
      bottomLeftLat: (json['bottom_left_lat'] ?? 0).toDouble(),
      bottomLeftLon: (json['bottom_left_lon'] ?? 0).toDouble(),
      bottomRightLat: (json['bottom_right_lat'] ?? 0).toDouble(),
      bottomRightLon: (json['bottom_right_lon'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'center_lat': centerLat,
      'center_lon': centerLon,
      'radius': radius,
      'top_lat': topLat,
      'top_lon': topLon,
      'left_lat': leftLat,
      'left_lon': leftLon,
      'right_lat': rightLat,
      'right_lon': rightLon,
      'top_left_lat': topLeftLat,
      'top_left_lon': topLeftLon,
      'top_right_lat': topRightLat,
      'top_right_lon': topRightLon,
      'bottom_left_lat': bottomLeftLat,
      'bottom_left_lon': bottomLeftLon,
      'bottom_right_lat': bottomRightLat,
      'bottom_right_lon': bottomRightLon,
    };
  }
}
