class CodeSendResult {
  final String status;
  final String detail;
  final bool isSuccess;

  CodeSendResult({
    required this.status,
    required this.detail,
    required this.isSuccess,
  });

  factory CodeSendResult.fromJson(json) {
    return CodeSendResult(
        status: json['status'] ?? '',
        detail: json['detail'] ?? '',
        isSuccess: json['status'] == "success" ? true : false);
  }
}

class CodeSendResetResult {
  final String status;
  final bool isSuccess;

  CodeSendResetResult({
    required this.status,
    required this.isSuccess,
  });

  factory CodeSendResetResult.fromJson(json, bool isSuccess) {
    return CodeSendResetResult(
      status: json['status'] ?? '',
      isSuccess: isSuccess,
    );
  }
}
