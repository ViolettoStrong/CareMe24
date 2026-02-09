// ignore_for_file: non_constant_identifier_names

import 'package:careme24/constants.dart';
import 'package:careme24/models/service_model.dart';
import 'package:careme24/pages/med/reviews_list_screen.dart';
import 'package:careme24/pages/police/appointment_to_police_page.dart';
import 'package:careme24/pages/record_final_screen/record_final_screen.dart';
import 'package:careme24/pages/services_call/create_statement_screen.dart';
import 'package:careme24/pages/services_call/police_call_screen.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import '../theme/app_decoration.dart';
import '../theme/app_style.dart';
import '../widgets/custom_image_view.dart';

class PoliceCard extends StatelessWidget {
  final String id;
  late String doctor_image;
  late String doctor_name;
  late String doctor_qualification;
  late String cost;
  late String meters;
  late String minute;
  late double estimation;
  late String where_call;
  final ServiceModel serviceModel;
  final String reason;
  final bool work;
  final bool statement;
  final String medCardId;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  bool bottomInfo = false;
  bool leftColumnMeters = false;
  bool leftColumnEstimation = false;
  bool freeDates = false;
  bool ququalificationvisible = false;
  final Color backgroundColor;

  PoliceCard({
    super.key,
    required this.doctor_image,
    required this.doctor_name,
    required this.doctor_qualification,
    required this.cost,
    required this.meters,
    required this.minute,
    required this.estimation,
    required this.where_call,
    required this.serviceModel,
    required this.reason,
    this.work = true,
    this.statement = false,
    required this.medCardId,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.id,
    this.backgroundColor = Colors.white,
  });

  void form_card() {
    if (where_call == "Сообщить") {
      AfterPay.changeAfterMinute();
      bottomInfo = true;
    } else if (where_call == "Заявление") {
      TipyHelp.changeHelp(
          "С вами свяжутся по телефону или напишут в сообщениях");
      AfterPay.changeAfterSmile();
      bottomInfo = true;
      ququalificationvisible = true;
    } else if (where_call == "Юрист онлайн") {
      TipyHelp.changeHelp("Передите в чат с юристом");
      AfterPay.changeAfterSmile();
      leftColumnEstimation = true;
      freeDates = true;
      ququalificationvisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    form_card();
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (where_call == "Юрист онлайн") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordFinalScreen(
                    id: id,
                    institution_type: "pol",
                    service: serviceModel,
                  ),
                ),
              );
              return;
            }

            if (work) {
              if (where_call == "Заявление") {
                if (reason == '') {
                  ElegantNotification.error(
                          description: const Text('Выберете причину вызова'))
                      .show(context);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateStatementScreen(
                                reason: reason,
                                serviceModel: serviceModel,
                                serviceId: serviceModel.id,
                                cardId: medCardId,
                                type: 'pol',
                              )));
                }
              } else {
                if (reason == '') {
                  ElegantNotification.error(
                          description: const Text('Выберете причину вызова'))
                      .show(context);
                } else {
                  if (statement) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateStatementScreen(
                                  reason: reason,
                                  serviceModel: serviceModel,
                                  serviceId: serviceModel.id,
                                  cardId: medCardId,
                                  type: 'pol',
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PoliceCallScreen(
                                  reason: reason,
                                  serviceModel: serviceModel,
                                  medCardId: medCardId,
                                )));
                  }
                }
              }
            } else {
              ElegantNotification.error(
                description: const Text('Эта услуга сейчас недоступна'),
              ).show(context);
            }
          },
          child: Card(
            margin: getMargin(bottom: 12),
            elevation: 8,
            clipBehavior: Clip.hardEdge,
            child: Container(
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 71,
                        height: 120,
                        decoration: BoxDecoration(
                          color: ColorConstant.indigoA100,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(30)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomImageView(
                                url: doctor_image,
                                //height: getVerticalSize(109),
                                fit: BoxFit.cover,
                                height: 130,
                                width: 80),
                          ],
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 8, left: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 70,
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(doctor_name,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtMontserratSemiBold15Blue600),
                                            Visibility(
                                              visible: ququalificationvisible,
                                              child: Padding(
                                                  padding: getPadding(top: 4),
                                                  child: Text(
                                                      doctor_qualification,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtMontserratMedium12)),
                                            ),
                                          ]),
                                      Padding(
                                          padding: getPadding(top: 1),
                                          child: Column(
                                            children: [
                                              RichText(
                                                  text: TextSpan(
                                                    text: cost,
                                                    style: TextStyle(
                                                        color: ColorConstant
                                                            .blueGray800,
                                                        fontSize:
                                                            getFontSize(17),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  textAlign: TextAlign.left),
                                              Visibility(
                                                visible: leftColumnMeters,
                                                child: Text(meters,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtMontserratMedium15Bluegray800),
                                              ),
                                              Visibility(
                                                visible: leftColumnEstimation,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Material(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          onTap: () {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ReviewsScreen(
                                                                              serviceId: id,
                                                                              doctor_name: doctor_name,
                                                                            )));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Padding(
                                                                    padding: getPadding(
                                                                        left:
                                                                            25),
                                                                    child: Text(
                                                                        estimation
                                                                            .toStringAsFixed(
                                                                                1),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .left,
                                                                        style: AppStyle
                                                                            .txtMontserratMedium15Bluegray800)),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5),
                                                                  child: CustomImageView(
                                                                      svgPath: ImageConstant
                                                                          .imgStarGold,
                                                                      height:
                                                                          getSize(
                                                                              12),
                                                                      width:
                                                                          getSize(
                                                                              12),
                                                                      margin: getMargin(
                                                                          left:
                                                                              3,
                                                                          top:
                                                                              3,
                                                                          bottom:
                                                                              3)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ))
                                    ]),
                              ),
                              Visibility(
                                visible: bottomInfo,
                                child: Padding(
                                    padding: getPadding(top: 12),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            width: 100,
                                          ),
                                          // Text(meters,
                                          //     overflow: TextOverflow.ellipsis,
                                          //     textAlign: TextAlign.left,
                                          //     style: AppStyle
                                          //         .txtMontserratMedium15Bluegray800),
                                          // Padding(
                                          //     padding: getPadding(left: 26),
                                          //     child: Text(minute,
                                          //         overflow: TextOverflow.ellipsis,
                                          //         textAlign: TextAlign.left,
                                          //         style: AppStyle
                                          //             .txtMontserratMedium15Bluegray800)),

                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ReviewsScreen(
                                                                          serviceId:
                                                                              id,
                                                                          doctor_name:
                                                                              doctor_name,
                                                                        )));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    getPadding(
                                                                        left:
                                                                            25),
                                                                child: Text(
                                                                    estimation
                                                                        .toStringAsFixed(
                                                                            1),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtMontserratMedium15Bluegray800)),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5),
                                                              child: CustomImageView(
                                                                  svgPath:
                                                                      ImageConstant
                                                                          .imgStarGold,
                                                                  height:
                                                                      getSize(
                                                                          12),
                                                                  width:
                                                                      getSize(
                                                                          12),
                                                                  margin: getMargin(
                                                                      left: 3,
                                                                      top: 3,
                                                                      bottom:
                                                                          3)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                                CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgArrowright,
                                                    height: getVerticalSize(11),
                                                    width: getHorizontalSize(6),
                                                    margin: getMargin(
                                                        left: 30,
                                                        top: 5,
                                                        bottom: 2))
                                              ])
                                        ])),
                              ),
                              Visibility(
                                visible: freeDates,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            " ",
                                            style: AppStyle
                                                .txtMontserratMedium12Black900,
                                          ),
                                          Padding(
                                            padding: getPadding(top: 2),
                                            child: SizedBox(
                                              width: 128,
                                              child: Text(
                                                " ",
                                                style: AppStyle
                                                    .txtMontserratSemiBold15Blue600,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CustomImageView(
                                          svgPath: ImageConstant.imgArrowright,
                                          height: getVerticalSize(11),
                                          width: getHorizontalSize(6),
                                          margin: getMargin(top: 5, bottom: 2))
                                    ],
                                  ),
                                ),
                              )
                            ]),
                      )
                    ])),
          )),
    );
  }
}
