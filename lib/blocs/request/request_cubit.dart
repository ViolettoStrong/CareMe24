import 'dart:developer';
import 'dart:io';
import 'package:careme24/blocs/request/request_state.dart';
import 'package:careme24/models/request_status_model.dart';
import 'package:careme24/models/status_model.dart';
import 'package:careme24/repositories/requests_respository.dart';
import 'package:careme24/service/pref_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestInit());

  bool enable = false;
  double lat = 0.0;
  double lon = 0.0;
  String addres = '';
  String city = '';
  String medCardId = '';

  getLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      Position location = await Geolocator.getCurrentPosition();
      log('${location.latitude} ${location.longitude}');
      lat = location.latitude;
      lon = location.longitude;
      enable = true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<RequestStatusModel> createRequest(
    String detail,
    dynamic type,
    bool important,
    String? institutionId,
  ) async {
    if (enable) {
      // Map<String, dynamic> data = {
      //   "detail": detail,
      //   "important": important,
      //   "type": type,
      //   "lat": lat,
      //   "lon": lon,
      //   "card_id": medCardId,
      //   "notice_contacts" : await PrefService.isNotifContact(),
      //   "creation_date_user": DateTime.now(),
      //   "institution_id" : institutionId
      // };
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        "important": false,
        "institution_id": institutionId,
        "card_id": medCardId,
        "lon": lon,
        "lat": lat,
        "detail": detail,
        "payment_information": null,
        "notice_contacts": prefs.getBool('pay_switch_value_notif_tome'),
        // "notice_contacts": true,
        "type": type,
        "video": null,
        "creation_date_user": DateTime.now().toIso8601String(),
      };
      log('data: $data');
      var formData = FormData.fromMap(data);
      final response = await RequestsRespository.createRequest(formData);
      return response;
    }

    return RequestStatusModel(
      status: 'error',
      detail: 'error',
      isSuccess: false,
      requestId: '',
    );
  }

  Future<StatusModel> deleteRequest(String id) async {
    Map<String, dynamic> params = {"request_id": id};
    final response = await RequestsRespository.deleteRequest(params);
    return response;
  }

  Future<StatusModel> updateRequest(
      String id, Map<String, dynamic> data) async {
    Map<String, dynamic> params = {
      "request_id": id,
    };

    final response = await RequestsRespository.updateRequest(params, data);
    return response;
  }

  Future<RequestStatusModel> createRequest112(String selectedReason,
      List<File> videoFiles, bool isUrgently, String type) async {
    final prefs = await SharedPreferences.getInstance();
    if (enable) {
      Map<String, dynamic> data = {
        "detail": selectedReason,
        "important": isUrgently,
        "type": type,
        "lat": lat,
        "lon": lon,
        "notice_contacts": prefs.getBool('pay_switch_value_notif_tome'),
        "card_id": medCardId,
        "creation_date_user": DateTime.now(),
        "videos": await Future.wait(videoFiles.map(
          (file) => MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        )),
      };
      final response = await RequestsRespository.createRequest112(data);
      log('$response');
      return response;
    }

    return RequestStatusModel(
        status: 'error', detail: 'error', isSuccess: false, requestId: '');
  }

  Future<StatusModel> deleteRequest112(String id) async {
    Map<String, dynamic> params = {"request_id": id};
    final response = await RequestsRespository.deleteReques112(params);
    return response;
  }

  Future<StatusModel> updateRequest112(
      String id, Map<String, dynamic> data) async {
    Map<String, dynamic> params = {
      "request_id": id,
    };

    final response = await RequestsRespository.updateRequest112(params, data);
    return response;
  }

  Future<RequestStatusModel> createCall(
      String problem, serviceId, cardId) async {
    Map<String, dynamic> data = {
      "problem": problem,
      "lat": lat,
      "lon": lon,
      "card_id": cardId,
      "service_id": serviceId,
    };
    final resposne = RequestsRespository.createCall(data);
    return resposne;
  }

  Future<RequestStatusModel> createStatement(
      String reason, serviceId, description, cardId, List<File> files) async {
    List<MultipartFile> attachments = [];

    for (var file in files) {
      attachments.add(await MultipartFile.fromFile(file.path));
    }

    Map<String, dynamic> data = {
      "reason": reason,
      "service_id": serviceId,
      "card_id": cardId,
      "description": description,
      "attachments": attachments
    };

    final response = RequestsRespository.createStatement(data);
    return response;
  }

  Future<RequestStatusModel> createAppointment(
      String serviceId, problem) async {
    Map<String, dynamic> data = {
      "appointment_time": DateTime.now(),
      "service_id": serviceId,
      "card_id": medCardId,
      "problem": problem,
    };
    final response = RequestsRespository.createAppointment(data);
    return response;
  }

  String getCodeByText(String text) {
    if (text.contains('Совершается преступление') ||
        text.contains('террорист')) {
      return 'pol'; // Полиция
    } else if (text.contains('Стихийное бедствие') || text.contains('пожар')) {
      return 'mch'; // МЧС
    } else if (text.contains('Вызов мед. помощи')) {
      return 'med'; // Медицинская помощь
    } else {
      return 'unknown'; // Неизвестный тип
    }
  }

  void setMedCardID(String newID) {
    medCardId = newID;
  }
}
