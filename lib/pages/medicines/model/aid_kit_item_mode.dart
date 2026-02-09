class AidKitItem {
  final String id;
  final String title;
  final DateTime? expirationDate;
  final String count;
  final String aidKitId;

  AidKitItem({
    required this.id,
    required this.title,
    this.expirationDate,
    required this.count,
    required this.aidKitId,
  });

  factory AidKitItem.fromJson(Map<String, dynamic> json) {
    return AidKitItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      expirationDate: json['expiration_date'] != null
          ? DateTime.tryParse(json['expiration_date'])
          : null,
      count: json['count'] ?? '',
      aidKitId: json['aid_kit_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'expiration_date': expirationDate?.toIso8601String(),
      'count': count,
      'aid_kit_id': aidKitId,
    };
  }
}

class AidKit {
  final String id;
  final String name;
  final List<AidKitItem>? items;

  AidKit({
    required this.id,
    required this.name,
    this.items,
  });

  factory AidKit.fromJson(Map<String, dynamic> json) {
    return AidKit(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      items: (json['items'] as List?)
          ?.map((e) => AidKitItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items?.map((e) => e.toJson()).toList(),
    };
  }
}
