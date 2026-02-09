import 'package:careme24/api/api.dart';
import 'package:careme24/models/medcard/medcard_id_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/status_model.dart';
import 'package:careme24/models/user_model.dart';
import 'package:dio/dio.dart';

class MedcardRepository {
  static Future<MedcardModel> fetchMyCard() async {
    final response = await Api.loadMyCard();
    return response;
  }

  static Future<List<MedcardModel>> fetchOtherCards() async {
    final response = await Api.loadOtherCards();
    return response;
  }

  static Future<List<MedcardModel>> fetchUnverifiedCards() async {
    final response = await Api.loadUnverifiedCards();
    return response;
  }

  static Future<List<MedcardModel>> fetchRequestsToMe() async {
    final response = await Api.loadRequestsToMe();
    return response;
  }

  static Future<MedcardIdModel> addMedCard(Map<String, dynamic> data) async {
    final MedcardIdModel response = await Api.addMedCard(data);
    return response;
  }

  static Future<StatusModel> doMedCardMine(String id) async {
    final StatusModel response = await Api.doMedCardMine(id);
    return response;
  }

  static Future<StatusModel> updatePersonalInfo(
      Map<String, dynamic> data, String id) async {
    final StatusModel response = await Api.updateCardPersonalInfo(data, id);
    return response;
  }

  static Future<StatusModel> updatePersonalInfoPhoto(
      FormData data, String id) async {
    final StatusModel response =
        await Api.updateCardPersonalInfoPhoto(data, id);
    return response;
  }

  static Future<StatusModel> updateMedInsurance(
      Map<String, dynamic> data, String id) async {
    final StatusModel response = await Api.updateMedInsurance(data, id);
    return response;
  }

  static Future<StatusModel> addMedItem(
      Map<String, dynamic> params, Map<String, dynamic> data, String id) async {
    final StatusModel response = await Api.addMedInfo(params, data, id);
    return response;
  }

  static Future<StatusModel> deleteCard(String id) async {
    final StatusModel response = await Api.deleteCard(id);
    return response;
  }

  static Future<StatusModel> deleteCardVerifyRequest(String id) async {
    final StatusModel response = await Api.deleteCardVerifyRequest(id);
    return response;
  }

  static Future<StatusModel> cardVerifyRequest(
      String id, String requestType) async {
    final StatusModel response = await Api.cardVerifyRequest(id, requestType);
    return response;
  }

  static Future<List<UserModel>> searchUser(Map<String, dynamic> params) async {
    final List<UserModel> response = await Api.searchUser(params);
    return response;
  }

  static Future<StatusModel> shareCard(
      String cardId, Map<String, dynamic> params) async {
    final response = await Api.shareCard(cardId, params);
    return response;
  }

  static Future<StatusModel> sendRequest(String id) async {
    final response = await Api.sendRequest(id);
    return response;
  }

  static Future<StatusModel> acceptCardRequest(String id) async {
    final response = await Api.acceptCardRequest(id);
    return response;
  }
}
