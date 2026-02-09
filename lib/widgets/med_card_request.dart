import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:flutter/material.dart';

class MedCardRequest extends StatelessWidget {
  const MedCardRequest(
      {super.key, required this.medcard, this.shareMode = true});

  final MedcardModel medcard;
  final bool shareMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(120, 120, 120, 0.24),
              offset: Offset(0, 0),
              blurRadius: 13,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  shareMode
                      ? 'Оповещение о передаче профиля'
                      : "Оповещение о запросе профиля на управление",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(231, 40, 86, 1))),
              Text(
                  medcard.personalInfo.full_name == ''
                      ? 'ФИО не указано'
                      : medcard.personalInfo.full_name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              Text(
                  medcard.personalInfo.phone == 0
                      ? 'Номер не указен'
                      : '${medcard.personalInfo.phone}',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(44, 62, 79, 1))),
              const SizedBox(height: 6),
              if (shareMode)
                Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        final response = await AppBloc.medCardCubit
                            .cardVerifyRequest(medcard.id, 'set-main');
                        if (response.isSuccess) {
                          AppBloc.medCardCubit.fetchData();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(65, 73, 255, 1),
                              Color.fromRGBO(41, 142, 235, 1),
                            ])),
                        child: Center(
                          child: Text(
                            'Загрузить основной профиль',
                            style: AppStyle.txtMontserratf12w600,
                          ),
                        ),
                      ),
                    )),
              Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      if (shareMode) {
                        final response = await AppBloc.medCardCubit
                            .cardVerifyRequest(medcard.id, 'set-verified');
                        if (response.isSuccess) {
                          AppBloc.medCardCubit.fetchData();
                        }
                      } else {
                        final response = await AppBloc.medCardCubit
                            .acceptCardRequest(medcard.id);
                        if (response.isSuccess) {
                          AppBloc.medCardCubit.fetchData();
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(65, 73, 255, 1),
                            Color.fromRGBO(41, 142, 235, 1),
                          ])),
                      child: Center(
                        child: Text(
                          shareMode ? 'Загрузить профиль' : 'Принять запрос',
                          style: AppStyle.txtMontserratf12w600,
                        ),
                      ),
                    ),
                  )),
              Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      final response = await AppBloc.medCardCubit
                          .cardVerifyRequest(medcard.id, 'cancel');
                      if (response.isSuccess) {
                        AppBloc.medCardCubit.fetchData();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(255, 89, 99, 1),
                            Color.fromRGBO(224, 14, 102, 1)
                          ])),
                      child: Center(
                        child: Text(
                          'Отменить',
                          style: AppStyle.txtMontserratf12w600,
                        ),
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
