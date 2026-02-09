import 'package:careme24/pages/medicines/cubit/in_take_state.dart';
import 'package:careme24/pages/medicines/cubit/intake_repository.dart';
import 'package:careme24/pages/medicines/cubit/medicines_repository.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InTakeTimeCubit extends Cubit<InTakeMedicinesState> {
  InTakeTimeCubit() : super(InTakeMedicinesInitial());

  Future<void> getInTakeTimeMed(String day) async {
    emit(InTakeMedicinesLoading());
    try {
      final response = await IntakeTimeRepository.getInTakeRepository(day);
      emit(InTakeMedicinesInitial());
      if (response.isNotEmpty) {
        emit(InTakeMedicinesLoaded(response));
      }
    } catch (e) {
      emit(InTakeMedicinesError(e.toString()));
    }
  }

  Future<void> updateMedicines(
      String id, String day, String time, String aidKitId) async {
    emit(InTakeMedicinesUpdating());
    try {
      FormData formData = FormData.fromMap({
        'id': id,
        'day': day,
        'time': time,
        'medicine_id': aidKitId,
      });
      final response =
          await IntakeTimeRepository.updateInTakeRepository(formData);

      if (response['status'] == 'success') {
        getInTakeTimeMed(day);
        // getMedicinesById(aidKitId);
        // getMedicines();
        emit(InTakeMedicinesUpdated(response['status'], response['detail']));
      } else {
        emit(InTakeMedicinesError("Ошибка при обновлении аптечки"));
      }
    } catch (e) {
      emit(InTakeMedicinesError(e.toString()));
    }
  }

  Future<void> createMedicines(String day, String time, String aidKitId) async {
    emit(InTakeMedicinesCreating());
    try {
      // final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.parse(expirationDate));

      final formData = FormData.fromMap({
        'day': day,
        'time': time,
        'medicine_id': aidKitId,
      });

      final response =
          await IntakeTimeRepository.createInTakeRepository(formData);
      if (response['status'] == 'success') {
        getInTakeTimeMed(day);

        emit(InTakeMedicinesCreated(response['status'], response['detail']));
      }
      emit(InTakeMedicinesCreated(response['status'], response['detail']));
    } catch (e) {
      emit(InTakeMedicinesError(e.toString()));
    }
  }

  Future<void> deletMedicines(String id, String day) async {
    final currentState = state;

    if (currentState is InTakeMedicinesLoaded) {
      try {
        Map<String, dynamic> response =
            await IntakeTimeRepository.deleteInTakeRepository(id);

        if (response["status"] == 'success') {
          // final updatedList =
          //     currentState.aidKits.where((item) => item.id != id).toList();

          // // Emit new state with updated list
          // emit(InTakeMedicinesLoaded(
          //   updatedList,
          // ));
          getInTakeTimeMed(day);
        } else {
          emit(InTakeMedicinesError("Failed to delete favorite"));
        }
      } catch (e) {
        emit(InTakeMedicinesError(e.toString()));
      }
    }
  }

  Future<void> deletMedicinesGet(String id) async {
    final currentState = state;

    if (currentState is InTakeMedicinesGetLoaded) {
      try {
        Map<String, dynamic> response =
            await MedicinesRepository.deleteMedicinesRepository(id);

        if (response["status"] == 'success') {
          final updatedList =
              currentState.aidKits.where((item) => item.id != id).toList();

          // Emit new state with updated list

          emit(InTakeMedicinesGetLoaded(
            updatedList,
          ));
        } else {
          emit(InTakeMedicinesError("Failed to delete favorite"));
        }
      } catch (e) {
        emit(InTakeMedicinesError(e.toString()));
      }
    }
  }
}
