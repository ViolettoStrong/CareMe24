// ignore_for_file: non_constant_identifier_names

import 'package:careme24/constants.dart';
import 'package:careme24/models/service_model.dart';
import 'package:careme24/pages/record_final_screen/record_final_screen.dart';
import 'package:careme24/pages/services_call/create_statement_screen.dart';
import 'package:careme24/pages/services_call/mes_call_screen.dart';
import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/utils/utils.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import '../theme/app_style.dart';
import '../widgets/custom_image_view.dart';

class MESCard extends StatelessWidget {
  final String mes_image;
  final String mes_name;
  final String mes_qualification;
  final String cost;
  final String meters;
  final String minute;
  final String estimation;
  final String where_call;
  final String reason;
  final ServiceModel serviceModel;
  final bool work;
  final bool statement;
  final String medCardId;
  final String call_scree;
  bool bottomInfo = false;
  bool leftColumnMeters = false;
  bool leftColumnEstimation = false;
  bool freeDates = false;
  bool qualificationvisible = true;
  final Color backgroundColor;

  MESCard({
    super.key,
    required this.mes_image,
    required this.mes_name,
    required this.mes_qualification,
    required this.cost,
    required this.meters,
    required this.minute,
    required this.estimation,
    required this.where_call,
    required this.reason,
    required this.serviceModel,
    required this.call_scree,
    this.work = true,
    this.statement = false,
    required this.medCardId,
    this.backgroundColor = Colors.white,
  });

  void form_card() {
    if (where_call == "Сообщить") {
      AfterPay.changeAfterMinute();
      bottomInfo = true;
    } else if (where_call == "Заявление") {
      TipyHelp.changeHelp(
          "В течение дня с вами свяжутся по телефону или напишут в сообщениях");
      AfterPay.changeAfterSmile();
      bottomInfo = true;
    } else if (where_call == "Помощь онлайн") {
      TipyHelp.changeHelp("Предите в чат, что бы получить помощь");
      AfterPay.changeAfterSmile();
      bottomInfo = true;
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
            if (call_scree == "Помощь онлайн") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordFinalScreen(
                    id: medCardId,
                    institution_type: "mch",
                    service: serviceModel,
                  ),
                ),
              );
              return;
            }

            if (work) {
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
                                type: 'mch',
                              )));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MesCallScreen(
                                reason: reason,
                                serviceModel: serviceModel,
                                medCardId: medCardId,
                              )));
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 71,
                          height: 109,
                          decoration: BoxDecoration(
                            color: ColorConstant.yellow700,
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(30)),
                          ),
                          child: Stack(alignment: Alignment.center, children: [
                            CustomImageView(
                              url: mes_image,
                              // svgPath: ImageConstant.fireSmallIcon,
                            ),
                          ])),
                      Padding(
                        padding: getPadding(top: 8, left: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 60,
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
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              child: Text(mes_name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtMontserratSemiBold15Blue600),
                                            ),
                                            Expanded(
                                              child: Visibility(
                                                visible: qualificationvisible,
                                                child: Padding(
                                                    padding: getPadding(top: 0),
                                                    child: Text(
                                                        mes_qualification,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtMontserratMedium12)),
                                              ),
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
                                                  children: [
                                                    Text(estimation,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtMontserratMedium15Bluegray800),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgStarGold,
                                                        height: getSize(12),
                                                        width: getSize(12),
                                                        margin: getMargin(
                                                            left: 3,
                                                            top: 3,
                                                            bottom: 3)),
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
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(meters,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtMontserratMedium15Bluegray800),
                                          Padding(
                                              padding: getPadding(left: 26),
                                              child: Text(minute,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtMontserratMedium15Bluegray800)),
                                          Padding(
                                              padding: getPadding(left: 25),
                                              child: Text(estimation,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtMontserratMedium15Bluegray800)),
                                          CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgStarGold,
                                              height: getSize(12),
                                              width: getSize(12),
                                              margin: getMargin(
                                                  left: 3, top: 3, bottom: 3)),
                                          CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgArrowright,
                                              height: getVerticalSize(11),
                                              width: getHorizontalSize(6),
                                              margin: getMargin(
                                                  left: 30, top: 5, bottom: 2))
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
                                            "",
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
