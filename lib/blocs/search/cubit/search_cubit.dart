import 'dart:developer';

import 'package:careme24/blocs/search/cubit/search_state.dart';
import 'package:careme24/models/user_model.dart';
import 'package:careme24/repositories/medcard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInit());

  Future<void> fetchUsers(int phoneNumber) async {
    emit(SearchLoading());
    final data = {"phone_part": phoneNumber};

    final List<UserModel> response = await MedcardRepository.searchUser(data);
    log('$response');
    emit(SearchLoaded(users: response));
  }
}
