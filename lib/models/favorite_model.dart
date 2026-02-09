class ServiceModel2 {
  final String serviceId;
  final String userId;
  final ServiceDetails service;
  final String id;

  ServiceModel2({
    required this.serviceId,
    required this.userId,
    required this.service,
    required this.id,
  });

  factory ServiceModel2.fromJson(Map<String, dynamic> json) {
    return ServiceModel2(
      serviceId: json['service_id'],
      userId: json['user_id'],
      service: ServiceDetails.fromJson(json['service']),
      id: json['id'],
    );
  }
}

class ServiceDetails {
  final String login;
  final String password;
  final String type;
  final String name;
  final String specialization;
  final num experience;
  final double price;
  final List<String> diplomas;
  final List<String> reviews;
  final String workPlace;
  final bool goHome;
  final String institutionName;
  final bool institutionCommercial;
  final String institutionType;
  final String institutionAge;
  final String license;
  final String photo;
  final bool verified;
  // final int otp;
  final String id;

  ServiceDetails({
    required this.login,
    required this.password,
    required this.type,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.price,
    required this.diplomas,
    required this.reviews,
    required this.workPlace,
    required this.goHome,
    required this.institutionName,
    required this.institutionCommercial,
    required this.institutionType,
    required this.institutionAge,
    required this.license,
    required this.photo,
    required this.verified,
    // required this.otp,
    required this.id,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      login: json['login'] ?? '',
      password: json['password'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      experience: json['experience'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      diplomas:
          (json['diplomas'] as List?)?.map((e) => e.toString()).toList() ?? [],
      reviews:
          (json['reviews'] as List?)?.map((e) => e.toString()).toList() ?? [],
      workPlace: json['work_place'] ?? '',
      goHome: json['go_home'] ?? false,
      institutionName: json['institution_name'] ?? '',
      institutionCommercial: json['institution_commercial'] ?? false,
      institutionType: json['institution_type'] ?? '',
      institutionAge: json['institution_age'] ?? '',
      license: json['license'] ?? '',
      photo: json['photo'] ?? '',
      verified: json['verified'] ?? false,
      // otp: (json['otp'] as int?) ?? 0,
      id: json['id'] ?? '',
    );
  }

  /// Static method to provide an empty default instance
  static ServiceDetails empty() {
    return ServiceDetails(
      login: '',
      password: '',
      type: '',
      name: '',
      specialization: '',
      experience: 0,
      price: 0.0,
      diplomas: [],
      reviews: [],
      workPlace: '',
      goHome: false,
      institutionName: '',
      institutionCommercial: false,
      institutionType: '',
      institutionAge: '',
      license: '',
      photo: '',
      verified: false,
      // otp: 0,
      id: '',
    );
  }
}

// Function to parse a list of services
List<ServiceModel2> parseServices(List<dynamic> data) {
  return data.map((e) => ServiceModel2.fromJson(e)).toList();
}
