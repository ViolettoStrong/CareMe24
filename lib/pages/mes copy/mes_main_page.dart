import 'package:careme24/constants.dart';
import 'package:careme24/pages/mes/what_to_do_mes_card.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/for_whom.dart';
import 'package:careme24/widgets/paid_service_swither.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:flutter/material.dart';

final _controller = ValueNotifier<bool>(VersionConstant.isPaidSubscription);

class MESMainPage extends StatelessWidget {
  const MESMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    WhoCall.changeWho("МЧС ВЫЗВАН");
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: CustomAppBar(
                height: getVerticalSize(48),
                leadingWidth: 49,
                leading: const Icon(Icons.menu),
                centerTitle: true,
                title: AppbarTitle(text: "МЧС"),
                styleType: Style.bgFillBlue60001),
            body: SingleChildScrollView(
              child: Container(
                  width: double.maxFinite,
                  padding: getPadding(left: 20, top: 21, right: 20, bottom: 21),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: getPadding(left: 2, right: 3),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ForWhom(
                                    name: 'Мне',
                                  ),
                                  const PaySwitcher(),
                                ])),
                        Padding(
                          padding: getPadding(top: 14),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(178, 218, 255, 100),
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
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text('Проблема',
                                        style: AppStyle.txtMontserratSemiBold19,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  CustomImageView(
                                    svgPath:
                                        ImageConstant.imgArrowdownLightBlue900,
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  WhatDoMESCard(
                                    color_icon: ColorConstant.pinkIcon,
                                    icon_path: ImageConstant.fireFitherIcon,
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
                                    icon_path:
                                        ImageConstant.starNotificationIcon,
                                    action_text: "Рекомендации",
                                  ),
                                ]))
                      ])),
            )));
  }
}
