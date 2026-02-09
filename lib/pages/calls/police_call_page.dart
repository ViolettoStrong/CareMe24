import 'dart:async';

import 'package:careme24/api/api.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/pages/calls/dialog_select_contact_med.dart';
import 'package:careme24/pages/calls/main_call_page.dart';
import 'package:careme24/pages/calls/police_call_button.dart';
import 'package:careme24/repositories/medcard_repository.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/widgets/for_whom.dart';
import 'package:careme24/widgets/paid_service_swither.dart';
import 'package:careme24/widgets/reason_police.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoliceCallPage extends StatefulWidget {
  const PoliceCallPage({super.key});

  @override
  State<PoliceCallPage> createState() => _PoliceCallPageState();
}

class _PoliceCallPageState extends State<PoliceCallPage> {
  bool isSelectedSwitch = false;
  MedcardModel? _selectedContact;
  bool isCalling = false;
  dynamic res;

  final List<String> reasonText = <String>[
    "3.13. Мелкое хулиганство",
    "3.11. Проведения демонстрации, митинга,пикетирования, шествия или собрания",
    "3.11. Пропаганда либо публич. демонстрирование нацистской атрибутики",
    "3.29. Возбуждение ненависти либо вражды",
    "3.11. Кража",
    "M1.5. Мешают спать по ночам или вызывают беспорядки в общественном месте",
    "3.12. Повреждения имущества",
    "3.28. Тепловой удар",
    "3.12. Приступ астмы, проблемы с дыханием",
    "C7",
    "C8"
  ];

  final List<bool> reasonDisable = <bool>[
    false,
    false,
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  bool isNotifContact = false;
  @override
  void initState() {
    super.initState();
    getMyCalls();
  }

  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotifContact = prefs.getBool('pay_switch_value_notif_tome') ?? false;
    });
  }

  Future<void> getMyCalls() async {
    dynamic cardId = await MedcardRepository.fetchMyCard();
    if (cardId != null) {
      dynamic response = await Api.fetchCallsData('pol', cardId.id);
      if (response == null || response.isEmpty) {
        setState(() {
          isCalling = false;
        });
      } else {
        setState(() {
          isCalling = true;
          res = response;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.gray100,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            height: getVerticalSize(48),
            leadingWidth: 43,
            leading: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
              child: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => {
                        Navigator.pop(context),
                        Navigator.pop(context),
                      }),
            ),
            centerTitle: true,
            title: AppbarTitle(text: "Вызов полиции"),
            styleType: Style.bgFillBlue60001),
        body: Container(
            width: double.maxFinite,
            padding: getPadding(left: 20, right: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                  padding: getPadding(left: 1, top: 17),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () async {
                                  final selectedContact =
                                      await showDialog<MedcardModel>(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ContactSelectDialogMed();
                                    },
                                  );

                                  setState(() {
                                    _selectedContact = selectedContact;
                                  });
                                  if (selectedContact != null) {
                                    setState(() {
                                      isCalling = false;
                                    });
                                    dynamic response = await Api.fetchCallsData(
                                        'pol', selectedContact.id);
                                    if (response == null || response.isEmpty) {
                                      setState(() {
                                        isCalling = false;
                                      });
                                    } else {
                                      setState(() {
                                        res = response;
                                        isCalling = true;
                                      });
                                    }
                                  } else {
                                    dynamic cardId =
                                        await MedcardRepository.fetchMyCard();
                                    if (cardId != null) {
                                      dynamic response =
                                          await Api.fetchCallsData(
                                              'pol', cardId.id);
                                      if (response == null ||
                                          response.isEmpty) {
                                        setState(() {
                                          isCalling = false;
                                        });
                                      } else {
                                        setState(() {
                                          isCalling = true;
                                          res = response;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: Stack(
                                  children: [
                                    ForWhom(
                                      name: _selectedContact
                                              ?.personalInfo.full_name ??
                                          'Мне',
                                    ),
                                    if (isCalling)
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(8),
                                                  bottomLeft:
                                                      Radius.circular(8),
                                                ),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainCallPage(
                                                          text: 'Вызов полиции',
                                                          requestId: res.values
                                                              .first['id'],
                                                          show: isNotifContact,
                                                          type: 'pol',
                                                          latestCalls: res,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.phone_in_talk,
                                                          size: 14,
                                                          color: Colors.white),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Вызов активен',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))),
                                  ],
                                ))),
                        Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Center(
                                  child: Text(
                                    'Платная услуга',
                                    style: TextStyle(
                                        color: VersionConstant.free
                                            ? const Color(0xFF9E9E9E)
                                            : Colors.green),
                                  ),
                                )),
                            Column(
                              children: [
                                PaySwitcher(
                                  on: VersionConstant.free,
                                  onChanged: (value) {
                                    setState(() {
                                      VersionConstant.free = value;
                                    });
                                  },
                                ),
                                Text(''),
                              ],
                            )
                          ],
                        ),
                      ])),
              Expanded(
                child: Container(
                  padding: getPadding(top: 14),
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 180,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            color: Color.fromRGBO(178, 218, 255, 100),
                          ),
                          width: MediaQuery.of(context).size.width - 40,
                          height: 80,
                          child: Padding(
                            padding: getPadding(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Причина вызова",
                                  style: AppStyle.txtMontserratSemiBold19,
                                ),
                                CustomImageView(
                                  svgPath:
                                      ImageConstant.imgSettingsLightBlue900,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.separated(
                          itemCount: reasonText.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ReasonPolice(
                              onTap: () {
                                isCalling
                                    ? ElegantNotification.error(
                                        description:
                                            const Text('Заявка уже отправлена'),
                                      ).show(context)
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PoliceCallButton(
                                                  text: reasonText[index],
                                                  selectedContact:
                                                      _selectedContact,
                                                )));
                              },
                              text: reasonText[index],
                              disable: reasonDisable[index],
                              backgroundColor: Colors.white,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(indent: 0, height: 1),
                        ))
                      ]),
                ),
              )
            ])));
  }
}
