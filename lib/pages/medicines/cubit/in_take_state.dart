// AidKit State

import 'package:careme24/pages/medicines/model/intake_model.dart';
import 'package:careme24/pages/medicines/model/owner_id_model.dart';

abstract class InTakeMedicinesState {
  List<Object?> get props => [];
}

class InTakeMedicinesInitial extends InTakeMedicinesState {}

class InTakeMedicinesLoading extends InTakeMedicinesState {}

class InTakeMedicinesLoaded extends InTakeMedicinesState {
  final List<MedicineIntakeTime> aidKits;

  InTakeMedicinesLoaded(this.aidKits);

  @override
  List<Object?> get props => [aidKits];
}

class InTakeMedicinesGetLoaded extends InTakeMedicinesState {
  final List<MedicineItem> aidKits;

  InTakeMedicinesGetLoaded(this.aidKits);

  @override
  List<Object?> get props => [aidKits];
}

class InTakeMedicinesUpdating extends InTakeMedicinesState {}

class InTakeMedicinesUpdated extends InTakeMedicinesState {
  final String status;
  final String detail;

  InTakeMedicinesUpdated(this.status, this.detail);

  @override
  List<Object?> get props => [status, detail];
}

class InTakeMedicinesDeleted extends InTakeMedicinesState {
  final String status;
  final String detail;

  InTakeMedicinesDeleted(this.status, this.detail);

  @override
  List<Object?> get props => [status, detail];
}

class InTakeMedicinesCreating extends InTakeMedicinesState {}

class InTakeMedicinesCreated extends InTakeMedicinesState {
  final String status;
  final String detail;

  InTakeMedicinesCreated(this.status, this.detail);

  @override
  List<Object?> get props => [status, detail];
}

class InTakeMedicinesError extends InTakeMedicinesState {
  final String message;

  InTakeMedicinesError(this.message);

  @override
  List<Object?> get props => [message];
}
