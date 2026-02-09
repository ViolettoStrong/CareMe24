import 'package:careme24/api/api.dart';
import 'package:careme24/models/user_model.dart';
import 'package:dio/dio.dart';

class UserRepository {
  static Future<UserModel> fetchMyInfo() async {
    final response = Api.loadMyInfo();
    return response;
  }

  static Future<dynamic> changeBalanceRepository(
      Map<String, dynamic> data) async {
    return await Api.changeBalance(data);
  }

  static Future<Map<String, dynamic>> posFcmRepository(FormData data) async {
    final result = await Api.postFCMToken(data);
    return result;
  }

  static Future<dynamic> deletAccountRepository() async {
    return await Api.deletAccount();
  }
}
