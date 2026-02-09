// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:careme24/models/service_model.dart';
import 'package:careme24/pages/doctors/favorites_cubit.dart';
import 'package:careme24/pages/doctors/favorites_state.dart';
import 'package:careme24/pages/med/appointment_to_doctor_screen.dart';
import 'package:careme24/pages/med/reviews_list_screen.dart';
import 'package:careme24/pages/record_final_screen/record_final_screen.dart';
import 'package:careme24/pages/services_call/doctor_call_page.dart';
import 'package:careme24/utils/utils.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_decoration.dart';
import '../theme/app_style.dart';
import '../widgets/custom_image_view.dart';

class DoctorCard extends StatefulWidget {
  final String id;
  final String cardId;
  final String spspecialization;
  final String reason;
  final ServiceModel serviceModel;
  final String doctor_name;
  final String doctor_image;
  final String doctor_qualification;
  final String cost;
  final String meters;
  final String minute;
  final String estimation;
  final String where_call;
  final bool work;
  final bool verified;
  final bool isFavorite;
  final double averageRating;
  final String problem;
  final VoidCallback onFavoritePressed;
  final Color backgroundColor;

  const DoctorCard({
    super.key,
    required this.id,
    required this.cardId,
    required this.spspecialization,
    required this.reason,
    required this.serviceModel,
    required this.doctor_image,
    required this.doctor_name,
    required this.doctor_qualification,
    required this.cost,
    required this.meters,
    required this.minute,
    required this.estimation,
    required this.where_call,
    required this.verified,
    required this.isFavorite,
    required this.averageRating,
    required this.onFavoritePressed,
    required this.problem,
    this.work = true,
    this.backgroundColor = Colors.white,
  });

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool bottomInfo = false;

  bool leftColumnMeters = false;

  bool leftColumnEstimation = false;

  bool freeDates = false;
  late bool isFav;

  @override
  void initState() {
    super.initState();
    isFav = widget.isFavorite;
  }

  void form_card() {
    if (widget.where_call == "Вызов врача") {
      bottomInfo = true;
    } else if (widget.where_call == "Запись к врачу") {
      leftColumnMeters = true;
      leftColumnEstimation = true;
      freeDates = true;
    } else if (widget.where_call == "Помощь онлайн") {
      leftColumnEstimation = true;
      freeDates = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    form_card();
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteLoadedPost) {
          log(state.favoriteProductIds.first);
          setState(() {
            isFav = true;
          });
        } else if (state is FavoriteLoadedDelet) {
          setState(() {
            isFav = false;
          });
        }
      },
      child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (widget.work) {
                if (widget.where_call == "Помощь онлайн") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordFinalScreen(
                        id: widget.id,
                        institution_type: "med",
                        service: widget.serviceModel,
                      ),
                    ),
                  );
                  return;
                } else if (widget.where_call == "Запись к врачу") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentToDoctorScreen(
                          serviceModel: widget.serviceModel,
                          cardId: widget.cardId,
                          problem: widget.problem),
                    ),
                  );
                  return;
                } else {
                  if (widget.reason == '') {
                    ElegantNotification.error(
                            description: const Text('Выберете причину вызова'))
                        .show(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorCallScreen(
                          reason: widget.reason,
                          serviceModel: widget.serviceModel,
                          cardId: widget.cardId,
                        ),
                      ),
                    );
                  }
                }
              } else {
                ElegantNotification.error(
                  description: const Text('Эта услуга сейчас недоступна'),
                ).show(context);
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: getMargin(bottom: 12),
              elevation: 4,
              clipBehavior: Clip.hardEdge,
              child: Container(
                height: 135,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      url: widget.doctor_image,
                      //height: getVerticalSize(109),
                      fit: BoxFit.cover,
                      height: 135,
                      width: 80,
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            getPadding(top: 8, left: 8, bottom: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 70,
                              width: MediaQuery.of(context).size.width / 1.6,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                3,
                                            child: Text(widget.doctor_name,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtMontserratSemiBold15Blue600),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Text(widget.spspecialization,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtMontserratSemiBold15Gray50001),
                                          ),
                                          Padding(
                                              padding: getPadding(top: 0),
                                              child: Text(
                                                  widget.doctor_qualification,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtMontserratMedium12)),
                                        ]),
                                    Padding(
                                        padding: getPadding(top: 1),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: RichText(
                                                  text: TextSpan(
                                                    text: widget.cost,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: ColorConstant
                                                            .blueGray800,
                                                        fontSize:
                                                            getFontSize(16),
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  textAlign: TextAlign.left),
                                            ),
                                            Visibility(
                                              visible: leftColumnMeters,
                                              child: Text(widget.meters,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtMontserratMedium15Bluegray800),
                                            ),
                                          ],
                                        ))
                                  ]),
                            ),
                            Visibility(
                              visible: bottomInfo,
                              child: Padding(
                                padding: getPadding(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 90),

                                    // Text(widget.meters,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     textAlign: TextAlign.left,
                                    //     style: AppStyle
                                    //         .txtMontserratMedium15Bluegray800),
                                    // Padding(
                                    //     padding: getPadding(left: 26),
                                    //     child: Text(widget.minute,
                                    //         overflow:
                                    //             TextOverflow.ellipsis,
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
                                                  BorderRadius.circular(10),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReviewsScreen(
                                                        serviceId: widget.id,
                                                        doctor_name:
                                                            widget.doctor_name,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                          padding: getPadding(
                                                              left: 25),
                                                          child: Text(
                                                              widget
                                                                  .averageRating
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
                                                                .only(left: 5),
                                                        child: CustomImageView(
                                                          svgPath: ImageConstant
                                                              .imgStarGold,
                                                          height: getSize(12),
                                                          width: getSize(12),
                                                          margin: getMargin(
                                                              left: 3,
                                                              top: 3,
                                                              bottom: 3),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          Material(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onTap:
                                                      widget.onFavoritePressed,
                                                  child: CustomImageView(
                                                    svgPath:
                                                        ImageConstant.heart_fav,
                                                    height: 24,
                                                    width: 24,
                                                    color: widget.isFavorite
                                                        ? Colors.red
                                                        : Colors.grey,
                                                    margin: getMargin(
                                                        left: 15,
                                                        top: 5,
                                                        bottom: 2),
                                                  ))),
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: freeDates,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                    Visibility(
                                        visible: leftColumnEstimation,
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReviewsScreen(
                                                            doctor_name: widget
                                                                .doctor_name,
                                                            serviceId:
                                                                widget.id,
                                                          )));

                                              // showDialog(
                                              //   context: context,
                                              //   builder: (context) =>
                                              //       ReviewDialog(),
                                              // );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      widget.averageRating
                                                          .toStringAsFixed(1),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
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
                                          ),
                                        )),
                                    CustomImageView(
                                        svgPath: ImageConstant.imgArrowright,
                                        height: getVerticalSize(11),
                                        width: getHorizontalSize(6),
                                        margin: getMargin(top: 5, bottom: 2))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
