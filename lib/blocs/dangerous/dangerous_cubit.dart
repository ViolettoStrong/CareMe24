import 'dart:developer';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/dangerous/dangerous_state.dart';
import 'package:careme24/features/danger_icons/controller/danger_icons_ctrl.dart';
import 'package:careme24/injection_container.dart';
import 'package:careme24/models/contacts/contacts_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/request_model.dart';
import 'package:careme24/repositories/contacts_repository.dart';
import 'package:careme24/repositories/medcard_repository.dart';
import 'package:careme24/service/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DangerousCubit extends Cubit<DangerousState> with ChangeNotifier {
  DangerousCubit() : super(DangerousInit());

  DangerIconsCtrl dangerIconsCtrl = getIt<DangerIconsCtrl>();

  bool isGeolocationEnable = false;
  double lat = 0.0;
  double lon = 0.0;
  String addres = '';
  String city = '';
  List<RequestModel> requests = [];
  List<ContactModel> contactsUnverified = [];

  List<String> latestRequestIds = [];

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
          medicalInsurance:
              Insurance(number: '', validity: '', name: '', photo: ''),
          drugIntolerance: '',
          allergy: '',
          diagnoses: '',
          vaccinations: '',
          medicationsTaken: []),
      doctorReports: [],
      testsResults: [],
      cerificates: [],
      status: '',
      detail: '',
      haveCard: false,
      cardType: '',
      animalMedCard: null);

  getLocation() async {
    emit(DangerousLoading());

    /* final token

    if () {
        await TokenManager.deleteToken();
        await PrefService.delete();
        Navigator.pushReplacementNamed(context, AppRouter.startPage);
    } */

    bool notifMe = await PrefService.isNotifMe();
    if (notifMe) {
      contactsUnverified = await ContactsRepository.loadContactsUnverified();
    }
    myCard = await MedcardRepository.fetchMyCard();

    final status = await Permission.location.request();

    if (status.isGranted) {
      if (lat == 0) {
        Position location = await Geolocator.getCurrentPosition();
        log("latitude "
            '${location.latitude}" longitude "+ ${location.longitude}');
        lat = location.latitude;
        lon = location.longitude;

        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
        city = placemarks.first.locality ?? '';
        String street = placemarks.first.street ?? '';
        addres = '$city $street';
      }

      AppBloc.requestCubit.getLocation();
      fetchData();
    } else if (status.isPermanentlyDenied) {
      isGeolocationEnable = false;
      openAppSettings();

      emit(
        DangerousLoaded(
          myMedCard: myCard,
          showcontactNotif: contactsUnverified.isNotEmpty,
          requests: [],
          city: '',
          address: 'Нет данных',
          isGeoEnable: isGeolocationEnable,
        ),
      );
    } else {
      emit(
        DangerousLoaded(
          myMedCard: myCard,
          showcontactNotif: contactsUnverified.isNotEmpty,
          requests: [],
          city: '',
          address: 'Нет данных',
          isGeoEnable: isGeolocationEnable,
        ),
      );
    }
  }

  Future<void> fetchData() async {
    //  response = await RequestsRespository.getContactRequests();

    try {
      await dangerIconsCtrl.fetchData(
        lat: lat,
        lon: lon,
        city: city,
      );

      // requests.clear();

      // List response = [];
      // List response112 = [];

      bool notifMe = await PrefService.isNotifMe();

      // if (notifMe) {
      //   response = await RequestsRespository.getContactRequests();
      //   response112 = await RequestsRespository.getContactRequests112();
      // }

      // for (var r in response) {
      //   await RequestsRespository.seenContactRequests(
      //       {"contact_request_id": r.id});
      // }

      // for (var r in response112) {
      //   await RequestsRespository.seenContactRequests112(
      //       {"contact_request_id": r.id});
      // }

      if (notifMe) {
        contactsUnverified = await ContactsRepository.loadContactsUnverified();
      }

      // for (var r in response) {
      //   if (r.seen == false) {
      //     // if (latestRequestIds.contains(r.id)) {
      //     requests.add(r);
      //   }
      // }
      // for (var r in response112) {
      //   if (r.seen == false) {
      //     // if (latestRequestIds.contains(r.id)) {
      //     requests.add(r);
      //   }
      // }

      emit(
        DangerousLoaded(
          myMedCard: myCard,
          showcontactNotif: contactsUnverified.isNotEmpty,
          requests: requests,
          address: addres,
          city: city,
          isGeoEnable: true,
        ),
      );
    } catch (e) {
      log(e.toString());

      // Обработчик ошибок
      emit(
        DangerousLoaded(
          myMedCard: MedcardModel(
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
              cerificates: [],
              status: '',
              detail: '',
              haveCard: false,
              cardType: '',
              animalMedCard: null),
          showcontactNotif: false,
          requests: [],
          city: '',
          address: 'Нет данных',
          isGeoEnable: isGeolocationEnable,
        ),
      );
    }
  }

  // fetchRequests(List<String> reqIds) async {
  //   try {
  //     latestRequestIds = reqIds;

  //     List<RequestModel> response =
  //         await RequestsRespository.getContactRequests();
  //     List<RequestModel> response112 =
  //         await RequestsRespository.getContactRequests112();

  //     requests.clear();

  //     for (var req in response) {
  //       if (latestRequestIds.contains(req.id)) {
  //         requests.add(req);
  //       }
  //     }
  //     for (var req in response112) {
  //       if (latestRequestIds.contains(req.id)) {
  //         requests.add(req);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   } finally {
  //     // print(requests);
  //     notifyListeners();
  //   }
  // }

  removeRequest(String id) {
    latestRequestIds.removeWhere((element) => element == id);
    requests.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  addRequest(Map<String, dynamic> data, String msg) {
    requests.add(RequestModel(
      id: data['request_id'],
      phone: int.tryParse(data['phone']) ?? 0,
      fullName: data['name'],
      lat: lat,
      lon: lon,
      detail: msg,
      type: data['type'],
      seen: false,
    ));
    notifyListeners();
  }
}
