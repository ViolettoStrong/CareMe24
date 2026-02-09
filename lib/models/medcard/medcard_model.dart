import 'dart:convert';

class MedcardModel {
  final String id;
  final PersonalInfo personalInfo;
  final MedInfo medInfo;
  final List<ResponseModel> doctorReports;
  final List<ResponseModel> testsResults;
  final List<ResponseModel> cerificates;
  final String status;
  final String detail;
  final bool haveCard;
  final String cardType;
  final AnimalMedCard? animalMedCard;

  MedcardModel({
    required this.id,
    required this.personalInfo,
    required this.medInfo,
    required this.doctorReports,
    required this.testsResults,
    required this.cerificates,
    required this.status,
    required this.detail,
    required this.haveCard,
    required this.cardType,
    this.animalMedCard,
  });

  factory MedcardModel.fromJson(Map<String, dynamic> json) {
    return MedcardModel(
      id: json['id'] ?? '',
      personalInfo: json['personal_info'] != null
          ? PersonalInfo.fromJson(json['personal_info'])
          : PersonalInfo(
              avatar: '',
              full_name: '',
              phone: 0,
              dob: '',
              address: '',
              temporaryAddress: '',
              passport: Passport(
                  serial: 0, number: 0, place: '', date: '', photos: [])),
      medInfo: json['med_info'] != null
          ? MedInfo.fromJson(json['med_info'])
          : MedInfo(
              bloodType: '',
              policy: 0,
              medicalInsurance: Insurance(
                number: '',
                validity: '',
                name: '',
                photo: '',
              ),
              drugIntolerance: '',
              allergy: '',
              diagnoses: '',
              vaccinations: '',
              medicationsTaken: [],
            ),
      doctorReports: (json['doctor_reports'] as List<dynamic>?)
              ?.map((item) => ResponseModel.fromJson(item))
              .toList() ??
          [],
      testsResults: (json['tests_results'] as List<dynamic>?)
              ?.map((item) => ResponseModel.fromJson(item))
              .toList() ??
          [],
      cerificates: (json['certificates'] as List<dynamic>?)
              ?.map((item) => ResponseModel.fromJson(item))
              .toList() ??
          [],
      status: json['status'] ?? '',
      detail: json['detail'] ?? '',
      haveCard: json['status'] != "error",
      cardType: json['card_type'] ?? '', // 👈 այստեղ է վերցնում
      animalMedCard: json['animal_med_card'] != null
          ? AnimalMedCard.fromJson(json['animal_med_card'])
          : null, // 👈 նոր օբյեկտ
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personalInfo': jsonEncode(personalInfo.toMap()),
      'medInfo': jsonEncode(medInfo.toMap()),
      'doctorReports': jsonEncode(doctorReports.map((x) => x.toMap()).toList()),
      'testsResults': jsonEncode(testsResults.map((x) => x.toMap()).toList()),
      'certificates': jsonEncode(cerificates.map((x) => x.toMap()).toList()),
      'status': status,
      'detail': detail,
      'haveCard': haveCard ? 1 : 0,
      'cardType': cardType,
      'animalMedCard': animalMedCard != null
          ? jsonEncode({
              'animal_name': animalMedCard!.animalName,
              'animal_type': animalMedCard!.animalType,
              'animal_size': animalMedCard!.animalSize,
              'animal_photo': animalMedCard!.animalPhoto,
            })
          : null,
    };
  }

  factory MedcardModel.fromMap(Map<String, dynamic> map) {
    return MedcardModel(
      id: map['id'],
      personalInfo: PersonalInfo.fromMap(jsonDecode(map['personalInfo'])),
      medInfo: MedInfo.fromMap(jsonDecode(map['medInfo'])),
      doctorReports: (jsonDecode(map['doctorReports']) as List)
          .map((item) => ResponseModel.fromMap(item))
          .toList(),
      testsResults: (jsonDecode(map['testsResults']) as List)
          .map((item) => ResponseModel.fromMap(item))
          .toList(),
      cerificates: (jsonDecode(map['certificates']) as List)
          .map((item) => ResponseModel.fromMap(item))
          .toList(),
      status: map['status'],
      detail: map['detail'],
      haveCard: map['haveCard'] == 1,

      // 🆕 Ավելացնենք այս երկու տողերը 👇
      cardType: map['cardType'] ?? '',

      animalMedCard: map['animalMedCard'] != null
          ? AnimalMedCard.fromJson(jsonDecode(map['animalMedCard']))
          : null,
    );
  }
}

class AnimalMedCard {
  final String animalName;
  final String animalType;
  final String animalSize;
  final String animalPhoto;

  AnimalMedCard({
    required this.animalName,
    required this.animalType,
    required this.animalSize,
    required this.animalPhoto,
  });

  factory AnimalMedCard.fromJson(Map<String, dynamic> json) {
    return AnimalMedCard(
      animalName: json['animal_name'] ?? '',
      animalType: json['animal_type'] ?? '',
      animalSize: json['animal_size'] ?? '',
      animalPhoto: json['animal_photo'] ?? '',
    );
  }
}

class PersonalInfo {
  final String avatar;
  final String full_name;
  final int phone;
  final String dob;
  final String address;
  final String temporaryAddress;
  final Passport passport;

  PersonalInfo({
    required this.avatar,
    required this.full_name,
    required this.phone,
    required this.dob,
    required this.address,
    required this.temporaryAddress,
    required this.passport,
  });

  factory PersonalInfo.fromJson(json) {
    return PersonalInfo(
        avatar: json['avatar'] ?? '',
        full_name: json['full_name'] ?? '',
        phone: json['phone'] ?? 0,
        dob: json['dob'] ?? '',
        address: json['address'] ?? '',
        temporaryAddress: json['temporary_address'] ?? '',
        passport: json['passport'] != null
            ? Passport.fromJson(json['passport'])
            : Passport(serial: 0, number: 0, place: '', date: '', photos: []));
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar': avatar,
      'full_name': full_name,
      'phone': phone,
      'dob': dob,
      'address': address,
      'temporary_address': temporaryAddress,
      'passport': passport.toMap(),
    };
  }

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      avatar: map['avatar'],
      full_name: map['full_name'],
      phone: map['phone'],
      dob: map['dob'],
      address: map['address'],
      temporaryAddress: map['temporary_address'],
      passport: Passport.fromMap(map['passport']),
    );
  }
}

class Passport {
  final int serial;
  final int number;
  final String place;
  final String date;
  final List<String> photos;

  Passport({
    required this.serial,
    required this.number,
    required this.place,
    required this.date,
    required this.photos,
  });

  factory Passport.fromJson(json) {
    return Passport(
      serial: json['serial'] ?? '',
      number: json['number'] ?? 0,
      place: json['place'] ?? '',
      date: json['date'] ?? '',
      photos: (json['photos'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serial': serial,
      'number': number,
      'place': place,
      'date': date,
      'photos': photos,
    };
  }

  factory Passport.fromMap(Map<String, dynamic> map) {
    return Passport(
      serial: map['serial'],
      number: map['number'],
      place: map['place'],
      date: map['date'],
      photos: List<String>.from(map['photos']),
    );
  }
}

class MedInfo {
  final String bloodType;
  final int policy;
  final Insurance medicalInsurance;
  final String drugIntolerance;
  final String allergy;
  final String diagnoses;
  final String vaccinations;
  final List<Taken> medicationsTaken;

  MedInfo({
    required this.bloodType,
    required this.policy,
    required this.medicalInsurance,
    required this.drugIntolerance,
    required this.allergy,
    required this.diagnoses,
    required this.vaccinations,
    required this.medicationsTaken,
  });

  factory MedInfo.fromJson(json) {
    return MedInfo(
      bloodType: json['blood_type'] ?? '',
      policy: json['policy'] ?? 0,
      medicalInsurance: json['medical_insurance'] != null
          ? Insurance.fromJson(json['medical_insurance'])
          : Insurance(number: '', validity: '', name: '', photo: ''),
      drugIntolerance: json['drug_intolerance'] ?? '',
      allergy: json['allergy'] ?? '',
      diagnoses: json['diagnoses'] ?? '',
      vaccinations: json['vaccinations'] ?? '',
      medicationsTaken: (json['medications_taken'] as List<dynamic>?)
              ?.map((item) => Taken.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blood_type': bloodType,
      'policy': policy,
      'medical_insurance': medicalInsurance.toMap(),
      'drug_intolerance': drugIntolerance,
      'allergy': allergy,
      'diagnoses': diagnoses,
      'vaccinations': vaccinations,
      'medications_taken': medicationsTaken.map((x) => x.toMap()).toList(),
    };
  }

  factory MedInfo.fromMap(Map<String, dynamic> map) {
    return MedInfo(
      bloodType: map['blood_type'],
      policy: map['policy'],
      medicalInsurance: Insurance.fromMap(map['medical_insurance']),
      drugIntolerance: map['drug_intolerance'],
      allergy: map['allergy'],
      diagnoses: map['diagnoses'],
      vaccinations: map['vaccinations'],
      medicationsTaken: (map['medications_taken'] as List)
          .map((item) => Taken.fromMap(item))
          .toList(),
    );
  }
}

class Insurance {
  final String number;
  final String validity;
  final String name;
  final String photo;

  Insurance({
    required this.number,
    required this.validity,
    required this.name,
    required this.photo,
  });

  factory Insurance.fromJson(json) {
    return Insurance(
        number: json['number'] ?? '',
        validity: json['validity'] ?? '',
        name: json['name'] ?? '',
        photo: json['photo'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'validity': validity,
      'name': name,
      'photo': photo,
    };
  }

  factory Insurance.fromMap(Map<String, dynamic> map) {
    return Insurance(
      number: map['number'],
      validity: map['validity'],
      name: map['name'],
      photo: map['photo'],
    );
  }
}

class Taken {
  final String name;
  final String dosage;
  final String file;

  Taken({
    required this.name,
    required this.dosage,
    required this.file,
  });

  factory Taken.fromJson(json) {
    return Taken(
        name: json['name'] ?? '',
        dosage: json['dosage'] ?? '',
        file: json['file'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'file': file,
    };
  }

  factory Taken.fromMap(Map<String, dynamic> map) {
    return Taken(
      name: map['name'],
      dosage: map['dosage'],
      file: map['file'],
    );
  }
}

class ResponseModel {
  final String name;
  final String date;
  final String file;

  ResponseModel({
    required this.name,
    required this.date,
    required this.file,
  });

  factory ResponseModel.fromJson(json) {
    return ResponseModel(
        name: json['name'] ?? '',
        date: json['date'] ?? '',
        file: json['file'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'file': file,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      name: map['name'],
      date: map['date'],
      file: map['file'],
    );
  }
}
