import 'dart:async';
import 'package:careme24/api/api.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/pages/calls/dialog_select_contact_med.dart';
import 'package:careme24/pages/calls/main_call_page.dart';
import 'package:careme24/pages/calls/medical_call_button.dart';
import 'package:careme24/reason_ambulance.dart';
import 'package:careme24/repositories/medcard_repository.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/for_whom.dart';
import 'package:careme24/widgets/paid_service_swither.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicCallPage extends StatefulWidget {
  const MedicCallPage({super.key});

  @override
  State<MedicCallPage> createState() => _MedicCallPageState();
}

MedcardModel? _selectedContact;
bool isCalling = false;
dynamic res;

final List<String> reasonText = <String>[
  'M1.8B11 Нарушение речи, слабость в конечеостях',
  "M1.BA41 Сильная боль в груди",
  "M1.NE81 Опасная травма, ранение, ДТП",
  "3.29. Цунами",
  "M1.MD11 Асфиксия всех видов, острое нарушение дыхания",
  "M1.5. Кровотечение сильное или внутреннее",
  "M1.6. Схватки, роды (скрыто,  добавить)",
  "C5",
  "C6",
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

class _MedicCallPageState extends State<MedicCallPage> {
  bool isNotifContact = false;
  @override
  void initState() {
    super.initState();
    getMyCalls();
    setValue();
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
      dynamic response = await Api.fetchCallsData('med', cardId.id);
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
            title: AppbarTitle(text: "Вызов скорой"),
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
                                  'med', selectedContact.id);
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
                                    await Api.fetchCallsData('med', cardId.id);
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
                          },
                          child: Stack(
                            children: [
                              ForWhom(
                                name:
                                    _selectedContact?.personalInfo.full_name ??
                                        'Мне',
                              ),
                              if (isCalling)
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomLeft: Radius.circular(8),
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
                                                    text: 'Вызов скорой',
                                                    requestId:
                                                        res.values.first['id'],
                                                    show: isNotifContact,
                                                    type: 'med',
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
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))),
                            ],
                          ),
                        )),
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
                  ],
                ),
              ),
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
                                Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ListReasonSettingPage()));
                                      },
                                      child: CustomImageView(
                                        svgPath: ImageConstant
                                            .imgSettingsLightBlue900,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.separated(
                          itemCount: reasonText.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Reason(
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
                                                MedicalCallButton(
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
