import 'package:careme24/constants.dart';
import 'package:careme24/pages/med/appointment_page.dart';
import 'package:careme24/pages/mes/what_to_do_mes_card.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/for_whom.dart';
import 'package:careme24/widgets/paid_service_swither.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _controller = ValueNotifier<bool>(VersionConstant.isPaidSubscription);

class MESMainPage extends StatefulWidget {
  const MESMainPage({super.key});
  State<MESMainPage> createState() => _MESMainPage();
}

class _MESMainPage extends State<MESMainPage> {
  late Future<bool> switchValueFuture;

  @override
  void initState() {
    super.initState();
    switchValueFuture = _loadSwitchValue();
  }

  Future<bool> _loadSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('pay_switch_value') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    WhoCall.changeWho("МЧС ВЫЗВАН");
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: AppBar(
              centerTitle: true,
              title: AppbarTitle(text: "МЧС"),
              backgroundColor: const Color.fromRGBO(41, 142, 235, 1),
            ),
            drawer: Drawer(child: DrawerWidget()),
            body: FutureBuilder<bool>(
              future: switchValueFuture,
              builder: (context, snapshot) {
                final switchValue = snapshot.data ?? false;
                return SingleChildScrollView(
                    child: Container(
                        width: double.maxFinite,
                        padding: getPadding(
                            left: 20, top: 21, right: 20, bottom: 21),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: getPadding(left: 2, right: 0, top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ForWhom(name: 'Мне'),
                                    Column(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Center(
                                              child: Text(
                                                'Платная услуга',
                                                style: TextStyle(
                                                    color: VersionConstant.free
                                                        ? const Color(
                                                            0xFF9E9E9E)
                                                        : Colors.green),
                                              ),
                                            )),
                                        Column(
                                          children: [
                                            PaySwitcher(
                                              on: switchValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  switchValueFuture =
                                                      Future.value(value);
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
                              Padding(
                                padding: getPadding(top: 14),
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AppointmentListPage(
                                                  type: 'mch'),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromRGBO(
                                            178, 218, 255, 100),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: 80,
                                      child: Padding(
                                        padding:
                                            getPadding(left: 20, right: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              child: Text(
                                                'История заявок',
                                                style: AppStyle
                                                    .txtMontserratSemiBold19,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: getPadding(top: 14),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromRGBO(
                                        178, 218, 255, 100),
                                  ),
                                  width: MediaQuery.of(context).size.width - 40,
                                  height: 80,
                                  child: Padding(
                                    padding: getPadding(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Text('Проблема',
                                              style: AppStyle
                                                  .txtMontserratSemiBold19,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        CustomImageView(
                                          svgPath: ImageConstant
                                              .imgArrowdownLightBlue900,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: getPadding(
                                      left: 3, top: 30, right: 3, bottom: 5),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        WhatDoMESCard(
                                          color_icon: ColorConstant.pinkIcon,
                                          icon_path:
                                              ImageConstant.fireFitherIcon,
                                          action_text: "Сообщить",
                                        ),
                                        WhatDoMESCard(
                                          color_icon: ColorConstant.violIcon,
                                          icon_path: ImageConstant.screenIcon,
                                          action_text: "Помощь онлайн",
                                        ),
                                        WhatDoMESCard(
                                          color_icon: ColorConstant.pinkA200,
                                          icon_path: ImageConstant.noteIcon,
                                          action_text: "Заявление",
                                        ),
                                        WhatDoMESCard(
                                          color_icon: ColorConstant.greenA70002,
                                          icon_path: ImageConstant
                                              .starNotificationIcon,
                                          action_text: "Рекомендации",
                                        ),
                                      ]))
                            ])));
              },
            )));
  }
}
