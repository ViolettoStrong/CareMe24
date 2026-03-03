// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'dart:io';
import 'package:careme24/api/http_manager.dart';
import 'package:careme24/api/http_manager_2.dart';
import 'package:careme24/blocs/service/model_chat.dart';
import 'package:careme24/models/auth/code_send_result.dart';
import 'package:careme24/models/auth/verified_model.dart';
import 'package:careme24/models/contacts/contacts_model.dart';
import 'package:careme24/features/danger_icons/models/danger_model.dart';
import 'package:careme24/features/danger_icons/models/air_pollution_model.dart';
import 'package:careme24/features/danger_icons/models/pressure_wind_model.dart';
import 'package:careme24/models/favorite_model.dart';
import 'package:careme24/models/institution_model.dart';
import 'package:careme24/models/medcard/medcard_id_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/request_model.dart';
import 'package:careme24/models/request_status_model.dart';
import 'package:careme24/models/reviews_model.dart';
import 'package:careme24/models/service_model.dart';
import 'package:careme24/models/status_model.dart';
import 'package:careme24/models/user_model.dart';
import 'package:careme24/features/danger_icons/models/weather_forecast_model.dart';
import 'package:careme24/pages/medical_bag/models/aid_kit_model.dart';
import 'package:careme24/pages/medicines/model/aid_kit_item_mode.dart';
import 'package:careme24/pages/medicines/model/intake_model.dart';
import 'package:careme24/pages/medicines/model/owner_id_model.dart';
import 'package:careme24/service/env_service.dart';
import 'package:careme24/storage/storage.dart';
import 'package:dio/dio.dart';

class Api {
  static final HttpManager httpManager = HttpManager.instance;
  static final HttpManager2 httpManager2 = HttpManager2.instance;

  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String verifiedEndpoint = '/api/auth/verified';
  static const String refreshEndpoint = '/api/auth/refresh';
  static const String resetPasswordPhone = '/api/auth/reset_password/phone';
  static const String resetPasswordEmail = '/api/auth/reset_password/email';
  static const String verifiedResetPasswordPhone =
      '/api/auth/reset_password_confirm/phone';
  static const String verifiedResetPasswordEmail =
      '/api/auth/reset_password_confirm/email/';
  static const String resetPhone = '/api/users/change_phone';
  static const String resetEmail = '/api/users/change_email';
  static const String verifiedResetPhone = '/api/users/change_phone_confirm';
  static const String verifiedResetEmail = '/api/users/change_email_confirm';

  // users
  static const String getMyInfo = '/api/users/me';
  static const String getIcons = '/api/users/get_danger_icons';
  static const String getAllIcons = '/api/users/get_all_danger_icons';
  static const String delet_account = '/api/users/delete_account';
  static const String sent_fcm_token = '/api/users/send_notification/token';

  // contacts
  static const String contactDelete = '/api/contacts';
  static const String contactsUnverified = '/api/contacts/unverified';
  static const String contactsInvited = '/api/contacts/invited';
  static const String contactsAll = '/api/contacts/all';
  static const String contactVerify = '/api/contacts';
  static const String contactUpdate = '/api/contacts';
  static const String contactAdd = '/api/contacts/add';
  static const String contactSendNotifications = '/api/contacts';

  // medcard
  static const String medcardAdd = '/api/cards/add';
  static const String updateCard = '/api/cards';
  static const String getMyCard = '/api/cards/mine';
  static const String getOtherCards = '/api/cards/other';
  static const String getUserInfo = '/api/users/users';
  static const String unverifiedCards = '/api/cards/all_given_unverified';
  static const String deleteVerifyRequest = '/api/cards/administration';
  static const String verifyRequest = '/api/cards/verify';
  static const String userSearch = '/api/users/users';
  static const String shareMedCard = '/api/cards/give_away';
  static const String sendCardRequest = '/api/card_requests';
  static const String cardRequestsToMe = '/api/card_requests/to_me';

  // OpenWeather service routes
  static const String getAirPollution = '/air_pollution';
  static const String getWeather = '/forecast';

  // OpenMeteo
  static const String getPressure = '/forecast';

  //Requests
  static const String requests = '/api/services';

  //Wallet
  static const String change_balance = '/api/users/change_balance';

  //favorites
  static const String favorites_services = '/api/favorites/service';
  static const String favorites = '/api/favorites/';

  //reviews
  static const String add_review = '/api/reviews/create_review';
  static const String add_review_service = '/api/reviews/create_service_review';
  static const String reviewes_service = '/api/reviews/service/';
  static const String reviews = '/api/reviews/';
  static const String average_rating = '/api/reviews/';
  static const String reviewsInstitutions = '/api/reviews/institutions';

  // medicines
  static const String medicines = '/api/medicines/medicine';
  static const String medicines_intake_time = '/api/medicines/intake_time';
  static const String medicines_intake_time_user =
      '/api/medicines/intake_time/user/';

  // medical bag
  static const String medical_bag = '/api/medicines/aid_kit';
  static const String medical_bag_get_id = '/api/medicines/aid_kit/get/';
  static const String medical_bag_request = '/api/medicines/aid_kit/request';
  static const String medical_bag_user = '/api/medicines/aid_kit/user/';

  static Future<CodeSendResult> login(Map<String, dynamic> data) async {
    log('$data');
    try {
      var result = await httpManager.post(loginEndpoint, data: data);
      log('$result');
      return CodeSendResult.fromJson(result);
    } catch (e) {
      log('Login error: $e');
      return CodeSendResult(status: 'error', isSuccess: false, detail: 'error');
    }
  }

  static Future<CodeSendResult> register(Map<String, dynamic> data) async {
    log('$data');
    try {
      log('$data');
      var result = await httpManager.post(registerEndpoint, data: data);
      log('$result');
      return CodeSendResult.fromJson(result);
    } catch (e) {
      log('Register error: $e');
      return CodeSendResult(status: 'error', isSuccess: false, detail: 'error');
    }
  }

  static Future<Map<String, dynamic>> resetPhoneResponse() async {
    // log('$data');
    try {
      // log('$data');
      var result = await httpManager.post(resetPhone);
      log('$result');
      return result;
    } catch (e) {
      log('Register resetPhoneResponse: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<List<dynamic>> getChatGroup() async {
    try {
      var result = await httpManager.get('/api/requests/chat/group/list');
      log('$result');
      return result;
    } catch (e) {
      log('getChatGroup Error: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getChatCar() async {
    try {
      var result = await httpManager.get('/api/requests/chat/car/list');
      log('$result');
      return result;
    } catch (e) {
      log('getChatGroup Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> sendMessageGroup({
    required String chatId,
    required String message,
    required String messageType, // usually 'text' or 'file'
    String? filePath, // optional file
  }) async {
    try {
      final formData = FormData.fromMap({
        'chat_id': chatId,
        'message': message,
        'message_type': messageType,
        if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
      });

      final result = await httpManager.post(
        '/api/requests/chat/group/send',
        data: formData,
      );

      log('✅ Send message result: $result');
      return result;
    } catch (e) {
      log('❌ sendMessageGroup error: $e');
      return {
        "status": "error",
        "message": "Request failed",
      };
    }
  }

  static Future<Map<String, dynamic>> sendMessageCar({
    required String chatId,
    required String message,
    required String messageType, // usually 'text' or 'file'
    String? filePath, // optional file
  }) async {
    try {
      final formData = FormData.fromMap({
        'chat_id': chatId,
        'message': message,
        'message_type': messageType,
        if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
      });

      final result = await httpManager.post(
        '/api/requests/chat/car/send',
        data: formData,
      );

      log('✅ Send message result: $result');
      return result;
    } catch (e) {
      log('❌ sendMessageGroup error: $e');
      return {
        "status": "error",
        "message": "Request failed",
      };
    }
  }

  static Future<Map<String, dynamic>> resetEmailResponse() async {
    // log('$data');
    try {
      // log('$data');
      var result = await httpManager.post(resetEmail);
      log('$result');
      return result;
    } catch (e) {
      log('Register resetEmailResponse: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<VerifiedResetPasswordModel> verifiedResetPhoneRes(
      Map<String, dynamic> params) async {
    log('$params');
    try {
      log('$params');
      var result = await httpManager.post(verifiedResetPhone, data: params);
      log('$result');
      return VerifiedResetPasswordModel.fromJson(result);
    } catch (e) {
      log('Verification error verifiedResetPhoneRes: $e');
      return VerifiedResetPasswordModel(
        status: 'error',
        isSuccess: false,
      );
    }
  }

  static Future<VerifiedResetPasswordModel> verifiedResetEmailRes(
      Map<String, dynamic> params) async {
    log('$params');
    try {
      log('$params');
      var result = await httpManager.post(verifiedResetEmail, data: params);
      log('$result');
      return VerifiedResetPasswordModel.fromJson(result);
    } catch (e) {
      log('Verification error verifiedResetEmailRes: $e');
      return VerifiedResetPasswordModel(
        status: 'error',
        isSuccess: false,
      );
    }
  }

  static Future<CodeSendResetResult> resetPasswordP(
      Map<String, dynamic> data) async {
    log('$data');
    try {
      log('$data');
      var result = await httpManager.postWithResponseCode(resetPasswordPhone,
          params: data);
      log('$result');
      if (result.$2 == 200) {
        return CodeSendResetResult(status: 'success', isSuccess: true);
      }
      return CodeSendResetResult(status: 'error', isSuccess: false);
    } catch (e) {
      log('Register error resetPasswordP: $e');
      return CodeSendResetResult(
        status: 'error',
        isSuccess: false,
      );
    }
  }

  static Future<CodeSendResetResult> resetPasswordE(
      Map<String, dynamic> data) async {
    log('$data');
    try {
      log('$data');
      var result = await httpManager.postWithResponseCode(resetPasswordEmail,
          params: data);
      if (result.$2 == 200) {
        return CodeSendResetResult(status: 'success', isSuccess: true);
      }
      return CodeSendResetResult(status: 'error', isSuccess: false);
    } catch (e) {
      log('Register error resetPasswordE: $e');
      return CodeSendResetResult(
        status: 'error',
        isSuccess: false,
      );
    }
  }

  static Future<VerifiedResetPasswordModel> verifiedResetPasswordP(
      Map<String, dynamic> params) async {
    log('$params');
    try {
      log('$params');
      var result =
          await httpManager.post(verifiedResetPasswordPhone, params: params);
      log('$result');
      return VerifiedResetPasswordModel.fromJson(result);
    } catch (e) {
      log('Verification error verifiedResetPasswordP: $e');
      return VerifiedResetPasswordModel(
        status: 'error',
        isSuccess: false,
      );
    }
  }

  static Future<VerifiedResetPasswordModel> verifiedResetPasswordE(
      Map<String, dynamic> params) async {
    log('$params');
    try {
      log('$params');
      var result =
          await httpManager.post(verifiedResetPasswordEmail, params: params);
      log('$result');
      return VerifiedResetPasswordModel.fromJson(result);
    } catch (e) {
      log('Verification error verifiedResetPasswordE: $e');
      return VerifiedResetPasswordModel(
        status: 'error',
        isSuccess: false,
      );
    }
  }

  static Future<VerifiedModel> verified(Map<String, dynamic> params) async {
    log('$params');
    try {
      log('$params');
      var result = await httpManager.post(verifiedEndpoint, params: params);
      log('$result');
      return VerifiedModel.fromJson(result);
    } catch (e) {
      log('Verification error verified: $e');
      return VerifiedModel(
          status: 'error',
          detail: 'error',
          isSuccess: false,
          token: '',
          rToken: '');
    }
  }

  static Future<String?> refresh() async {
    try {
      var result = await httpManager.post(refreshEndpoint);
      log('ssssssaa ${result['access_token']}');
      return result['access_token'];
    } catch (e) {
      log('Refresh token error refresh: $e');
      return null;
    }
  }

  static Future<List<ContactModel>> loadContactsUnverified() async {
    List<ContactModel> contacts = [];
    try {
      var result = await httpManager.get(contactsUnverified);
      for (var contact in result) {
        contacts.add(ContactModel.fromJson(contact));
      }
      log(' loadContactsUnverified :$result');
    } catch (e) {
      log('Load unverified contacts error loadContactsUnverified: $e');
    }
    return contacts;
  }

  static Future<List<dynamic>> loadFriends() async {
    try {
      var result = await httpManager.get(contactsAll);
      log(' loadContactsUnverified :$result');
      return result;
    } catch (e) {
      log('Load unverified contacts error loadContactsUnverified: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> loadNearestInstitution({
    required double lat,
    required double lon,
    required String institutionType,
  }) async {
    try {
      final result = await httpManager.get(
        '/api/requests/nearest_institution',
        params: {
          'lat': lat,
          'lon': lon,
          'institution_type': institutionType,
        },
      );

      log('loadNearestInstitution: $result');
      return result;
    } catch (e) {
      log('loadNearestInstitution error: $e');
      return null;
    }
  }

  static Future<List<ContactModel>> loadContactsInvited() async {
    List<ContactModel> contacts = [];
    try {
      var result = await httpManager.get(contactsInvited);
      for (var contact in result) {
        contacts.add(ContactModel.fromJson(contact));
      }
      log(' loadContactsInvited: $result');
    } catch (e) {
      log('Load invited contacts error loadContactsInvited: $e');
    }
    return contacts;
  }

  static Future<List<ContactModel>> loadContactsAll() async {
    List<ContactModel> contacts = [];

    try {
      var result = await httpManager.get(contactsAll);
      for (var contact in result) {
        final model = ContactModel.fromJson(contact);
        contacts.add(model);
      }

      log('loadContactsAll: $result');
    } catch (e) {
      log('Load invited contacts error loadContactsAll: $e');
    }

    return contacts;
  }

  static Future<StatusModel> deleteContact(String id) async {
    try {
      var result = await httpManager.delete('$contactDelete/$id');
      log(' deleteContact: $result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Delete contact error deleteContact: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  static Future<StatusModel> shareCard(
      String cardId, Map<String, dynamic> params) async {
    log('$params');
    try {
      var result =
          await httpManager.post('$shareMedCard/$cardId', params: params);
      log('shareCard: $result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Share card error shareCard: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  static Future<StatusModel> cardVerifyRequest(
      String id, String requestType) async {
    try {
      var result = await httpManager.post('$verifyRequest/$id/$requestType');
      log(' cardVerifyRequest: $result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Card verify request error cardVerifyRequest: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  static Future<StatusModel> verifyContact(String id) async {
    try {
      var result = await httpManager.patch('$contactVerify/$id/verify');
      log('verifyContact: $result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Verify contact error verifyContact: $e');
      return StatusModel(
          status: 'error',
          detail: 'error',
          isSuccess: false); // Возврат значения по умолчанию
    }
  }

  static Future<StatusModel> updateContact(
      String id, Map<String, dynamic> data) async {
    log(' updateContact: $data');
    try {
      var result = await httpManager.patch('$contactUpdate/$id',
          data: FormData.fromMap(data));
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Update contact error updateContact: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  /// PATCH /api/contacts/{contact_id}/send_notifications
  /// Включить или отключить отправку уведомлений контакту.
  static Future<dynamic> setContactSendNotifications(
      String contactId, bool sendNotifications) async {
    try {
      var result = await httpManager.patch(
        '$contactSendNotifications/$contactId/send_notifications',
        params: {'send_notifications': sendNotifications},
      );
      log('setContactSendNotifications: $result');
      return result;
    } catch (e) {
      log('setContactSendNotifications error: $e');
      rethrow;
    }
  }

  static Future<StatusModel> addContact(Map<String, dynamic> data) async {
    log('  addContact: $data');
    try {
      var result =
          await httpManager.post(contactAdd, data: FormData.fromMap(data));
      log('  addContact: $result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Add contact error addContact: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  // MedCard
  static Future<UserModel> loadMyInfo() async {
    try {
      var result = await httpManager.get(getMyInfo);
      log(' loadMyInfo: $result');
      final user = UserModel.fromJson(result);
      await Storage.setUserId(user.id);
      return user;
    } catch (e) {
      log('Load my info error loadMyInfo: $e');
      return UserModel(
          id: '0',
          medCardID: '',
          phone: 0,
          personalInfo: PersonalInfo(
            avatar: '',
            full_name: '',
            phone: 0,
            dob: '',
            address: '',
            temporaryAddress: '',
            passport:
                Passport(serial: 0, number: 0, place: '', date: '', photos: []),
          ),
          balance: 0);
    }
  }

  static Future<Map<String, dynamic>> changeBalance(
      Map<String, dynamic> data) async {
    log('$data');
    try {
      log('$data');
      var result = await httpManager.post(change_balance, params: data);
      log('$result');
      return result;
    } catch (e) {
      log('Change balance error changeBalance: $e');
      return {
        "status": "error",
        "isSuccess": false,
        "message": "Request failed"
      };
    }
  }

  static Future<Map<String, dynamic>> deletAccount() async {
    try {
      var result = await httpManager.post(delet_account);
      log('deletAccount:  $result');
      return result;
    } catch (e) {
      log(' error deletAccount: $e');
      return {
        "status": "error",
        "isSuccess": false,
        "message": "Request failed"
      };
    }
  }

  static Future<MedcardModel> loadMyCard() async {
    try {
      var result = await httpManager.get(getMyCard);
      log(' loadMyCard: $result');
      return MedcardModel.fromJson(result);
    } catch (e) {
      log('Load my card error loadMyCard: $e');
      return MedcardModel(
          id: '',
          personalInfo: PersonalInfo(
              avatar: '',
              full_name: '',
              phone: 0,
              dob: '',
              address: '',
              temporaryAddress: '',
              passport: Passport(
                  serial: 0, number: 0, place: '', date: '', photos: [])),
          medInfo: MedInfo(
              bloodType: '',
              policy: 0,
              medicalInsurance:
                  Insurance(number: '', validity: '', name: '', photo: ''),
              drugIntolerance: '',
              allergy: '',
              diagnoses: '',
              vaccinations: '',
              medicationsTaken: []),
          doctorReports: [],
          testsResults: [],
          status: 'error',
          detail: 'error',
          haveCard: false,
          cardType: '',
          animalMedCard: null,
          cerificates: []);
    }
  }

  static Future<bool> updateAnimalMedCard({
    required String cardId,
    required String animalName,
    required String animalType,
    required String animalSize,
    File? animalPhoto,
  }) async {
    try {
      final formData = FormData();

      if (animalPhoto != null) {
        formData.files.add(MapEntry(
          'animal_photo',
          await MultipartFile.fromFile(
            animalPhoto.path,
            filename: animalPhoto.path.split('/').last,
          ),
        ));
      } else {
        formData.fields.add(const MapEntry('animal_photo', ''));
      }

      final result = await httpManager.patch(
        '/api/cards/update/animal/$cardId',
        params: {
          'animal_name': animalName,
          'animal_type': animalType,
          'animal_size': animalSize,
        },
        data: formData,
      );

      log('✅ updateAnimalMedCard response: $result');
      return true;
    } catch (e, s) {
      log('❌ Update animal med card error: $e\n$s');
      return false;
    }
  }

  static Future<List<MedcardModel>> loadOtherCards() async {
    List<MedcardModel> medCardModels = [];
    try {
      var result = await httpManager.get(getOtherCards);
      log(' loadOtherCards : $result');

      if (result is List) {
        List<String> ids = [];

        for (var card in result) {
          medCardModels.add(MedcardModel.fromJson(card));

          final cardId = card['id'];
          if (cardId != null) {
            ids.add(cardId.toString());
          }
        }

        await Storage.setOtherCards(ids);
      }
    } catch (e) {
      log('Load other cards error loadOtherCards: $e');
    }
    return medCardModels;
  }

  static Future<List<MedcardModel>> loadUnverifiedCards() async {
    List<MedcardModel> medcardsModels = [];
    try {
      var result = await httpManager.get(unverifiedCards);
      log('loadUnverifiedCards: $result');
      if (result is List) {
        for (var card in result) {
          medcardsModels.add(MedcardModel.fromJson(card));
        }
      }
    } catch (e) {
      log('Load unverified cards error loadUnverifiedCards: $e');
    }
    return medcardsModels;
  }

  static Future<List<MedcardModel>> loadRequestsToMe() async {
    List<MedcardModel> medcardsModels = [];
    try {
      var result = await httpManager.get(cardRequestsToMe);
      log('loadRequestsToMe: $result');
      if (result is List) {
        for (var card in result) {
          medcardsModels.add(MedcardModel.fromJson(card));
        }
      }
    } catch (e) {
      log('Load requests to me error loadRequestsToMe: $e');
    }
    return medcardsModels;
  }

  static Future<StatusModel> acceptCardRequest(String id) async {
    try {
      var result =
          await httpManager.post("$sendCardRequest/$id/accept_request");
      log('acceptCardRequest: $result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Accept card request error acceptCardRequest: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  static Future<MedcardIdModel> addMedCard(Map<String, dynamic> data) async {
    log('data : $data');
    try {
      var result =
          await httpManager.post(medcardAdd, data: FormData.fromMap(data));
      log('addMedCard: $result');
      return MedcardIdModel.fromJson(result);
    } catch (e) {
      log('Add med card error addMedCard: $e');
      return MedcardIdModel(id: '');
    }
  }

  static Future<MedcardIdModel> addAnimalMedCard({
    required String animalName,
    required String animalType,
    required String animalSize,
    required File animalPhoto,
  }) async {
    try {
      final formData = FormData.fromMap({
        'animal_photo': await MultipartFile.fromFile(
          animalPhoto.path,
          filename: animalPhoto.path.split('/').last,
        ),
      });

      final result = await httpManager.post(
        '/api/cards/add/animal',
        data: formData,
        params: {
          'animal_name': animalName,
          'animal_type': animalType,
          'animal_size': animalSize,
        },
      );

      log('addAnimalMedCard result: $result');
      return MedcardIdModel.fromJson(result);
    } catch (e, s) {
      log('Add animal med card error: $e\n$s');
      return MedcardIdModel(id: '');
    }
  }

  static Future<List<UserModel>> searchUser(Map<String, dynamic> params) async {
    List<UserModel> users = [];
    try {
      var result = await httpManager.get(userSearch, params: params);
      log(' searchUser: ${result['users']}');

      if (result['users'] is List) {
        for (var user in result['users']) {
          users.add(UserModel.fromJson(user));
        }
      }
    } catch (e) {
      log('Search user error searchUser: $e');
    }
    return users;
  }

  static Future<StatusModel> updateCardPersonalInfo(
      Map<String, dynamic> data, String id) async {
    log('data : $data');
    try {
      var result = await httpManager.patch('$updateCard/$id',
          data: FormData.fromMap(data));
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Update card personal info error updateCardPersonalInfo: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  static Future<StatusModel> updateCardPersonalInfoPhoto(
      FormData data, String id) async {
    final formData = data.toString();
    log('updateCardPersonalInfoPhoto data : $formData');
    try {
      var result =
          await httpManager.patch('/api/cards/$id/passport', data: data);
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Update card personal info error updateCardPersonalInfoPhoto: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  static Future<StatusModel> deleteCardVerifyRequest(String id) async {
    try {
      var result = await httpManager.delete('$deleteVerifyRequest/$id/');
      // log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Delete card verify request error deleteCardVerifyRequest: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  static Future<StatusModel> updateMedInsurance(
      Map<String, dynamic> data, String id) async {
    log('data : $data');
    try {
      var result = await httpManager.patch('$updateCard/$id/med_insurance',
          data: FormData.fromMap(data));
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Update med insurance error updateMedInsurance: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  static Future<StatusModel> addMedInfo(
      Map<String, dynamic> params, Map<String, dynamic> data, String id) async {
    log('params : $params');
    log('data : $data');
    log('id : $id');

    try {
      var result = await httpManager.patch(
        '$updateCard/$id/card_item',
        params: params,
        data: FormData.fromMap(data),
      );
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Update med insurance error addMedInfo: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  static Future<StatusModel> deleteCard(String id) async {
    try {
      var result = await httpManager.delete('$updateCard/$id');
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Delete card error deleteCard: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  static Future<StatusModel> doMedCardMine(String id) async {
    try {
      var result = await httpManager.post('$getMyCard/$id');
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Do med card mine error doMedCardMine: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  // Card request
  static Future<StatusModel> sendRequest(String id) async {
    try {
      var result =
          await httpManager.post('$sendCardRequest/$id/create_request');
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Send request error sendRequest: $e');
      return StatusModel(status: 'error', isSuccess: false, detail: '');
    }
  }

  // User info
  static Future loadUserInfo(int phoneNumber) async {
    try {
      var result = await httpManager.get(getUserInfo);
      log('$result');
    } catch (e) {
      log('Load user info error loadUserInfo: $e');
    }
  }

  // Other API requests

  // Get air pollution (OpenWeather)
  static Future<AirQualityResponse> loadAirPollution(
      Map<String, dynamic> params) async {
    try {
      var result = await httpManager2.get(getAirPollution,
          params: params, baseUrl: EnvService().openWeatherUrl);
      // log('$result');
      return AirQualityResponse.fromJson(result);
    } catch (e) {
      log('Air pollution load error loadAirPollution: $e');
      return AirQualityResponse(haveData: false, list: []);
    }
  }

  // Get weather (OpenWeather)
  static Future<WeatherForecast> loadWeather(
      Map<String, dynamic> params) async {
    try {
      var result = await httpManager2.get(getWeather,
          params: params, baseUrl: EnvService().openWeatherUrl);
      // log('$result');
      return WeatherForecast.fromJson(result);
    } catch (e) {
      log('Weather load error loadWeather: $e');
      return WeatherForecast(
          haveData: false, currentTemperature: 0, forecast: []);
    }
  }

  // Get pressure (OpenMeteo)
  static Future<PressureAndWindData> loadPressure(
      Map<String, dynamic> params) async {
    try {
      var result = await httpManager2.get(getPressure,
          params: params, baseUrl: EnvService().openMeteoUrl);
      // log('$result');
      return PressureAndWindData.fromJson(result);
    } catch (e) {
      log('Pressure load error WindData loadPressure: $e');
      return PressureAndWindData(
          haveData: false,
          currentPressure: 0,
          currentWindDirection: 0,
          pressureList: [],
          currentWindSpeed: 0,
          date: [],
          windDirectionList: [],
          windSpeedList: [],
          currentDewPoint: 0,
          currentPrecipitation: 0);
    }
  }

  // request
  static Future<RequestStatusModel> createRequest(FormData data) async {
    log(' createRequest data : $data');
    try {
      var result = await httpManager.post('/api/requests/create', data: data);

      log('API Response: $result');

      if (result == null) {
        throw Exception('API response is null');
      }
      log('$result');
      return RequestStatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error RequestStatusModel createRequest: $e');
      return RequestStatusModel(
          status: 'error', detail: 'error', isSuccess: false, requestId: '');
    }
  }

  static Future<Map<String, dynamic>?> getLocation(
      String groupId, bool hasCar) async {
    log('getGroupLocation groupId: $groupId');
    try {
      final result = hasCar
          ? await httpManager.get(
              '/api/requests/get_car_geolocation',
              params: {'group_id': groupId},
            )
          : await httpManager.get(
              '/api/requests/get_group_location',
              params: {'group_id': groupId},
            );

      log('API Response: $result');

      if (result == null) {
        throw Exception('API response is null');
      }

      return result as Map<String, dynamic>;
    } catch (e) {
      log('Error in getGroupLocation: $e');
      return null;
    }
  }

  static Future<RequestStatusModel> callCar(String requestId) async {
    final queryParams = {'request_id': requestId};

    try {
      final result = await httpManager.post(
        '/api/requests/call_car',
        params: queryParams,
      );

      if (result == null) {
        throw Exception('API response is null');
      }

      return RequestStatusModel.fromJson(result);
    } catch (e) {
      log('callCar error: $e');
      return RequestStatusModel(
        status: 'error',
        detail: 'error',
        isSuccess: false,
        requestId: '',
      );
    }
  }

  static Future<StatusModel> deleteRequest(Map<String, dynamic> params) async {
    log('$params');
    try {
      var result =
          await httpManager.delete('/api/requests/delete', params: params);
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error deleteRequest deleteRequest: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  static Future<StatusModel> updateRequest(
      Map<String, dynamic> params, data) async {
    log('$params');
    log('$data');
    try {
      final requestId = params.values.first;
      var result = await httpManager.put('/api/requests/update',
          params: params, data: FormData.fromMap(data));
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error updateRequest: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  static Future<List<RequestModel>> getContactsRequests() async {
    List<RequestModel> requestsList = [];
    try {
      var result = await httpManager.get('/api/requests/get_contacts_requests');
      log('get getContactsRequests: $result');
      for (var request in result) {
        requestsList.add(RequestModel.fromJson(request, false));
      }
      return requestsList;
    } catch (e) {
      log('Pressure load error getContactsRequests: $e');
      return [];
    }
  }

  static Future<void> printText() {
    print('Hello from ApiService');
    return Future.value();
  }

  static Future<List<ChatRoom>> getServicesChat() async {
    List<ChatRoom> serviceList = [];
    try {
      var result = await httpManager.get('/api/services/chat/list');
      log('getServicesChat \n :  \n  $result');
      for (var service in result) {
        serviceList.add(ChatRoom.fromJson(service));
      }
      return serviceList;
    } catch (e) {
      log('Pressure load error getServicesChat: $e');
      return [];
    }
  }

  static Future<bool> bookAppointment({
    required DateTime appointmentTime,
    required String serviceId,
    required String cardId,
    required String problem,
    File? paymentFile,
  }) async {
    try {
      final formMap = {
        'appointment_time': appointmentTime,
        'service_id': serviceId,
        'card_id': cardId,
        'problem': problem,
      };

      if (paymentFile != null) {
        formMap['payment_file'] = (await MultipartFile.fromFile(
          paymentFile.path,
          filename: paymentFile.path.split('/').last,
        )) as String;
      }

      FormData formData = FormData.fromMap(formMap);

      final response = await httpManager.post(
        '/api/services/book_appointment',
        data: formData,
      );

      if (response == null) {
        log('❌ bookAppointment response is null');
        return false;
      }

      log('✅ Appointment booked: $response');
      return true;
    } catch (e) {
      log('❌ bookAppointment error: $e');
      return false;
    }
  }

  static Future<List<ChatRoom>> getServicesChatUsers(String userId) async {
    List<ChatRoom> serviceList = [];
    try {
      var result = await httpManager.get('/api/services/chat/$userId');

      log('getServicesUsersChat \n :  $result');
      for (var service in result) {
        serviceList.add(ChatRoom.fromJson(service));
      }
      return serviceList;
    } catch (e) {
      log('Pressure load error getServicesChatUsers: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getAppointments(String? type) async {
    List<dynamic> appointmentList = [];
    try {
      var result = await httpManager.get('/api/services/get_appointments');

      log('getAppointments \n :  $result');

      for (var item in result) {
        if (type == null || item['service']?['institution_type'] == type) {
          appointmentList.add(item);
        }
      }
      return appointmentList;
    } catch (e) {
      log('Error getAppointments: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getStatments(String? type) async {
    List<dynamic> appointmentList = [];
    try {
      var result = await httpManager.get('/api/services/get_statements');

      log('getAppointments \n :  $result');

      for (var item in result) {
        if (type == null || item['service']?['institution_type'] == type) {
          appointmentList.add(item);
        }
      }
      return appointmentList;
    } catch (e) {
      log('Error getAppointments: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> postChatService(FormData data) async {
    try {
      final result =
          await httpManager.post('/api/services/chat/send', data: data);
      log('Result from deleteAidKitRequest API: $result');

      // Ensure response is properly formatted
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      log('Error in deleteAidKitRequest API: $e');
      throw Exception("Failed to delete deleteAidKitRequest" + e.toString());
    }
  }

  static Future<void> seenContactRequest(Map<String, dynamic> params) async {
    try {
      var result = await httpManager.post('/api/requests/seen_contact_request',
          params: params);
      log('get req $result');
    } catch (e) {
      log('Pressure load error seenContactRequest: $e');
    }
  }

  static Future<void> seenContactRequest112(Map<String, dynamic> params) async {
    try {
      var result = await httpManager
          .post('/api/requests/112/seen_contact_request', params: params);
      log('get req $result');
    } catch (e) {
      log('Pressure load error seenContactRequest112: $e');
    }
  }

  // request 112
  static Future<RequestStatusModel> createRequest112(
      Map<String, dynamic> data) async {
    log('$data');
    try {
      var result = await httpManager.post('/api/requests/112/create',
          data: FormData.fromMap(data));
      log('$result');
      return RequestStatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error createRequest112: $e');
      return RequestStatusModel(
          status: 'error', detail: 'error', isSuccess: false, requestId: '');
    }
  }

  static Future<List<String>> getVideo112(String requestId) async {
    try {
      final result =
          await httpManager.get('/api/requests/112/videos/$requestId');

      final List<String> videos = (result['videos'] as List).cast<String>();

      return videos;
    } catch (e) {
      log('getVideo112 error: $e');
      return [];
    }
  }

  /// GET /api/requests/favours/{institution_id} → { "status": "success", "favours": [{ institution_id, name, duration, price, type, id }] }
  static Future<List<Map<String, dynamic>>> getRequestFavours(
      String institutionId) async {
    try {
      final result =
          await httpManager.get('/api/requests/favours/$institutionId');
      log('getRequestFavours result: $result');

      if (result['favours'] != null && result['favours'] is List) {
        return List<Map<String, dynamic>>.from(
            (result['favours'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
      }
      return [];
    } catch (e) {
      log('Error getRequestFavours: $e');
      return [];
    }
  }

  static Future<StatusModel> deleteRequest112(
      Map<String, dynamic> params) async {
    log('$params');
    try {
      var result =
          await httpManager.delete('/api/requests/112/delete', params: params);
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error deleteRequest112: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  static Future<StatusModel> updateRequest112(
      Map<String, dynamic> params, data) async {
    log('$params');
    log('$data');
    try {
      var result = await httpManager.put('/api/requests/112/update',
          params: params, data: FormData.fromMap(data));
      log('$result');
      return StatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error updateRequest112: $e');
      return StatusModel(status: 'error', detail: 'error', isSuccess: false);
    }
  }

  static Future<List<RequestModel>> getContactsRequests112() async {
    List<RequestModel> requestsList = [];
    try {
      var result =
          await httpManager.get('/api/requests/112/get_contacts_requests');
      for (var request in result) {
        requestsList.add(RequestModel.fromJson(request, true));
      }
      return requestsList;
    } catch (e) {
      log('Pressure load error getContactsRequests112: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getRequests112() async {
    try {
      final result = await httpManager.get('/api/requests/112/get');
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      log('Pressure load error getRequests112: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getRequests112Archive() async {
    try {
      final result = await httpManager.get('/api/requests/112/archive');
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      log('Pressure load error getRequests112Archive: $e');
      return [];
    }
  }

  /// Archive of requests (institutions: med, pol, mch). Returns all; filter by type on client.
  static Future<List<Map<String, dynamic>>> getRequestsArchive() async {
    try {
      final result = await httpManager.get('/api/requests/archive');
      return List<Map<String, dynamic>>.from(result);
    } catch (e) {
      log('getRequestsArchive error: $e');
      return [];
    }
  }

  static Future<List<ServiceModel>> getServices(
      Map<String, dynamic> params) async {
    List<ServiceModel> serviceList = [];
    try {
      var result =
          await httpManager.get('$requests/get_services', params: params);
      log('log $result');
      for (var service in result) {
        serviceList.add(ServiceModel.fromJson(service));
      }
      return serviceList;
    } catch (e) {
      log('Pressure load error getServices: $e');
      return [];
    }
  }

  static Future<List<DangerModel>> getDangerIcons(
      Map<String, dynamic> params) async {
    List<DangerModel> dangerIcons = [];
    try {
      var result = await httpManager.get(getIcons, params: params);
      log('icons $result');

      if (result != null && result['icons'] is List) {
        for (var icon in result['icons']) {
          dangerIcons.add(DangerModel.fromJson(icon));
        }
      }
      return dangerIcons;
    } catch (e) {
      log('Danger icons load error: $e');
      return [];
    }
  }

  static Future<List<RequestModel>> getNotficationIcons(
      Map<String, dynamic> params) async {
    // List<DangerModel> dangerIcons = [];
    try {
      var response =
          await httpManager.get('/api/users/notifications', params: params);
      log('getNotficationIcons $response');

      // if (result != null && result['icons'] is List) {
      //   for (var icon in result['icons']) {
      //     dangerIcons.add(DangerModel.fromJson(icon));
      //   }
      // }
      List<RequestModel> reqs = [];
      if (response != null) {
        if (response['new_requests'] != null) {
          reqs = List<RequestModel>.from(response['new_requests'].map((e) {
            return RequestModel.fromJson(e, false);
          }));
        }
        if (response['new_112_requests'] != null) {
          List<RequestModel> items =
              List<RequestModel>.from(response['new_112_requests'].map((e) {
            return RequestModel.fromJson(e, true);
          }));
          reqs.addAll(items);
        }
      }
      return reqs;
    } catch (e) {
      log('Danger icons load error: $e');
      return [];
    }
  }

  static Future<List<DangerModel>> getAllDangerIcons() async {
    List<DangerModel> dangerIcons = [];
    try {
      var result = await httpManager.get(getAllIcons);
      log('icons $result');

      if (result != null && result['icons'] is List) {
        for (var icon in result['icons']) {
          dangerIcons.add(DangerModel.fromJson(icon));
        }
      }
      return dangerIcons;
    } catch (e) {
      log('Danger icons load error: $e');
      return [];
    }
  }

  static const String favouriteInstitutions =
      '/api/requests/favourite_institutions';
  static const String favouriteInstitution =
      '/api/requests/favourite_institution';

  static Future<List<InstitutionModel>> getInstitutions(
      Map<String, dynamic> params) async {
    List<InstitutionModel> institutionList = [];
    log('getInstitutions: $params');
    try {
      var result = await httpManager.get('/api/requests/get_institutions',
          params: params);
      log('getInstitutions: $result');
      List<dynamic> list = result is List
          ? result
          : (result is Map && (result['results'] != null || result['data'] != null || result['institutions'] != null))
              ? (result['results'] ?? result['data'] ?? result['institutions'] ?? []) as List<dynamic>
              : <dynamic>[];
      for (var item in list) {
        if (item is Map) {
          institutionList.add(InstitutionModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
      return institutionList;
    } catch (e) {
      log('Pressure load error getInstitutions: $e');
      return [];
    }
  }

  /// GET /api/requests/favourite_institutions
  static Future<dynamic> getFavouriteInstitutions() async {
    try {
      final result = await httpManager.get(favouriteInstitutions);
      return result;
    } catch (e) {
      log('getFavouriteInstitutions error: $e');
      rethrow;
    }
  }

  /// POST /api/requests/favourite_institution — body: application/x-www-form-urlencoded institution_id
  static Future<dynamic> postFavouriteInstitution(String institutionId) async {
    try {
      final result = await httpManager.postForm(
        favouriteInstitution,
        data: {'institution_id': institutionId},
      );
      return result;
    } catch (e) {
      log('postFavouriteInstitution error: $e');
      rethrow;
    }
  }

  /// DELETE /api/requests/favourite_institution — body: application/x-www-form-urlencoded institution_id
  static Future<dynamic> deleteFavouriteInstitution(String institutionId) async {
    try {
      final result = await httpManager.deleteForm(
        favouriteInstitution,
        data: {'institution_id': institutionId},
      );
      return result;
    } catch (e) {
      log('deleteFavouriteInstitution error: $e');
      rethrow;
    }
  }

  /// POST /api/reviews/institutions — Create Institution Review
  /// Request body: application/x-www-form-urlencoded (text, rating, institution_id)
  static Future<dynamic> postInstitutionReview(
      Map<String, dynamic> data) async {
    try {
      final result = await httpManager.postForm(reviewsInstitutions, data: data);
      return result;
    } catch (e) {
      log('postInstitutionReview error: $e');
      rethrow;
    }
  }

  /// GET /api/reviews/institutions/{institution_id} — Get Institution Reviews
  static Future<List<Review>> getInstitutionReviews(String institutionId) async {
    try {
      final result = await httpManager.get('$reviewsInstitutions/$institutionId');
      if (result is List) {
        return result.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      log('getInstitutionReviews error: $e');
      return [];
    }
  }

  /// DELETE /api/reviews/institutions/{review_id} — Delete Institution Review
  static Future<dynamic> deleteInstitutionReview(String reviewId) async {
    try {
      final result = await httpManager.delete('$reviewsInstitutions/$reviewId');
      return result;
    } catch (e) {
      log('deleteInstitutionReview error: $e');
      rethrow;
    }
  }

  /// GET /api/reviews/institutions/{institution_id}/average_rating
  static Future<Map<String, dynamic>> getInstitutionAverageRating(
      String institutionId) async {
    try {
      final result = await httpManager
          .get('$reviewsInstitutions/$institutionId/average_rating');
      return result is Map<String, dynamic> ? result : {};
    } catch (e) {
      log('getInstitutionAverageRating error: $e');
      return {};
    }
  }

  static Future<RequestStatusModel> createCall(
      Map<String, dynamic> data) async {
    log('$data');
    try {
      var result = await httpManager.post('$requests/create_call',
          data: FormData.fromMap(data));
      log('log $result');
      return RequestStatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error createCall: $e');
      return RequestStatusModel(
          status: '', detail: '', isSuccess: false, requestId: '');
    }
  }

  static Future<RequestStatusModel> createStatement(
      Map<String, dynamic> data) async {
    log('$data');
    try {
      var result = await httpManager.post('$requests/create_statement',
          data: FormData.fromMap(data));
      return RequestStatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error createStatement: $e');
      return RequestStatusModel(
          status: '', detail: '', isSuccess: false, requestId: '');
    }
  }

  static Future<RequestStatusModel> createAppointment(
      Map<String, dynamic> data) async {
    try {
      var result = await httpManager.post('$requests/book_appointment',
          data: FormData.fromMap(data));
      return RequestStatusModel.fromJson(result);
    } catch (e) {
      log('Pressure load error createAppointment: $e');
      return RequestStatusModel(
          status: '', detail: '', isSuccess: false, requestId: '');
    }
  }

  static Future<List<ServiceModel2>> getFavorites() async {
    List<ServiceModel2> serviceList = [];
    try {
      var result = await httpManager.get(favorites);
      log('log favg $result');
      for (var service in result) {
        serviceList.add(ServiceModel2.fromJson(service));
      }
      return serviceList;
    } catch (e) {
      log('Pressure load error getFavorites: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> postFavorites(String id) async {
    try {
      var result = await httpManager.post('$favorites/$id');
      log('result favp $result');
      return result;
    } catch (e) {
      log('Pressure load error postFavorites: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<Map<String, dynamic>> deleteFavorite(String id) async {
    try {
      final result = await httpManager.delete(
        '/api/favorites/$id',
      );
      log('Result from deleteFavorite API: $result');

      // Ensure response is properly formatted
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      log('Error in deleteFavorite API: $e');
      throw Exception("Failed to delete favorite" + e.toString());
    }
  }

  static Future<Map<String, dynamic>> getAverageRating(String id) async {
    try {
      var result = await httpManager.get('$average_rating/$id/average_rating');
      log('log getAverageRating $result');

      return result;
    } catch (e) {
      log('Pressure load error getAverageRating: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<List<Review>> getReviews(String id) async {
    List<Review> reviewList = [];
    try {
      var result = await httpManager.get('$reviews/$id');
      log('log getReviews $result');
      for (var review in result) {
        reviewList.add(Review.fromJson(review));
      }
      return reviewList;
    } catch (e) {
      log('Pressure load error getReviews: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> postReviews(
      Map<String, dynamic> data) async {
    try {
      var result =
          await httpManager.post(reviews, data: FormData.fromMap(data));
      log('$data');
      log('result postReviews $result');
      return result;
    } catch (e) {
      log('Pressure load error postFavorites: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<Map<String, dynamic>> deleteReviews(String id) async {
    try {
      final result = await httpManager.delete(
        '$reviews/$id',
      );
      log('Result from deleteReviews API: $result');

      // Ensure response is properly formatted
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      log('Error in deleteReviews API: $e');
      throw Exception("Failed to delete favorite" + e.toString());
    }
  }

  static Future<List<AidKitItem>> getMedicinesById(String id) async {
    List<AidKitItem> aidKitItemList = [];
    try {
      var result = await httpManager.get('$medical_bag_get_id/$id');
      log('log getMedicinesById $result');
      for (var medicines in result['medicines']) {
        aidKitItemList.add(AidKitItem.fromJson(medicines));
      }
      return aidKitItemList;
    } catch (e) {
      log('Pressure load error getMedicinesById: $e');
      return [];
    }
  }

  static Future<List<MedicineItem>> getMedicines() async {
    List<MedicineItem> aidKitItemList = [];
    try {
      var result = await httpManager.get(medicines);
      log('log getMedicines $result');
      for (var medicines in result) {
        aidKitItemList.add(MedicineItem.fromJson(medicines));
      }
      return aidKitItemList;
    } catch (e) {
      log('Pressure load error getMedicines: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> postMedicines(FormData data) async {
    try {
      var result = await httpManager.post(medicines, data: data);
      log('$data');
      log('result postMedicines $result');
      return result;
    } catch (e) {
      log('Pressure load error postFavorites: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<Map<String, dynamic>> deleteMedicines(String id) async {
    try {
      final result = await httpManager.delete(
        '$medicines/$id',
      );
      log('Result from deleteReviews API: $result');

      // Ensure response is properly formatted
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      log('Error in deleteReviews API: $e');
      throw Exception("Failed to delete favorite" + e.toString());
    }
  }

  static Future<Map<String, dynamic>> putMedicines(FormData data) async {
    try {
      var result = await httpManager.put(medicines, data: data);
      log('$data');
      log('result putAidKit $result');
      return result;
    } catch (e) {
      log('Pressure load error putAidKit: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<List<AidKitModel>> getAidKit() async {
    List<AidKitModel> aidKitList = [];
    try {
      var result = await httpManager.get(medical_bag);
      log('log getAidKit $result');
      for (var review in result) {
        aidKitList.add(AidKitModel.fromJson(review));
      }
      return aidKitList;
    } catch (e) {
      log('Pressure load error getAidKit: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> postAidKit(FormData data) async {
    try {
      var result = await httpManager.post(medical_bag, data: data);
      log('$data');
      log('result postAidKit $result');
      return result;
    } catch (e) {
      log('Pressure load error postAidKit: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<Map<String, dynamic>> deleteAidKit(String id) async {
    try {
      final result = await httpManager.delete(
        '$medical_bag/$id',
      );
      log('Result from deleteAidKit API: $result');

      // Ensure response is properly formatted
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      log('Error in deleteAidKit API: $e');
      throw Exception("Failed to delete favorite" + e.toString());
    }
  }

  static Future<Map<String, dynamic>> putAidKit(FormData data) async {
    try {
      var result = await httpManager.put(medical_bag, data: data);
      log('$data');
      log('result putAidKit $result');
      return result;
    } catch (e) {
      log('Pressure load error putAidKit: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<Map<String, dynamic>> postFCMToken(FormData data) async {
    try {
      var result = await httpManager.post(sent_fcm_token, data: data);
      log('$data');
      log('result postFCMToken $result');
      return result;
    } catch (e) {
      log('Pressure load error postFCMToken: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<List<AidKitModel>> getIntakeTimeUser(String day) async {
    List<AidKitModel> aidIntakeTime = [];
    try {
      var result = await httpManager.get(medicines_intake_time, params: day);
      log('log getIntakeTimeUser $result');
      for (var review in result) {
        aidIntakeTime.add(AidKitModel.fromJson(review));
      }
      return aidIntakeTime;
    } catch (e) {
      log('Pressure load error getIntakeTimeUser: $e');
      return [];
    }
  }

  static Future<List<MedicineIntakeTime>> getIntakeTime(String day) async {
    List<MedicineIntakeTime> aidIntakeTime = [];
    try {
      var result =
          await httpManager.get(medicines_intake_time, params: {'day': day});
      log('log getIntakeTime $result');
      for (var review in result) {
        aidIntakeTime.add(MedicineIntakeTime.fromJson(review));
      }
      return aidIntakeTime;
    } catch (e) {
      log('Pressure load error getIntakeTime: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> postIntakeTime(FormData data) async {
    try {
      var result = await httpManager.post(medicines_intake_time, data: data);
      log('$data');
      log('result postIntakeTime $result');
      return result;
    } catch (e) {
      log('Pressure load error postIntakeTime: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<dynamic> fetchCallsData(String type, String cardId) async {
    return await Api.getLatestRequestsPerPersonByType(type, cardId);
  }

  static Future<dynamic> getLatestRequestsPerPersonByType(
      String type, String cardId) async {
    try {
      final myId = await Storage.getUserId();
      if (myId == null) return {};

      final response = await httpManager.get('/api/requests/get');

      if (response is List) {
        late final List filtered;
        if (type == 'any') {
          filtered = response
              .where((e) =>
                  e['card_id'] == cardId && e['status'] != 'done')
              .toList();
          return filtered;
        } else {
          filtered = response
              .where((e) =>
                  e['type'] == type &&
                  e['card_id'] == cardId &&
                  e['status'] != 'done')
              .toList();
        }

        final Map<String, Map<String, dynamic>> userCall = {};

        for (final item in filtered) {
          final cardId = item['card_id'];
          final createdAt = DateTime.parse(item['created_at']);

          if (!userCall.containsKey(cardId) ||
              createdAt
                  .isAfter(DateTime.parse(userCall[cardId]!['created_at']))) {
            userCall[cardId] = item;
          }
        }

        return userCall;
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  static Future<bool> createStatementPol({
    required String reason,
    required String serviceId,
    required String cardId,
    File? paymentFile,
    required String description,
    List<File>? attachments,
  }) async {
    try {
      final formMap = {
        'reason': reason,
        'service_id': serviceId,
        'card_id': cardId,
        'description': description,
      };

      if (paymentFile != null) {
        formMap['payment_file'] = (await MultipartFile.fromFile(
          paymentFile.path,
          filename: paymentFile.path.split('/').last,
        )) as String;
      }

      if (attachments != null && attachments.isNotEmpty) {
        formMap['attachments'] = (await Future.wait(
          attachments.map((file) async => await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              )),
        )) as String;
      }

      FormData formData = FormData.fromMap(formMap);

      final response = await httpManager.post(
        '/api/services/create_statement',
        data: formData,
      );

      if (response == null) {
        log('❌ createStatement response is null');
        return false;
      }

      log('✅ Statement created: $response');
      return true;
    } catch (e) {
      log('❌ createStatement error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getLatestRequestsPerPersonByCard(
      String cardId) async {
    try {
      final myId = await Storage.getUserId();

      if (myId == null) return {};

      final response = await httpManager.get('/api/requests/get');

      if (response is List) {
        final filtered = response.where((e) => e['card_id'] == cardId).toList();

        final Map<String, Map<String, dynamic>> userCall = {};

        for (final item in filtered) {
          final createdAt = DateTime.parse(item['created_at']);

          if (!userCall.containsKey(cardId) ||
              createdAt
                  .isAfter(DateTime.parse(userCall[cardId]!['created_at']))) {
            userCall[cardId] = item;
          }
        }

        return userCall;
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  static Future<Map<String, dynamic>> deleteIntakeTime(String id) async {
    try {
      final result = await httpManager.delete(
        '$medicines_intake_time/$id',
      );
      log('Result from deleteIntakeTime API: $result');

      // Ensure response is properly formatted
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      log('Error in deleteIntakeTime API: $e');
      throw Exception("Failed to delete deleteIntakeTime" + e.toString());
    }
  }

  static Future<Map<String, dynamic>> putIntakeTime(FormData data) async {
    try {
      var result = await httpManager.put(medicines_intake_time, data: data);
      log('$data');
      log('result putIntakeTime $result');
      return result;
    } catch (e) {
      log('Pressure load error putIntakeTime: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<List<AidKitModel>> getAidKitUser(String user_id) async {
    List<AidKitModel> aidIntakeTime = [];
    try {
      var result = await httpManager.get('$medical_bag_user/$user_id');
      log('log getAidKitUser $result');
      for (var review in result) {
        aidIntakeTime.add(AidKitModel.fromJson(review));
      }
      return aidIntakeTime;
    } catch (e) {
      log('Pressure load error getAidKitUser: $e');
      return [];
    }
  }

  static Future<List<AidKitModel>> getAidKitRequest() async {
    List<AidKitModel> aidIntakeTime = [];
    try {
      var result = await httpManager.get(
        '/api/medicines/aid_kit/request',
      );
      log('log getAidKitRequest $result');
      for (var review in result) {
        aidIntakeTime.add(AidKitModel.fromJson(review));
      }
      return aidIntakeTime;
    } catch (e) {
      log('Pressure load error getAidKitRequest: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> postAidKitRequest(String data) async {
    try {
      var result = await httpManager.post("/api/medicines/aid_kit/request/",
          params: data);
      log('$data');
      log('result postAidKitRequest $result');
      return result;
    } catch (e) {
      log('Pressure load error postAidKitRequest: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }

  static Future<Map<String, dynamic>> deleteAidKitRequest(String id) async {
    try {
      final result = await httpManager.delete(
        '$medicines_intake_time/$id',
      );
      log('Result from deleteAidKitRequest API: $result');

      // Ensure response is properly formatted
      if (result is Map<String, dynamic>) {
        return result;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      log('Error in deleteAidKitRequest API: $e');
      throw Exception("Failed to delete deleteAidKitRequest" + e.toString());
    }
  }

  static Future<Map<String, dynamic>> putAidKitRequest(FormData data) async {
    try {
      var result = await httpManager.put(medicines_intake_time, data: data);
      log('$data');
      log('result putAidKitRequest $result');
      return result;
    } catch (e) {
      log('Pressure load error putAidKitRequest: $e');
      return {
        "status": "error",
        "message": "Request failed",
        "isSuccess": false,
      };
    }
  }
}
