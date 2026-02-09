import 'dart:developer';
import 'dart:io';
import 'package:careme24/blocs/medcard/medcard_state.dart';
import 'package:careme24/models/medcard/medcard_id_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/status_model.dart';
import 'package:careme24/models/user_model.dart';
import 'package:careme24/repositories/medcard_repository.dart';
import 'package:careme24/service/database_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedCardCubit extends Cubit<MedCardState> {
  MedCardCubit() : super(MedCardLoading());

  Future<void> fetchData() async {
    MedcardModel myCard = MedcardModel(
        id: '',
        personalInfo: PersonalInfo(
          avatar: '',
          full_name: '',
          phone: 0,
          dob: '',
          address: '',
          temporaryAddress: '',
          passport: Passport(
            serial: 0,
            number: 0,
            place: '',
            date: '',
            photos: [],
          ),
        ),
        medInfo: MedInfo(
          bloodType: '',
          policy: 0,
          medicalInsurance: Insurance(
            number: '',
            validity: '',
            name: '',
            photo: '',
          ),
          drugIntolerance: '',
          allergy: '',
          diagnoses: '',
          vaccinations: '',
          medicationsTaken: [],
        ),
        doctorReports: [],
        testsResults: [],
        cerificates: [],
        status: '',
        detail: '',
        haveCard: false,
        cardType: '',
        animalMedCard: null);

    List<MedcardModel> otherCards = [];
    List<MedcardModel> unverifiedCards = [];
    List<MedcardModel> toMeRequests = [];

    emit(MedCardLoading());

    try {
      final result = await (Connectivity().checkConnectivity());

      if (result[0] == ConnectivityResult.none) {
        var fetchedMyCard = await DatabaseHelper.instance.fetchMyCard();
        myCard = fetchedMyCard ?? myCard;
        otherCards = await DatabaseHelper.instance.fetchAllMedcards();
      } else {
        myCard = await MedcardRepository.fetchMyCard();
        otherCards = await MedcardRepository.fetchOtherCards();
        unverifiedCards = await MedcardRepository.fetchUnverifiedCards();
        toMeRequests = await MedcardRepository.fetchRequestsToMe();

        await DatabaseHelper.instance.updateMyCard(myCard);
        if (otherCards.isNotEmpty) {
          //await DatabaseHelper.instance.updateOtherCards(otherCards);
        }

        var fetchedMyCard = await DatabaseHelper.instance.fetchMyCard();
        log(fetchedMyCard!.id);
      }
      final animalCards =
          otherCards.where((e) => e.cardType == 'animal').toList();

      // մնացած քարտերը՝ առանց animal-ների
      final humanCards =
          otherCards.where((e) => e.cardType != 'animal').toList();

      emit(MedCardLoaded(
        myCard: myCard,
        otherCards: humanCards,
        unverifiedCards: unverifiedCards,
        toMeRequests: toMeRequests,
        animalCards: animalCards, // ✅ ավելացրու այս դաշտը state-ում
      ));

      emit(MedCardLoaded(
        myCard: myCard,
        otherCards: otherCards,
        unverifiedCards: unverifiedCards,
        toMeRequests: toMeRequests,
        animalCards: animalCards,
      ));
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<MedcardIdModel> addMedCard(Map<String, dynamic> data) async {
    final response = await MedcardRepository.addMedCard(data);
    return response;
  }

  Future<StatusModel> doMedCardMine(String id) async {
    final response = await MedcardRepository.doMedCardMine(id);
    return response;
  }

  Future<StatusModel> updatePersonalInfo(
      Map<String, dynamic> data, String id) async {
    final response = await MedcardRepository.updatePersonalInfo(data, id);
    return response;
  }

  Future<StatusModel> updatePersonalInfoPhoto(
    String id,
    int serial,
    int number,
    String placeOfIssue,
    String residence,
    String date,
    List<File> photos,
  ) async {
    FormData formData = FormData.fromMap({
      "serial": serial,
      "number": number,
      "place_of_issue": placeOfIssue,
      "residence": residence,
      "date": date,
    });

    // Attach photos
    for (var file in photos) {
      formData.files.add(MapEntry(
        "photos",
        await MultipartFile.fromFile(file.path),
      ));
    }

    final response =
        await MedcardRepository.updatePersonalInfoPhoto(formData, id);
    return response;
  }

  Future<StatusModel> updateMedInsurance(
      Map<String, dynamic> data, String id) async {
    final response = await MedcardRepository.updateMedInsurance(data, id);
    return response;
  }

  Future<StatusModel> addMedInfo(
      Map<String, dynamic> params, Map<String, dynamic> data, String id) async {
    final response = await MedcardRepository.addMedItem(params, data, id);
    return response;
  }

  Future<StatusModel> deleteCard(String id) async {
    final response = await MedcardRepository.deleteCard(id);
    return response;
  }

  Future<StatusModel> deleteCardVerifyRequest(String id) async {
    final response = await MedcardRepository.deleteCardVerifyRequest(id);
    return response;
  } //TODO: ne nujno

  Future<StatusModel> cardVerifyRequest(String id, String requestType) async {
    final response = await MedcardRepository.cardVerifyRequest(id, requestType);
    return response;
  }

  Future<StatusModel> shareCard(
      String cardId, Map<String, dynamic> params) async {
    final response = await MedcardRepository.shareCard(cardId, params);
    return response;
  }

  Future<StatusModel> sendRequest(String id) async {
    final response = await MedcardRepository.sendRequest(id);
    return response;
  }

  Future<StatusModel> acceptCardRequest(String id) async {
    final response = await MedcardRepository.acceptCardRequest(id);
    return response;
  }

  Future<List<UserModel>> searchUser(Map<String, dynamic> params) async {
    final response = await MedcardRepository.searchUser(params);
    return response;
  }
}
