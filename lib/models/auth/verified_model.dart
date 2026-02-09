class VerifiedModel {
  final String status;
  final String detail;
  final bool isSuccess;
  final String token;
  final String rToken;

  VerifiedModel({
    required this.status,
    required this.detail,
    required this.isSuccess,
    required this.token,
    required this.rToken,
  });

  factory VerifiedModel.fromJson(json) {
    return VerifiedModel(
      status: json['status'] ?? '',
      detail: json['detail'] ?? '',
      isSuccess: json['status'] == "success" ? true : false,
      token: json['access_token'] ?? '',
      rToken: json['refresh_token'] ?? '',
    );
  }
}

class VerifiedResetPasswordModel {
  final String status;
  final bool isSuccess;

  VerifiedResetPasswordModel({
    required this.status,
    required this.isSuccess,
  });

  factory VerifiedResetPasswordModel.fromJson(json) {
    return VerifiedResetPasswordModel(
      status: json['status'] ?? '',
      isSuccess: json['status'] == "success" ? true : false,
    );
  }
}
