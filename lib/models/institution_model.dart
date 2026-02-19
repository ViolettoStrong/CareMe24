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

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      commercial: json['commercial'] ?? false,
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      favourite: json['favourite'] ?? false,
      reviews: List<String>.from(json['reviews'] ?? []),
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      minPrice: json['min_price'] ?? 0.0,
      maxPrice: json['max_price'] ?? 0.0,
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
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
