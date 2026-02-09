import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/request_model.dart';

abstract class DangerousState {}

class DangerousInit extends DangerousState {}

class DangerousLoading extends DangerousState {}

class DangerousLoaded extends DangerousState {
  final bool isGeoEnable;

  final String city;
  final List<RequestModel> requests;
  final String address;
  final bool showcontactNotif;
  final MedcardModel myMedCard;

  DangerousLoaded({
    required this.isGeoEnable,
    required this.city,
    required this.requests,
    required this.address,
    required this.showcontactNotif,
    required this.myMedCard,
  });
}
