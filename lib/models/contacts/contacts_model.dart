import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/user_model.dart';

class ContactModel {
  final String id;
  final int phone;
  final String name;
  final UserModel user;
  final bool verified;
  final bool admin;
  final bool enable;
  final bool sendNotifications;

  ContactModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.user,
    required this.verified,
    required this.admin,
    required this.enable,
    required this.sendNotifications,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
        id: json['id'] ?? '',
        phone: json['other_profile']?['phone'] ?? 0,
        name: getName(json['initiator'] == "other",
            json), // передаем json в метод getName
        user: json['owner'] != null
            ? UserModel.fromJson(json['owner'])
            : UserModel(
                id: '',
                medCardID: '',
                phone: 0,
                personalInfo: PersonalInfo(
                    avatar: '',
                    full_name: 'не указано',
                    phone: 0,
                    dob: '',
                    address: '',
                    temporaryAddress: '',
                    passport: Passport(
                        serial: 0, number: 0, place: '', date: '', photos: [])),
                balance: 0),
        verified: json['verified'] ?? false,
        admin: json['admin'] ?? false,
        enable: json['enabled'] ?? false,
        sendNotifications: json['send_notifications'] ?? false);
  }

  static String getName(bool isOther, Map<String, dynamic> json) {
    if (isOther) {
      return json['other_profile']?['profile']?['personal_info']
              ?['full_name'] ??
          'Нет данных';
    } else {
      return json['name'] ?? 'Нет данных';
    }
  }
}
