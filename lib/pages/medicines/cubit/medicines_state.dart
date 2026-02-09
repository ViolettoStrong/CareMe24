// AidKit State
import 'package:careme24/pages/medicines/model/aid_kit_item_mode.dart';
import 'package:careme24/pages/medicines/model/owner_id_model.dart';

abstract class MedicinesState {
  List<Object?> get props => [];
}

class MedicinesInitial extends MedicinesState {}

class MedicinesLoading extends MedicinesState {}

class MedicinesLoaded extends MedicinesState {
  final List<AidKitItem> aidKits;

  MedicinesLoaded(this.aidKits);

  @override
  List<Object?> get props => [aidKits];
}

class MedicinesGetLoaded extends MedicinesState {
  final List<MedicineItem> aidKits;

  MedicinesGetLoaded(this.aidKits);

  @override
  List<Object?> get props => [aidKits];
}

class MedicinesUpdating extends MedicinesState {}

class MedicinesUpdated extends MedicinesState {
  final String status;
  final String detail;

  MedicinesUpdated(this.status, this.detail);

  @override
  List<Object?> get props => [status, detail];
}

class MedicinesDeleted extends MedicinesState {
  final String status;
  final String detail;

  MedicinesDeleted(this.status, this.detail);

  @override
  List<Object?> get props => [status, detail];
}

class MedicinesCreating extends MedicinesState {}

class MedicinesCreated extends MedicinesState {
  final String status;
  final String detail;

  MedicinesCreated(this.status, this.detail);

  @override
  List<Object?> get props => [status, detail];
}

class MedicinesError extends MedicinesState {
  final String message;

  MedicinesError(this.message);

  @override
  List<Object?> get props => [message];
}
