// AidKit State
import 'package:careme24/pages/medical_bag/models/aid_kit_model.dart';

abstract class AidKitState {
  List<Object?> get props => [];
}

class AidKitInitial extends AidKitState {}

class AidKitLoading extends AidKitState {}

class AidKitLoaded extends AidKitState {
  final List<AidKitModel> aidKits;

  AidKitLoaded(this.aidKits);

  @override
  List<Object?> get props => [aidKits];
}

class AidKitRequestLoaded extends AidKitState {
  final List<AidKitModel> aidKits;

  AidKitRequestLoaded(this.aidKits);

  @override
  List<Object?> get props => [aidKits];
}

class AidKitUpdating extends AidKitState {}

class AidKitUpdated extends AidKitState {
  final String status;
  final String detail;

  AidKitUpdated(this.status, this.detail);

  @override
  List<Object?> get props => [status, detail];
}

class AidKitCreating extends AidKitState {}

class AidKitCreated extends AidKitState {
  final String status;
  final String detail;

  AidKitCreated(this.status, this.detail);

  @override
  List<Object?> get props => [status, detail];
}

class AidKitError extends AidKitState {
  final String message;

  AidKitError(this.message);

  @override
  List<Object?> get props => [message];
}
