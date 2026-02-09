import 'dart:convert';

import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/dangerous/dangerous_cubit.dart';
import 'package:careme24/blocs/institution/institution_cubit.dart';
import 'package:careme24/blocs/institution/institution_state.dart';
import 'package:careme24/models/institution_model.dart';
import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectInstituts extends StatefulWidget {
  const SelectInstituts({super.key, required this.type});

  final String type;

  @override
  State<SelectInstituts> createState() => _SelectInstitutsState();
}

class _SelectInstitutsState extends State<SelectInstituts> {
  List<Map<String, dynamic>>? enrichedList;
  bool _wait = true;
  bool _finish = false;
  bool _undo = false;
  bool _priceAsc = true;
  bool distanteOk = false;

  @override
  void initState() {
    super.initState();
    AppBloc.institutionCubit.fetchData(widget.type);
  }

  void sortInstitutions(SortType type) {
    if (enrichedList == null) return;

    setState(() {
      enrichedList!.sort((a, b) {
        final instA = a['institution'] as InstitutionModel;
        final instB = b['institution'] as InstitutionModel;

        switch (type) {
          case SortType.distance:
            final da =
                double.tryParse(a['distance'].toString()) ?? double.infinity;
            final db =
                double.tryParse(b['distance'].toString()) ?? double.infinity;
            return da.compareTo(db);

          case SortType.rating:
            return instB.averageRating.compareTo(instA.averageRating);

          case SortType.priceAsc:
            final pa = (instA.minPrice + instA.maxPrice) / 2;
            final pb = (instB.minPrice + instB.maxPrice) / 2;
            return pa.compareTo(pb);

          case SortType.priceDesc:
            final pa = (instA.minPrice + instA.maxPrice) / 2;
            final pb = (instB.minPrice + instB.maxPrice) / 2;
            return pb.compareTo(pa);
        }
      });
    });
  }

  Future<void> enrichDistances(List<InstitutionModel> list) async {
    final userLat = BlocProvider.of<DangerousCubit>(context).lat;
    final userLon = BlocProvider.of<DangerousCubit>(context).lon;

    final newList = await Future.wait(list.map((item) async {
      final data = await calculateDistanceAndTime(
        userLat: userLat,
        userLon: userLon,
        instLat: item.location.coordinates[1],
        instLon: item.location.coordinates[0],
      );
      distanteOk = true;
      return {
        'institution': item,
        'distance': data?['distance'] ?? '--',
        'duration': data?['duration'] ?? '--',
      };
    }));

    if (mounted) {
      setState(() {
        enrichedList = newList;
      });
    }
  }

  Future<Map<String, String>?> calculateDistanceAndTime({
    required double userLat,
    required double userLon,
    required double instLat,
    required double instLon,
  }) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/$userLon,$userLat;$instLon,$instLat?overview=false';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);

      final distance = data['routes'][0]['distance'];
      final duration = data['routes'][0]['duration'];

      final distanceKm = (distance / 1000).toStringAsFixed(1);
      final durationMin = (duration / 60).round().toString();

      return {
        'distance': distanceKm,
        'duration': durationMin,
      };
    } catch (_) {
      return null;
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
        title: AppbarTitle(text: "Выбрать учреждение"),
        styleType: Style.bgFillBlue60001,
      ),
      body: BlocBuilder<InstitutionCubit, InstitutionState>(
        builder: (context, state) {
          if (state is InstitutionLoaded) {
            final list = state.institutionList;
            if (enrichedList == null) {
              enrichedList = list
                  .map((e) => {
                        'institution': e,
                        'distance': '--',
                        'duration': '--',
                      })
                  .toList();
              enrichDistances(list);
            }

            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Путь
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            _finish = false;
                            _undo = false;
                            _wait = true;
                          });
                          distanteOk
                              ? sortInstitutions(SortType.distance)
                              : ElegantNotification.info(
                                      description: const Text(
                                          'Расстояние еще не рассчитано, попробуйте позже'))
                                  .show(context);
                        },
                        child: Container(
                          width: getHorizontalSize(109),
                          padding: getPadding(
                              left: 9, top: 10, right: 9, bottom: 10),
                          decoration: _wait
                              ? AppDecoration.txtFillBlue30001.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.txtCustomBorderTL10,
                                )
                              : BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ColorConstant.gray50002,
                                      width: 1,
                                    ),
                                  ),
                                ),
                          child: Text(
                            "Путь",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: _wait
                                ? AppStyle.txtMontserratSemiBold15
                                : TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(15),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                          ),
                        ),
                      ),
                    ),

                    // Оценка
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            _finish = true;
                            _undo = false;
                            _wait = false;
                          });
                          sortInstitutions(SortType.rating);
                        },
                        child: Container(
                          width: getHorizontalSize(109),
                          padding: getPadding(
                              left: 9, top: 10, right: 9, bottom: 10),
                          decoration: _finish
                              ? AppDecoration.txtFillBlue30001.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.txtCustomBorderTL10,
                                )
                              : BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ColorConstant.gray50002,
                                      width: 1,
                                    ),
                                  ),
                                ),
                          child: Text(
                            "Оценка",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: _finish
                                ? AppStyle.txtMontserratSemiBold15
                                : TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(15),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                          ),
                        ),
                      ),
                    ),

                    // Стоимость
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            _finish = false;
                            _undo = true;
                            _wait = false;
                            _priceAsc = !_priceAsc;
                          });
                          sortInstitutions(
                            _priceAsc ? SortType.priceAsc : SortType.priceDesc,
                          );
                        },
                        child: Container(
                          width: getHorizontalSize(109),
                          padding: getPadding(
                              left: 9, top: 10, right: 9, bottom: 10),
                          decoration: _undo
                              ? AppDecoration.txtFillBlue30001.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.txtCustomBorderTL10,
                                )
                              : BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ColorConstant.gray50002,
                                      width: 1,
                                    ),
                                  ),
                                ),
                          child: Text(
                            "Стоимость",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: _undo
                                ? AppStyle.txtMontserratSemiBold15
                                : TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(15),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: enrichedList!.length,
                itemBuilder: (context, index) {
                  final item = enrichedList![index];
                  final institution = item['institution'] as InstitutionModel;
                  final distance = item['distance'];
                  final duration = item['duration'];

                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.pop(context, {
                            'institution': institution,
                            'distance': distance,
                            'duration': duration,
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 23, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Color.fromRGBO(0, 0, 0, 0.24)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 67,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: getColor(institution.type),
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(30)),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomImageView(
                                            svgPath:
                                                getImage(institution.type)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(institution.name,
                                            style: const TextStyle(
                                                color: Color(0xFF3384E2),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600)),
                                        Text(institution.address,
                                            style: const TextStyle(
                                                color: Color(0xFF8E969B),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Color(0xFFDDDEE2)),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, top: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (distance == '--')
                                      SizedBox(
                                        width: 15,
                                        height: 15,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    Text(
                                      '${distance.length > 5 ? distance.substring(0, 6) : distance} км',
                                      style: const TextStyle(
                                        color: Color(0xFF2C3E4F),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            size: 18, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          institution.averageRating
                                              .toStringAsFixed(1),
                                          style: const TextStyle(
                                            color: Color(0xFF2C3E4F),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Ср. цена: ${((institution.minPrice + institution.maxPrice) / 2).round()}',
                                      style: const TextStyle(
                                        color: Color(0xFF2C3E4F),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, bottom: 14, top: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 3),
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color(0xFF5FB2FF)),
                                      ),
                                    ),
                                    Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              final prefix =
                                                  'default_institution_${widget.type}';

                                              await prefs.setString(
                                                  '${prefix}_id',
                                                  institution.id);
                                              await prefs.setString(
                                                  '${prefix}_name',
                                                  institution.name);
                                              await prefs.setBool(
                                                  '${prefix}_commercial',
                                                  institution.commercial);
                                              await prefs.setString(
                                                  '${prefix}_address',
                                                  institution.address);
                                              await prefs.setDouble(
                                                  '${prefix}_lat',
                                                  institution
                                                      .location.coordinates[1]);
                                              await prefs.setDouble(
                                                  '${prefix}_lon',
                                                  institution
                                                      .location.coordinates[0]);
                                              await prefs.setString(
                                                  '${prefix}_distance',
                                                  distance.toString());
                                              await prefs.setString(
                                                  '${prefix}_duration',
                                                  duration.toString());

                                              // ➕ rating
                                              await prefs.setDouble(
                                                  '${prefix}_average_rating',
                                                  institution.averageRating);

// ➕ min / max գին
                                              await prefs.setDouble(
                                                  '${prefix}_min_price',
                                                  institution.minPrice);
                                              await prefs.setDouble(
                                                  '${prefix}_max_price',
                                                  institution.maxPrice);

                                              if (!mounted) return;
                                              ElegantNotification.success(
                                                description: const Text(
                                                    'Учреждение сохранено по умолчанию'),
                                              ).show(context);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              //height: 2,
                                              child: const Text(
                                                'Оставить по умолчанию',
                                                style: TextStyle(
                                                  color: Color(0xFF5FB2FF),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                },
              ))
            ]);
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}

String? getImage(String type) {
  switch (type) {
    case 'pol':
      return ImageConstant.policehat;
    case 'mch':
      return 'assets/icons/fire.svg';
    case 'med':
      return 'assets/icons/medInst.svg';
    default:
      return null;
  }
}

Color? getColor(String type) {
  switch (type) {
    case 'pol':
      return ColorConstant.indigoA100;
    case 'mch':
      return const Color(0xFFFFBB26);
    case 'med':
      return Colors.white;
    default:
      return Colors.grey[300];
  }
}

enum SortType {
  distance,
  rating,
  priceAsc,
  priceDesc,
}
