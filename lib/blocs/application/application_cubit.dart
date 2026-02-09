// import 'dart:developer';
// import 'package:careme24/api/api.dart';
// import 'package:careme24/api/http_manager.dart';
// import 'package:careme24/blocs/application/application_state.dart';
// import 'package:careme24/models/medcard/medcard_model.dart';
// import 'package:careme24/models/user_model.dart';
// import 'package:careme24/service/token_storage.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ApplicationCubit extends Cubit<ApplicationState> {
//   ApplicationCubit() : super(ApplicationLoading());
//   bool isAuthorized = false;
//   UserModel userInfo = UserModel(
//     id: '',
//     medCardID: '',
//     phone: 0,
//     personalInfo: PersonalInfo(
//       avatar: '',
//       full_name: '',
//       phone: 0,
//       dob: '',
//       address: '',
//       temporaryAddress: '',
//       passport: Passport(
//         serial: 0,
//         number: 0,
//         place: '',
//         date: '',
//         photos: [],
//       ),
//     ),
//     balance: 0,
//   );

//   final LocalAuthentication _localAuth = LocalAuthentication();

//   Future<bool> _authenticate() async {
//     bool isAuthenticated = false;

//     try {
//       bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
//       if (canCheckBiometrics) {
//         isAuthenticated = await _localAuth.authenticate(
//           localizedReason: 'Пожалуйста, авторизуйтесь',
//           options: AuthenticationOptions(
//             stickyAuth: true,
//             biometricOnly: false,
//           ),
//         );
//       }
//     } catch (e) {
//       log('Ошибка при аутентификации: $e');
//     }

//     return isAuthenticated;
//   }

//   Future<void> onSetup() async {
//     emit(ApplicationLoading());

//     final result = await [
//       Permission.location,
//       Permission.contacts,
//     ].request();

//     isAuthorized = await TokenManager.hasToken();

//     if (isAuthorized) {
//       bool isAuthenticated = await _authenticate();

//       if (isAuthenticated) {
//         String? token = await TokenManager.getRToken();
//         HttpManager.instance.setToken(token.toString());
//         final newToken = await Api.refresh();
//         if (newToken == null) {
//           TokenManager.deleteToken();
//           emit(ApplicationCompleted(
//             isAuthorized: false,
//             error: false,
//           ));
//         } else {
//           TokenManager.saveToken(newToken);
//           HttpManager.instance.setToken(newToken.toString());
//           emit(ApplicationCompleted(
//             isAuthorized: true,
//             error: false,
//           ));
//         }

//       } else {
//         emit(ApplicationCompleted(
//           isAuthorized: true,
//           error: true,
//         ));
//       }
//     } else {
//       emit(ApplicationCompleted(
//         isAuthorized: false,
//         error: false,
//       ));
//     }
//   }

//   Future<void> login()async{
//     emit(ApplicationCompleted(
//         isAuthorized: true,
//         error: false,
//       ));
//   }
// }

import 'package:careme24/api/api.dart';
import 'package:careme24/api/http_manager.dart';
import 'package:careme24/blocs/application/application_state.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/user_model.dart';
import 'package:careme24/service/token_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationLoading());
  bool isAuthorized = false;
  UserModel userInfo = UserModel(
    id: '',
    medCardID: '',
    phone: 0,
    personalInfo: PersonalInfo(
      avatar: '',
      full_name: '',
      phone: 0,
      dob: '',
      address: '',
      temporaryAddress: '',
      passport: Passport(
        serial: 0,
        number: 0,
        place: '',
        date: '',
        photos: [],
      ),
    ),
    balance: 0,
  );

  Future<void> onSetup() async {
    emit(ApplicationLoading());

    isAuthorized = await TokenManager.hasToken();

    if (isAuthorized) {
      String? token = await TokenManager.getRToken();
      HttpManager.instance.setToken(token.toString());
      final newToken = await Api.refresh();
      if (newToken == null) {
        TokenManager.deleteToken();
        emit(ApplicationCompleted(
          isAuthorized: false,
          error: false,
        ));
      } else {
        TokenManager.saveToken(newToken);
        HttpManager.instance.setToken(newToken.toString());
        emit(ApplicationCompleted(
          isAuthorized: true,
          error: false,
        ));
      }
    } else {
      emit(ApplicationCompleted(
        isAuthorized: false,
        error: false,
      ));
    }
  }

  Future<void> login() async {
    emit(ApplicationCompleted(
      isAuthorized: true,
      error: false,
    ));
  }
}
