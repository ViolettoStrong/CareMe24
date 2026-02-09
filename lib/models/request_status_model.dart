class RequestStatusModel {
  final String status;
  final String detail;
  final String requestId;
  final bool isSuccess;

  RequestStatusModel({
    required this.status,
    required this.detail,
    required this.isSuccess,
    required this.requestId,
  });

  factory RequestStatusModel.fromJson(json) {
    return RequestStatusModel(
      status: json['status'] ?? '',
      detail: json['detail'] ?? '',
      isSuccess: json['status'] == "success" ||
              json['status'] == "succes" ||
              json['status'] == "ok"
          ? true
          : false,
      requestId: json['request_id'] ?? '',
    );
  }
}
