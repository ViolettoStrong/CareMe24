import 'package:careme24/api/api.dart';
import 'package:careme24/blocs/service/model_chat.dart';
import 'package:careme24/models/institution_model.dart';
import 'package:careme24/models/request_model.dart';
import 'package:careme24/models/request_status_model.dart';
import 'package:careme24/models/service_model.dart';
import 'package:careme24/models/status_model.dart';
import 'package:dio/dio.dart';

class RequestsRespository {
  static Future<RequestStatusModel> createRequest(FormData data) {
    final respone = Api.createRequest(data);
    return respone;
  }

  static Future<StatusModel> deleteRequest(Map<String, dynamic> params) {
    final respone = Api.deleteRequest(params);
    return respone;
  }

  static Future<StatusModel> updateRequest(Map<String, dynamic> params, data) {
    final respone = Api.updateRequest(params, data);
    return respone;
  }

  static Future<RequestStatusModel> createRequest112(
      Map<String, dynamic> data) {
    final respone = Api.createRequest112(data);
    return respone;
  }

  static Future<StatusModel> deleteReques112(Map<String, dynamic> params) {
    final respone = Api.deleteRequest112(params);
    return respone;
  }

  static Future<StatusModel> updateRequest112(
      Map<String, dynamic> params, data) {
    final respone = Api.updateRequest112(params, data);
    return respone;
  }

  static Future<List<RequestModel>> getContactRequests112() {
    final respone = Api.getContactsRequests112();
    return respone;
  }

  static Future<void> seenContactRequests112(Map<String, dynamic> params) {
    final respone = Api.seenContactRequest112(params);
    return respone;
  }

  static Future<void> seenContactRequests(Map<String, dynamic> params) {
    final respone = Api.seenContactRequest(params);
    return respone;
  }

  static Future<List<RequestModel>> getContactRequests() {
    final respone = Api.getContactsRequests();
    return respone;
  }

  static Future<List<ServiceModel>> getServices(Map<String, dynamic> data) {
    final respone = Api.getServices(data);
    return respone;
  }

  static Future<List<ChatRoom>> getServicesChatRooms() {
    final respone = Api.getServicesChat();
    return respone;
  }

  static Future<List<ChatRoom>> getServicesChatUsers(String id) {
    final respone = Api.getServicesChatUsers(id);
    return respone;
  }

  static Future<Map<String, dynamic>> postChatMessage(FormData data) {
    final respone = Api.postChatService(data);
    return respone;
  }

  static Future<List<InstitutionModel>> getInstitutions(
      Map<String, dynamic> params) {
    final respone = Api.getInstitutions(params);
    return respone;
  }

  static Future<RequestStatusModel> createCall(Map<String, dynamic> data) {
    final respone = Api.createCall(data);
    return respone;
  }

  static Future<RequestStatusModel> createStatement(Map<String, dynamic> data) {
    final respone = Api.createStatement(data);
    return respone;
  }

  static Future<RequestStatusModel> createAppointment(
      Map<String, dynamic> data) {
    final respone = Api.createAppointment(data);
    return respone;
  }
}
