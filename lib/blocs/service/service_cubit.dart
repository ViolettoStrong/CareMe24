import 'dart:developer';

import 'package:careme24/blocs/service/model_chat.dart';
import 'package:careme24/blocs/service/service_state.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/models/service_model.dart';
import 'package:careme24/repositories/favorites_response.dart';
import 'package:careme24/repositories/requests_respository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/medcard_repository.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceLoading());

  ServiceLoaded? loadedState;

  Future<void> fetchData(String type) async {
    emit(ServiceLoading());
    Map<String, dynamic> params = {"institution_type": type};

    final response = await RequestsRespository.getServices(params);
    final myCard = await MedcardRepository.fetchMyCard();

    List<ServiceModel> filteredList = List.from(response);

    if (VersionConstant.free == false) {
      // Սկզբում անվճարները (price == 0)
      filteredList.sort((a, b) {
        if (a.price == 0 && b.price != 0) return -1;
        if (a.price != 0 && b.price == 0) return 1;
        return 0;
      });
    } else {
      filteredList.sort((a, b) {
        if (a.price > 0 && b.price == 0) return -1;
        if (a.price == 0 && b.price > 0) return 1;
        return 0;
      });
    }

    log('Total services: ${response.length}, Filtered: ${filteredList.length}');

    loadedState = ServiceLoaded(
      serviceList: filteredList,
      medCardId: myCard.id,
    );

    emit(loadedState!);
  }

  Future<void> fetchServiceChatRooms() async {
    final List<ChatRoom> chatRooms =
        await RequestsRespository.getServicesChatRooms();
    emit(ServiceChatGet(chatRooms));
  }

  Future<void> fetchDataUserChat(String id) async {
    final response = await RequestsRespository.getServicesChatUsers(id);
    emit(ServiceUsersGet(response));
  }

  Future<void> sendMessage(
    String chatId,
    String message,
    String? filePath,
  ) async {
    if (message.isEmpty && filePath == null) return;

    print('sending message :$message');

    FormData formData = FormData.fromMap({
      'chat_id': chatId,
      'message': message,
      'message_type': filePath != null ? 'file' : 'text',
      if (filePath != null) 'file': await MultipartFile.fromFile(filePath),
    });

    try {
      final response = await RequestsRespository.postChatMessage(formData);

      if (response['status'] == 'success') {
        fetchServiceChatRooms(); // Refetch messages
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> postFavorites(String id) async {
    // emit(FavoriteLoading());

    final currentState = state;

    if (currentState is ServiceLoaded) {
      try {
        Map<String, dynamic> response =
            await FavoritesResponse.postFavoritesRepository(id);

        if (response["status"] == 'success') {
          List<ServiceModel> updatedList =
              currentState.serviceList.map((service) {
            if (service.id == id) {
              return service.copyWith(isFavourite: !service.isFavourite);
            }
            return service;
          }).toList();

          emit(ServiceLoaded(
            serviceList: updatedList,
            medCardId: currentState.medCardId,
          ));

          emit(ServiceLoaded(
            serviceList: updatedList,
            medCardId: currentState.medCardId,
          ));
        } else {}
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> deletFavorites(String id) async {
    final currentState = state;

    if (currentState is ServiceLoaded) {
      try {
        Map<String, dynamic> response =
            await FavoritesResponse.deleteFavoriteRepository(id);

        if (response["status"] == 'success') {
          List<ServiceModel> updatedList =
              currentState.serviceList.map((service) {
            if (service.id == id) {
              return service.copyWith(isFavourite: !service.isFavourite);
            }
            return service;
          }).toList();

          emit(ServiceLoaded(
            serviceList: updatedList,
            medCardId: currentState.medCardId,
          ));
        } else {
          // emit(FavoriteError("Failed to delete favorite"));
        }
      } catch (e) {
        // emit(FavoriteError(e.toString()));
      }
    }
  }
}
