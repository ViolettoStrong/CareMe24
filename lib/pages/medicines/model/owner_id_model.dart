// class AidKitOwner {
//   final String phone;
//   final String email;
//   final bool verified;
//   final String fcmToken;
//   final int balance;
//   final String id;
//   final DateTime createdAt;

//   AidKitOwner({
//     required this.phone,
//     required this.email,
//     required this.verified,
//     required this.fcmToken,
//     required this.balance,
//     required this.id,
//     required this.createdAt,
//   });

//   factory AidKitOwner.fromJson(Map<String, dynamic> json) {
//     return AidKitOwner(
//       phone: json['phone'],
//       email: json['email'],
//       verified: json['verified'],
//       fcmToken: json['fcm_token'],
//       balance: json['balance'],
//       id: json['id'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }

class AidKit {
  final String title;
  final String photo;
  // final AidKitOwner owner;
  final List<Medicine> medicines;
  final String id;

  AidKit({
    required this.title,
    required this.photo,
    // required this.owner,
    required this.medicines,
    required this.id,
  });

  factory AidKit.fromJson(Map<String, dynamic> json) {
    var medicinesList = (json['medicines'] as List)
        .map((medicineJson) => Medicine.fromJson(medicineJson))
        .toList();

    return AidKit(
      title: json['title'],
      photo: json['photo'],
      // owner: AidKitOwner.fromJson(json['owner']),
      medicines: medicinesList,
      id: json['id'],
    );
  }
}

class Medicine {
  final String title;
  final String count; // Change from String to int
  final DateTime expirationDate;
  final String id;
  final String aidKitId;

  Medicine({
    required this.title,
    required this.count,
    required this.expirationDate,
    required this.id,
    required this.aidKitId,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      title: json['title'],
      count: json['count'], // JSON contains int, so this is fine now
      expirationDate: DateTime.parse(json['expiration_date']),
      id: json['id'],
      aidKitId: json['aid_kit_id'],
    );
  }
}

class MedicineItem {
  final String id;
  final String title;
  final String count; // Change from String to int
  final DateTime expirationDate;
  final String aidKitId;
  final AidKit aidKit;

  MedicineItem({
    required this.id,
    required this.title,
    required this.count,
    required this.expirationDate,
    required this.aidKitId,
    required this.aidKit,
  });

  factory MedicineItem.fromJson(Map<String, dynamic> json) {
    return MedicineItem(
      id: json['id'],
      title: json['title'],
      count: json['count'], // JSON contains int
      expirationDate: DateTime.parse(json['expiration_date']),
      aidKitId: json['aid_kit_id'],
      aidKit: AidKit.fromJson(json['aid_kit']),
    );
  }
}
