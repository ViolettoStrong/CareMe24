// class ServiceModel {
//   final String id;
//   final String type;
//   final bool verified;
//   final num price;
//   final String name;
//   final String specialization;
//   final num experience;
//   final List<String> diplomas;
//   final List<String> reviews;
//   final String workPlace;
//   final bool goHome;
//   final String institutionName;
//   final bool institutionCommercial;
//   final String institutionType;
//   final String institutionAge;
//   final String license;
//   final String photo;
//   final List<String> calls;
//   final List<String> appointments;
//   final List<String> statements;
//   final  bool is_favourite ;

//   ServiceModel({
//     required this.id,
//     required this.type,
//     required this.verified,
//     required this.price,
//     required this.name,
//     required this.specialization,
//     required this.experience,
//     required this.diplomas,
//     required this.reviews,
//     required this.workPlace,
//     required this.goHome,
//     required this.institutionName,
//     required this.institutionCommercial,
//     required this.institutionType,
//     required this.institutionAge,
//     required this.license,
//     required this.photo,
//     required this.calls,
//     required this.appointments,
//     required this.statements,
//     required this.is_favourite
//   });

//   factory ServiceModel.fromJson(Map<String, dynamic> json) {
//     return ServiceModel(
//       id: json['id'] ?? '',
//       type: json['type'] ?? '',
//       verified: json['verified'] ?? false,
//       price: json['price'] ?? 0,
//       name: json['name'] ?? '',
//       specialization: json['specialization'] ?? '',
//       experience: json['experience'] ?? 0,
//       diplomas: (json['diplomas'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [],
//       reviews: (json['reviews'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [],
//       workPlace: json['work_place'] ?? '',
//       goHome: json['go_home'] ?? false,
//       institutionName: json['institution_name'] ?? '',
//       institutionCommercial: json['institution_commercial'] ?? false,
//       license: json['license'] ?? '',
//       institutionType: json['institution_type'] ?? '',
//       institutionAge: json['institution_age'] ?? '',
//       photo: json['photo'] ?? '',
//       calls: (json['calls'] as List<dynamic>?)?.map((item) {
//         if (item is String) {
//           return item;
//         } else if (item is Map) {
//           return item.toString();
//         }
//         return '';
//       }).toList() ?? [],

//       appointments: (json['appointments'] as List<dynamic>?)?.map((item) {
//         if (item is String) {
//           return item;
//         } else if (item is Map) {
//           return item.toString();
//         }
//         return '';
//       }).toList() ?? [],

//       statements: (json['statements'] as List<dynamic>?)?.map((item) {
//         if (item is String) {
//           return item;
//         } else if (item is Map) {
//           return item.toString();
//         }
//         return '';
//       }).toList() ?? [],

//       is_favourite: json['is_favourite'] ?? false
//     );
//   }
// }

class ServiceModel {
  final String id;
  // final String login;
  // final String password;
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
  // final String otp;
  final List<dynamic> calls;
  final List<dynamic> appointments;
  final List<StatementModel> statements;
  final bool isFavourite;
  final double averageRating;

  ServiceModel({
    required this.id,
    // required this.login,
    // required this.password,
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
    required this.calls,
    required this.appointments,
    required this.statements,
    required this.isFavourite,
    required this.averageRating,
  });

  ServiceModel copyWith({
    String? id,
    String? type,
    String? name,
    String? specialization,
    num? experience,
    double? price,
    List<String>? diplomas,
    List<String>? reviews,
    String? workPlace,
    bool? goHome,
    String? institutionName,
    bool? institutionCommercial,
    String? institutionType,
    String? institutionAge,
    String? license,
    String? photo,
    bool? verified,
    List<dynamic>? calls,
    List<dynamic>? appointments,
    List<StatementModel>? statements,
    bool? isFavourite,
    double? averageRating,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      price: price ?? this.price,
      diplomas: diplomas ?? this.diplomas,
      reviews: reviews ?? this.reviews,
      workPlace: workPlace ?? this.workPlace,
      goHome: goHome ?? this.goHome,
      institutionName: institutionName ?? this.institutionName,
      institutionCommercial:
          institutionCommercial ?? this.institutionCommercial,
      institutionType: institutionType ?? this.institutionType,
      institutionAge: institutionAge ?? this.institutionAge,
      license: license ?? this.license,
      photo: photo ?? this.photo,
      verified: verified ?? this.verified,
      calls: calls ?? this.calls,
      appointments: appointments ?? this.appointments,
      statements: statements ?? this.statements,
      isFavourite: isFavourite ?? this.isFavourite,
      averageRating: averageRating ?? this.averageRating,
    );
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      // login: json['login'] ?? '',
      // password: json['password'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      experience: json['experience'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      diplomas: List<String>.from(json['diplomas'] ?? []),
      reviews: List<String>.from(json['reviews'] ?? []),
      workPlace: json['work_place'] ?? '',
      goHome: json['go_home'] ?? false,
      institutionName: json['institution_name'] ?? '',
      institutionCommercial: json['institution_commercial'] ?? false,
      institutionType: json['institution_type'] ?? '',
      institutionAge: json['institution_age'] ?? '',
      license: json['license'] ?? '',
      photo: json['photo'] ?? '',
      verified: json['verified'] ?? false,
      // otp: json['otp'] ?? '',
      calls: List<dynamic>.from(json['calls'] ?? []),
      appointments: List<dynamic>.from(json['appointments'] ?? []),
      statements: (json['statements'] as List<dynamic>?)
              ?.map((item) => StatementModel.fromJson(item))
              .toList() ??
          [],
      isFavourite: json['is_favourite'] ?? false,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
    );
  }
}

class StatementModel {
  final String reason;
  final String serviceId;
  final String cardId;
  final String? paymentFile;
  final String description;
  final List<String> attachments;
  final String ownerId;
  final CardModel card;
  final String id;
  final String createdAt;

  StatementModel({
    required this.reason,
    required this.serviceId,
    required this.cardId,
    this.paymentFile,
    required this.description,
    required this.attachments,
    required this.ownerId,
    required this.card,
    required this.id,
    required this.createdAt,
  });

  factory StatementModel.fromJson(Map<String, dynamic> json) {
    return StatementModel(
      reason: json['reason'] ?? '',
      serviceId: json['service_id'] ?? '',
      cardId: json['card_id'] ?? '',
      paymentFile: json['payment_file'],
      description: json['description'] ?? '',
      attachments: List<String>.from(json['attachments'] ?? []),
      ownerId: json['owner_id'] ?? '',
      card: CardModel.fromJson(json['card'] ?? {}),
      id: json['id'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class CardModel {
  final PersonalInfo2 personalInfo;
  final MedInfo2 medInfo;
  final String id;
  final String createdAt;

  CardModel({
    required this.personalInfo,
    required this.medInfo,
    required this.id,
    required this.createdAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      personalInfo: PersonalInfo2.fromJson(json['personal_info'] ?? {}),
      medInfo: MedInfo2.fromJson(json['med_info'] ?? {}),
      id: json['id'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class PersonalInfo2 {
  final String avatar;
  final String fullName;
  final String phone;
  final String dob;
  final String address;

  PersonalInfo2({
    required this.avatar,
    required this.fullName,
    required this.phone,
    required this.dob,
    required this.address,
  });

  factory PersonalInfo2.fromJson(Map<String, dynamic> json) {
    return PersonalInfo2(
      avatar: json['avatar'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'].toString(),
      dob: json['dob'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class MedInfo2 {
  final String bloodType;
  final String policy;

  MedInfo2({
    required this.bloodType,
    required this.policy,
  });

  factory MedInfo2.fromJson(Map<String, dynamic> json) {
    return MedInfo2(
      bloodType: json['blood_type'] ?? '',
      policy: json['policy'].toString(),
    );
  }
}
