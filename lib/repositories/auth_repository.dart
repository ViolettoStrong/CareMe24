import 'package:careme24/api/api.dart';
import 'package:careme24/models/auth/code_send_result.dart';
import 'package:careme24/models/auth/verified_model.dart';

class AuthRepository {
  static Future<CodeSendResult> login(Map<String, dynamic> data) async {
    final CodeSendResult response = await Api.login(data);
    return response;
  }

  static Future<VerifiedModel> verify(Map<String, dynamic> params) async {
    final VerifiedModel response = await Api.verified(params);
    return response;
  }

  static Future<CodeSendResult> register(Map<String, dynamic> data) async {
    final CodeSendResult response = await Api.register(data);
    return response;
  }

  static Future<dynamic> resetPhone() async {
    final response = await Api.resetPhoneResponse();
    return response;
  }

  static Future<dynamic> resetEmail() async {
    final response = await Api.resetEmailResponse();
    return response;
  }

  static Future<VerifiedResetPasswordModel> verifyResetPhone(
      Map<String, dynamic> params) async {
    final VerifiedResetPasswordModel response =
        await Api.verifiedResetPhoneRes(params);
    return response;
  }

  static Future<VerifiedResetPasswordModel> verifyResetEmail(
      Map<String, dynamic> params) async {
    final VerifiedResetPasswordModel response =
        await Api.verifiedResetEmailRes(params);
    return response;
  }

  static Future<CodeSendResetResult> resetPasswordPhone(
      Map<String, dynamic> data) async {
    final CodeSendResetResult response = await Api.resetPasswordP(data);
    return response;
  }

  static Future<CodeSendResetResult> resetPasswordEmail(
      Map<String, dynamic> data) async {
    final CodeSendResetResult response = await Api.resetPasswordE(data);
    return response;
  }

  static Future<VerifiedResetPasswordModel> verifyResetPasswordP(
      Map<String, dynamic> params) async {
    final VerifiedResetPasswordModel response =
        await Api.verifiedResetPasswordP(params);
    return response;
  }

  static Future<VerifiedResetPasswordModel> verifyResetPasswordE(
      Map<String, dynamic> params) async {
    final VerifiedResetPasswordModel response =
        await Api.verifiedResetPasswordE(params);
    return response;
  }
}
