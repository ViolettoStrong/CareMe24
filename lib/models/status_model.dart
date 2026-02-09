class StatusModel {
  final String status;
  final String detail;
  final bool isSuccess;

  StatusModel({
    required this.status,
    required this.detail,
    required this.isSuccess,
  });

  factory StatusModel.fromJson(json) {
    return StatusModel(
        status: json['status'] ?? '',
        detail: json['detail'] ?? '',
        isSuccess: json['status'] == "success" ||
                json['status'] == "succes" ||
                json['status'] == "ok"
            ? true
            : false);
  }
}
