import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/models/service_model.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorCallScreen extends StatelessWidget {
  const DoctorCallScreen(
      {super.key,
      required this.reason,
      required this.serviceModel,
      required this.cardId});

  final String reason;
  final ServiceModel serviceModel;
  final String cardId;

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          height: getVerticalSize(48),
          leadingWidth: 43,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: AppbarTitle(text: 'Вызов'),
          styleType: Style.bgFillBlue60001),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 32, left: 23, right: 23),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(blurRadius: 5, color: Color.fromRGBO(0, 0, 0, 0.24))
                ]),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 67,
                      height: 80,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(30)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomImageView(
                              url: serviceModel.photo,
                              height: 80,
                              width: 67,
                              radius: const BorderRadius.only(
                                  bottomRight: Radius.circular(30)),
                              fit: BoxFit.cover),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(serviceModel.name,
                            style: const TextStyle(
                                color: Color.fromRGBO(51, 132, 226, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        Text(
                          serviceModel.workPlace,
                          style: const TextStyle(
                              color: Color.fromRGBO(142, 150, 155, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ))
                  ],
                ),
                const Divider(
                  color: Color.fromRGBO(221, 222, 226, 1),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 14, top: 15),
                  child: Row(
                    children: [
                      Text(
                        '',
                        style: TextStyle(
                            color: Color.fromRGBO(44, 62, 79, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                            color: Color.fromRGBO(44, 62, 79, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, bottom: 14, top: 15),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 3),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color.fromRGBO(95, 178, 255, 1))),
                      ),
                      const Text(
                        'Оставить по умолчанию',
                        style: TextStyle(
                            color: Color.fromRGBO(95, 178, 255, 1),
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  _launchURL(serviceModel.license);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 21, right: 25, top: 23),
                  padding: const EdgeInsets.all(17),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(41, 142, 235, 1),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Лицензия',
                            style: TextStyle(
                                color: Color.fromRGBO(41, 142, 235, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        SvgPicture.asset('assets/icons/doc.svg')
                      ]),
                ),
              )),
          Container(
            margin: const EdgeInsets.only(left: 21, right: 25, top: 23),
            padding: const EdgeInsets.all(17),
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(41, 142, 235, 1),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Стаж работ',
                      style: TextStyle(
                          color: Color.fromRGBO(41, 142, 235, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  Text(getYearsWord(serviceModel.experience.toInt()),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ]),
          ),
          Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  _launchURL(serviceModel.diplomas[0]);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 21, right: 25, top: 23),
                  padding: const EdgeInsets.all(17),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(41, 142, 235, 1),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Дипломы/курсы/практики ',
                            style: TextStyle(
                                color: Color.fromRGBO(41, 142, 235, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        SvgPicture.asset('assets/icons/doc.svg')
                      ]),
                ),
              )),
          Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  if (cardId != '') {
                    final response = await AppBloc.requestCubit
                        .createCall(reason, serviceModel.id, cardId);
                    if (response.isSuccess) {
                      ElegantNotification.success(
                              description: const Text('Вызов успешно создан'))
                          .show(context);
                    } else {
                      ElegantNotification.error(
                              description:
                                  const Text('Не удалось сделать вызов'))
                          .show(context);
                    }
                  } else {
                    ElegantNotification.error(
                            description: const Text('У вас нет профиля'))
                        .show(context);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 21, right: 25, top: 95),
                  padding: const EdgeInsets.symmetric(vertical: 19.5),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(41, 142, 235, 1),
                        Color.fromRGBO(65, 73, 255, 1),
                      ])),
                  child: const Center(
                      child: Text('Вызвать',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600))),
                ),
              ))
        ],
      ),
    );
  }
}

String getYearsWord(int years) {
  if (years % 10 == 1 && years % 100 != 11) {
    return '$years год'; // 1 год
  } else if ((years % 10 >= 2 && years % 10 <= 4) &&
      (years % 100 < 10 || years % 100 >= 20)) {
    return '$years года'; // 2-4 года
  } else {
    return '$years лет'; // 5 и более лет
  }
}
