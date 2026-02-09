import 'package:careme24/models/institution_model.dart';

abstract class InstitutionState {}

class InstitutionLoading extends InstitutionState {}

class InstitutionLoaded extends InstitutionState {
  final List<InstitutionModel> institutionList;

  InstitutionLoaded({required this.institutionList});
}
