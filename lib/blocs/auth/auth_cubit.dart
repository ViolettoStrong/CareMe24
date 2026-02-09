import 'dart:developer';
import 'package:careme24/api/http_manager.dart';
import 'package:careme24/blocs/blocs.dart';
import 'package:careme24/models/auth/code_send_result.dart';
import 'package:careme24/models/auth/verified_model.dart';
import 'package:careme24/repositories/auth_repository.dart';
import 'package:careme24/service/token_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitState());

  int phone = 0;
  String email = '';
  String password = '';
  bool isEmail = false;

  Future<CodeSendResult> login(String data, String password) async {
    isEmail = data.contains('@');

    final requestData = {
      if (isEmail) "email": data else "phone": data,
      "password": password,
    };

    try {
      final CodeSendResult response = await AuthRepository.login(requestData);

      if (response.isSuccess) {
        log('Login successful');
        if (!isEmail) {
          phone = int.parse(data.replaceAll("+", ""));
        } else {
          email = data;
        }
        emit(AuthCodeState(data: response));
        return response;
      } else {
        log('Login failed');
      }
    } catch (e) {
      log('Login error: $e');
    }
    return CodeSendResult(status: '', detail: '', isSuccess: false);
  }

  Future<CodeSendResult> register(String phoneNumber) async {
    final data = {
      "phone": phoneNumber,
      "email": email,
      "password": password,
    };
    final CodeSendResult response = await AuthRepository.register(data);
    if (response.isSuccess) {
      phone = int.parse((phoneNumber.replaceAll("+", "")));
    }
    emit(AuthCodeState(data: response));
    return response;
  }

  Future<VerifiedModel> verify(String code, String fcm_token) async {
    log('$phone');
    final params = {
      if (isEmail) "email": email else "phone": phone,
      "otp": code,
      "fcm_token": fcm_token,
    };
    final VerifiedModel response = await AuthRepository.verify(params);
    if (response.isSuccess) {
      TokenManager.saveToken(response.token);
      TokenManager.saveRToken(response.rToken);
      HttpManager.instance.setToken(response.token);
    }
    emit(AuthVerifyState(data: response));
    return response;
  }

  void setEmailPassword(String newEmail, newPassword) {
    email = newEmail;
    password = newPassword;
  }

  Future<CodeSendResetResult> resetPassoword(
    String data,
  ) async {
    isEmail = data.contains('@');

    Map<String, dynamic> requestData = {};
    if (isEmail) {
      requestData["email"] = data;
    } else {
      requestData["phone"] = int.tryParse(data) ?? 0;
    }

    try {
      CodeSendResetResult response;

      if (isEmail) {
        response = await AuthRepository.resetPasswordEmail(requestData);
      } else {
        response = await AuthRepository.resetPasswordPhone(requestData);
      }
      if (response.isSuccess) {
        log('Login successful');
        if (!isEmail) {
          phone = int.parse(data.replaceAll("+", ""));
        } else {
          email = data;
        }
        emit(AuthCodeResetState(data: response));
        return response;
      } else {
        log('Login failed');
      }
    } catch (e) {
      log('Login error: $e');
    }
    return CodeSendResetResult(status: '', isSuccess: false);
  }

  Future<bool> resetEmailOrPhone(String data) async {
    isEmail = data.contains('@');

    emit(AuthResetLoadingState());

    try {
      Map<String, dynamic> response = isEmail
          ? await AuthRepository.resetEmail()
          : await AuthRepository.resetPhone();

      if (response["status"] == 'success') {
        log('Reset successful');

        if (!isEmail) {
          phone = int.parse(data.replaceAll("+", ""));
        } else {
          email = data;
        }

        emit(AuthResetSuccessState(data: response["status"]));
        return true;
      } else {
        emit(AuthResetFailureState(
            error: response["message"] ?? "Reset failed"));
        return false;
      }
    } catch (e) {
      log('Reset error: $e');
      emit(AuthResetFailureState(error: e.toString()));
      return false;
    }
  }

  Future<VerifiedResetPasswordModel> verifyResetPassword(
      String code, String passwordNew) async {
    log('$phone');
    final params = {
      if (isEmail) ...{
        "email": email,
        "verification_code": code,
      } else ...{
        "phone": phone,
        "otp": code,
      },
      "new_password": passwordNew,
    };

    VerifiedResetPasswordModel response;
    if (isEmail) {
      response = await AuthRepository.verifyResetPasswordE(params);
    } else {
      response = await AuthRepository.verifyResetPasswordP(params);
    }
    if (response.isSuccess) {}
    emit(AuthVerifyResetPasswordState(data: response));
    return response;
  }

  Future<VerifiedResetPasswordModel> verifyResetMail(
      int code, String passwordNew) async {
    log('$phone');
    final params = {
      if (isEmail) ...{
        "new_email": email,
        "verification_code": code,
      } else ...{
        "new_phone": phone,
        "verification_code": code,
      },
    };

    VerifiedResetPasswordModel response;
    if (isEmail) {
      response = await AuthRepository.verifyResetEmail(params);
    } else {
      response = await AuthRepository.verifyResetPhone(params);
    }
    if (response.isSuccess) {}
    emit(AuthVerifyResetPasswordState(data: response));
    return response;
  }
}
