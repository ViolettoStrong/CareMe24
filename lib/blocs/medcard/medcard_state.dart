import 'package:careme24/models/medcard/medcard_model.dart';

abstract class MedCardState {}

class MedCardLoading extends MedCardState {}

class MedCardLoaded extends MedCardState {
  final MedcardModel myCard;
  final List<MedcardModel> otherCards;
  final List<MedcardModel> unverifiedCards;
  final List<MedcardModel> toMeRequests;
  final List<MedcardModel> animalCards;

  MedCardLoaded(
      {required this.myCard,
      required this.otherCards,
      required this.unverifiedCards,
      required this.toMeRequests,
      required this.animalCards});
}
