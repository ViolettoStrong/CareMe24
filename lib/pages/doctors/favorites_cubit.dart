import 'dart:developer';

import 'package:careme24/models/favorite_model.dart';
import 'package:careme24/pages/doctors/favorites_state.dart';
import 'package:careme24/repositories/favorites_response.dart';
import 'package:careme24/repositories/medcard_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteLoading());

  /// Fetch all favorite items
  Future<void> fetchFavorites() async {
    emit(FavoriteLoading());
    try {
      final List<ServiceModel2> response =
          await FavoritesResponse.getFavoritesRepository();

      if (response != null) {
        // final favoriteIds = Set<String>.from(response.to);
        final myCard = await MedcardRepository.fetchMyCard();
        log('${response.length}');

        emit(FavoriteLoadedGet(serviceList: response, medCardId: myCard.id));
      } else {
        emit(const FavoriteError("Failed to load favorites"));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> postFavorites(String id) async {
    emit(FavoriteLoading());
    try {
      Map<String, dynamic> response =
          await FavoritesResponse.postFavoritesRepository(id);

      if (response["status"] == 'success') {
        // final favoriteIds = Set<String>.from(response.to);

        emit(FavoriteLoadedPost(response as Set<String>));
      } else {
        emit(const FavoriteError("Failed to load favorites"));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> deletFavorites(String id) async {
    final currentState = state;

    if (currentState is FavoriteLoadedGet) {
      try {
        Map<String, dynamic> response =
            await FavoritesResponse.deleteFavoriteRepository(id);

        if (response["status"] == 'success') {
          // Remove the deleted item from the list
          final updatedList = currentState.serviceList
              .where((item) => item.serviceId != id)
              .toList();

          // Emit new state with updated list
          emit(FavoriteLoadedGet(
              serviceList: updatedList, medCardId: currentState.medCardId));
        } else {
          emit(const FavoriteError("Failed to delete favorite"));
        }
      } catch (e) {
        emit(FavoriteError(e.toString()));
      }
    }
  }
}
