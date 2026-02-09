import 'package:careme24/api/api.dart';
import 'package:careme24/pages/medicines/model/intake_model.dart';
import 'package:dio/dio.dart';

class IntakeTimeRepository {
  static Future<List<MedicineIntakeTime>> getInTakeRepository(
      String day) async {
    return await Api.getIntakeTime(day);
  }

  static Future<Map<String, dynamic>> updateInTakeRepository(
      FormData data) async {
    final result = await Api.putIntakeTime(data);
    return result;
  }

  static Future<Map<String, dynamic>> createInTakeRepository(
      FormData data) async {
    final result = await Api.postIntakeTime(data);
    return result;
  }

  static Future<Map<String, dynamic>> deleteInTakeRepository(String id) async {
    return await Api.deleteIntakeTime(id);
  }
}
