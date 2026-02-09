class AidKitModel {
  final String id;
  final String title;
  final String photo;
  final List<dynamic> medicines;
  final String ownerId;
  final Owner owner;

  AidKitModel({
    required this.id,
    required this.title,
    required this.photo,
    required this.medicines,
    required this.ownerId,
    required this.owner,
  });

  factory AidKitModel.fromJson(Map<String, dynamic> json) {
    return AidKitModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      photo: json['photo'] ?? '',
      medicines: json['medicines'] ?? [],
      ownerId: json['owner_id'] ?? '',
      owner: Owner.fromJson(json['owner'] ?? {}),
    );
  }
}

class Owner {
  final String id;
  final int phone;
  final Profile profile;
  final bool hasProfile;
  final int balance;

  Owner({
    required this.id,
    required this.phone,
    required this.profile,
    required this.hasProfile,
    required this.balance,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] ?? '',
      phone: json['phone'] ?? 0,
      profile: Profile.fromJson(json['profile'] ?? {}),
      hasProfile: json['has_profile'] ?? false,
      balance: json['balance'] ?? 0,
    );
  }
}

class Profile {
  final String id;
  final PersonalInfo2 personalInfo;

  Profile({required this.id, required this.personalInfo});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      personalInfo: PersonalInfo2.fromJson(json['personal_info'] ?? {}),
    );
  }
}

class PersonalInfo2 {
  final String avatar;
  final String fullName;
  final int phone;
  final String dob;

  PersonalInfo2({
    required this.avatar,
    required this.fullName,
    required this.phone,
    required this.dob,
  });

  factory PersonalInfo2.fromJson(Map<String, dynamic> json) {
    return PersonalInfo2(
      avatar: json['avatar'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? 0,
      dob: json['dob'] ?? '',
    );
  }
}
