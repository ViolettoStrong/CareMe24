import 'dart:developer';
import 'dart:io';

import 'package:careme24/pages/medical_bag/cubit/aid_kit_repository.dart';
import 'package:careme24/pages/medical_bag/cubit/aid_kit_state.dart';
import 'package:dio/dio.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AidKitCubit extends Cubit<AidKitState> {
  AidKitCubit() : super(AidKitInitial());

  Future<void> getAidKit() async {
    emit(AidKitLoading());
    try {
      final response = await AidKitRepository.getAidKitRepository();

      if (response.isNotEmpty) {
        emit(AidKitLoaded(response));
      }
    } catch (e) {
      emit(AidKitError(e.toString()));
    }
  }

  Future<void> getAidKitRequests() async {
    emit(AidKitLoading());
    try {
      final response = await AidKitRepository.getAidKitRequestRepository();

      if (response.isNotEmpty) {
        emit(AidKitRequestLoaded(response));
      }
    } catch (e) {
      emit(AidKitError(e.toString()));
    }
  }

  Future<void> getAidKitUser(String user_id) async {
    emit(AidKitLoading());
    try {
      final response =
          await AidKitRepository.getAidKitUserIdRepository(user_id);

      if (response.isNotEmpty) {
        response.forEach((element) {
          postRequestAidKit(element.id);
          log(element.id);
        });

        emit(AidKitLoaded(response));
      }
    } catch (e) {
      emit(AidKitError(e.toString()));
    }
  }

  Future<void> postRequestAidKit(String aid_kit_id) async {
    emit(AidKitCreating());
    try {
      final response =
          await AidKitRepository.postRequestAidKitRepository(aid_kit_id);
      if (response['status'] == 'success') {
        getAidKit();
        emit(AidKitCreated(response['status'], response['detail']));
      }
      emit(AidKitCreated(response['status'], response['detail']));
    } catch (e) {
      emit(AidKitError(e.toString()));
    }
  }

  Future<void> updateAidKit(
    String id,
    String title,
    File? photo,
  ) async {
    emit(AidKitUpdating());
    try {
      FormData formData = FormData.fromMap({
        'id': id,
        'title': title,
      });

      if (photo != null) {
        formData.files.add(MapEntry(
          'photo',
          await MultipartFile.fromFile(photo.path, filename: 'photo.png'),
        ));
      }

      final response = await AidKitRepository.updateAidKitRepository(formData);

      if (response['status'] == 'success') {
        getAidKit();
        emit(AidKitUpdated(response['status'], response['detail']));
      } else {
        emit(AidKitError("Ошибка при обновлении аптечки"));
      }
    } catch (e) {
      emit(AidKitError(e.toString()));
    }
  }

  Future<void> createAidKit(String title, File photo, String user_id) async {
    emit(AidKitCreating());
    try {
      final formData = FormData.fromMap({
        'title': title,
        'photo':
            await MultipartFile.fromFile(photo.path, filename: 'photo.png'),
        'user_id': user_id
      });

      final response = await AidKitRepository.createAidKitRepository(formData);
      if (response['status'] == 'success') {
        getAidKit();
        emit(AidKitCreated(response['status'], response['detail']));
      }
      emit(AidKitCreated(response['status'], response['detail']));
    } catch (e) {
      emit(AidKitError(e.toString()));
    }
  }

  Future<void> deletAidKit(String id) async {
    final currentState = state;

    if (currentState is AidKitLoaded) {
      try {
        Map<String, dynamic> response =
            await AidKitRepository.deleteAidKitRepository(id);

        if (response["status"] == 'success') {
          // Remove the deleted item from the list
          final updatedList =
              currentState.aidKits.where((item) => item.id != id).toList();

          // Emit new state with updated list
          emit(AidKitLoaded(
            updatedList,
          ));
        } else {
          emit(AidKitError("Failed to delete favorite"));
        }
      } catch (e) {
        emit(AidKitError(e.toString()));
      }
    }
  }
}
