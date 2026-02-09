class MedcardIdModel {
  final String id;

  MedcardIdModel({
    required this.id,
  });

  factory MedcardIdModel.fromJson(json) {
    return MedcardIdModel(
      id: json["id"] ?? '',
    );
  }
}
