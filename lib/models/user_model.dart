import 'package:careme24/models/medcard/medcard_model.dart';

class UserModel {
  final String id;
  final String medCardID;
  final int phone;
  final PersonalInfo personalInfo;
  final int balance;

  UserModel(
      {required this.id,
      required this.medCardID,
      required this.phone,
      required this.personalInfo,
      required this.balance});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] ?? '',
        medCardID: json['profile']?['id'] ?? '',
        phone: json['phone'] ?? 0,
        personalInfo: json['profile']?['personal_info'] != null
            ? PersonalInfo.fromJson(json['profile']['personal_info'])
            : PersonalInfo(
                avatar: '',
                full_name: 'Не указенно',
                phone: 0,
                dob: '',
                address: '',
                temporaryAddress: '',
                passport: Passport(
                  serial: 0,
                  number: 0,
                  place: '',
                  date: '',
                  photos: [],
                ),
              ),
        balance: json['balance'] ?? 0);
  }
}
