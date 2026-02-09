import 'package:careme24/api/api.dart';
import 'package:careme24/pages/medicines/model/aid_kit_item_mode.dart';
import 'package:careme24/pages/medicines/model/owner_id_model.dart';
import 'package:dio/dio.dart';

class MedicinesRepository {
  static Future<List<AidKitItem>> getMedicinesByIdRepository(String id) async {
    return await Api.getMedicinesById(id);
  }

  static Future<List<MedicineItem>> getMedicinesRepository() async {
    return await Api.getMedicines();
  }

  static Future<Map<String, dynamic>> updateMedicinesRepository(
      FormData data) async {
    final result = await Api.putMedicines(data);
    return result;
  }

  static Future<Map<String, dynamic>> createMedicinesRepository(
      FormData data) async {
    final result = await Api.postMedicines(data);
    return result;
  }

  static Future<Map<String, dynamic>> deleteMedicinesRepository(
      String id) async {
    return await Api.deleteMedicines(id);
  }
}
