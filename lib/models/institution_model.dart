class InstitutionModel {
  final String id;
  final String name;
  final bool commercial;
  final String type;
  final String address;
  final Location location;
  final bool favourite;
  final List<String> reviews;
  final double averageRating;
  final double minPrice;
  final double maxPrice;

  InstitutionModel({
    required this.id,
    required this.name,
    required this.commercial,
    required this.type,
    required this.address,
    required this.location,
    required this.favourite,
    required this.reviews,
    required this.averageRating,
    required this.minPrice,
    required this.maxPrice,
  });

  static String _stringFromJson(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) {
      final m = value;
      final v = m['ru'] ?? m['name'] ?? m['en'];
      if (v != null) return v.toString();
      return m.isEmpty ? '' : m.values.first.toString();
    }
    return value.toString();
  }

  static double _doubleFromJson(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static List<String> _reviewsFromJson(dynamic value) {
    if (value == null || value is! List) return [];
    final list = <String>[];
    for (final e in value) {
      if (e is String) {
        list.add(e);
      } else if (e is Map) {
        final text = e['text'] ?? e['username'] ?? e['id'];
        if (text != null) list.add(text.toString());
      }
    }
    return list;
  }

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: _stringFromJson(json['id']),
      name: _stringFromJson(json['name']),
      commercial: json['commercial'] ?? false,
      type: _stringFromJson(json['type']),
      address: _stringFromJson(json['address']),
      location: Location.fromJson(Map<String, dynamic>.from(json['location'] is Map ? json['location'] as Map : {})),
      favourite: json['favourite'] ?? false,
      reviews: _reviewsFromJson(json['reviews']),
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      minPrice: _doubleFromJson(json['min_price']),
      maxPrice: _doubleFromJson(json['max_price']),
    );
  }

  InstitutionModel copyWith({bool? favourite}) {
    return InstitutionModel(
      id: id,
      name: name,
      commercial: commercial,
      type: type,
      address: address,
      location: location,
      favourite: favourite ?? this.favourite,
      reviews: reviews,
      averageRating: averageRating,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final typeVal = json['type'];
    final typeStr = typeVal is String ? typeVal : (typeVal is Map ? (typeVal['ru'] ?? typeVal['name'] ?? typeVal['en'] ?? '').toString() : '');
    final coords = json['coordinates'];
    final list = coords is List ? coords : <dynamic>[];
    return Location(
      type: typeStr,
      coordinates: list.map((e) => (e is num ? e : double.tryParse(e.toString()) ?? 0.0).toDouble()).toList(),
    );
  }
}
