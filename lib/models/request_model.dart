class RequestModel {
  final String id;
  final int phone;
  final String fullName;
  final double lat;
  final double lon;
  final String detail;
  final String type;
  final bool seen;
  final String comment;
  final bool is112;
  final String cardId;

  RequestModel({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.lat,
    required this.lon,
    required this.detail,
    required this.type,
    required this.seen,
    this.comment = '',
    this.is112 = false,
    this.cardId = '',
  });

  factory RequestModel.fromJson(Map<String, dynamic> json, bool is112) {
    var coordinates = json['request']['location']['coordinates'];
    return RequestModel(
      id: json['id'] ?? '',
      phone: json['contact']?['other_profile']?['phone'] ?? 0,
      fullName: json['contact']?['other_profile']?['profile']?['personal_info']
              ?['full_name'] ??
          'Нет данных',
      lat: coordinates != null && coordinates.isNotEmpty ? coordinates[1] : 0.0,
      lon: coordinates != null && coordinates.isNotEmpty ? coordinates[0] : 0.0,
      detail: json['request']?['detail'] ?? 'Нет данных',
      type: json['request']?['type'] ?? '',
      seen: json['seen'] ?? false,
      is112: is112,
      cardId: json['request']?['card_id'] ?? '',
    );
  }
}
