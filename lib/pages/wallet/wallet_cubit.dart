import 'dart:developer';

import 'package:careme24/pages/wallet/change_balance_state.dart';

import 'package:careme24/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeBalanceCubit extends Cubit<ChangeBalanceState> {
  ChangeBalanceCubit() : super(ChangeBalanceInitial());

  Future<void> changeBalanceWallet(String data) async {
    try {
      emit(ChangeBalanceLoading());

      int value = int.parse(data);
      final requestData = {"balance": value};

      final response =
          await UserRepository.changeBalanceRepository(requestData);

      if (response['status'] == 'success') {
        log('Successful');
        emit(ChangeBalanceSuccess(response['status']));
      } else {
        log('Failed');
        emit(
            ChangeBalanceError(response['message'] ?? "Balance change failed"));
      }
    } catch (e) {
      log('Error: $e');
      emit(ChangeBalanceError("Invalid input or server error"));
    }
  }
}
