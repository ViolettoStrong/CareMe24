import 'dart:math' show cos, sqrt, asin, sin, pi;

import 'package:careme24/api/api.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/dangerous/dangerous_cubit.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/models/institution_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/request_status_model.dart';
import 'package:careme24/pages/calls/dialog_select_contact_med.dart';
import 'package:careme24/pages/calls/main_call_page.dart';
import 'package:careme24/pages/calls/medic_call_page.dart';
import 'package:careme24/pages/calls/select_instituts.dart';
import 'package:careme24/router/app_router.dart';
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
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicalCallButton extends StatefulWidget {
  const MedicalCallButton({
    super.key,
    required this.text,
    required this.selectedContact,
    this.initialInstitution,
    this.initialDistance,
    this.initialDuration,
    this.initialFavours,
  });

  final String text;
  final MedcardModel? selectedContact;
  final InstitutionModel? initialInstitution;
  final String? initialDistance;
  final String? initialDuration;
  final List<Map<String, dynamic>>? initialFavours;

  @override
  State<MedicalCallButton> createState() => _MedicalCallButtonState();
}

class _MedicalCallButtonState extends State<MedicalCallButton> {
  bool on = false;
  bool isNotifContact = false;
  bool default_institution = false;
  InstitutionModel? institutionModel;
  String distance = '';
  String duration = '';
  List<Map<String, dynamic>>? favours;
  /// Selected usluga/reason; cleared when institution changes.
  String _displayReason = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setValue();
    });
    if (widget.initialInstitution != null) {
      institutionModel = widget.initialInstitution;
      distance = widget.initialDistance ?? '--';
      duration = widget.initialDuration ?? '--';
      favours = widget.initialFavours;
      _displayReason = widget.text;
      if (widget.initialFavours == null && institutionModel != null) {
        _loadFavours(institutionModel!.id);
      }
    } else {
      _displayReason = widget.text;
      _loadDefaultInstitution('med');
    }
    widget.selectedContact != null
        ? _selectedContact = widget.selectedContact
        : _selectedContact = null;
    if (_selectedContact == null) {
      MedcardRepository.fetchMyCard().then((value) {
        AppBloc.requestCubit.medCardId = value.id;
      });
    } else {
      AppBloc.requestCubit.medCardId = _selectedContact?.id ?? '';
    }
    super.initState();
  }

  Future<void> _loadNearestInstitution() async {
    final userLat = BlocProvider.of<DangerousCubit>(context).lat;
    final userLon = BlocProvider.of<DangerousCubit>(context).lon;
    final res = await Api.loadNearestInstitution(
        lat: userLat, lon: userLon, institutionType: 'med');
    if (res != null) {
      var institution = InstitutionModel.fromJson(res['institution']);
      institution = await _applyFavouriteFromApi(institution);
      String distStr = '--';
      String durStr = '--';
      final coords = institution.location.coordinates;
      if (coords.length >= 2) {
        final instLon = coords[0].toDouble();
        final instLat = coords[1].toDouble();
        final km = _haversineKm(userLat, userLon, instLat, instLon);
        if (km != null) {
          distStr = km.toStringAsFixed(1);
          durStr = (km / 50 * 60).round().toString();
        }
      }
      if (mounted) {
        setState(() {
          institutionModel = institution;
          distance = distStr;
          duration = durStr;
        });
      }
      _loadFavours(institutionModel!.id);
    }
  }

  Future<InstitutionModel> _applyFavouriteFromApi(
      InstitutionModel institution) async {
    try {
      final result = await Api.getFavouriteInstitutions();
      if (result is! List || result.isEmpty) return institution;
      final favouriteIds = result
          .map((e) => (e is Map ? e['id'] : e)?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet();
      return institution.copyWith(
          favourite: favouriteIds.contains(institution.id));
    } catch (_) {
      return institution;
    }
  }

  Future<void> _loadFavours(String institutionId) async {
    final list = await Api.getRequestFavours(institutionId);
    if (!mounted) return;
    // Ընթացիկ հաստատությունը նույնն է — արդյունքը կիրառել, հակառակ դեպքում հին request-ի արդյունքը չբեռնի
    if (institutionModel?.id != institutionId) return;
    setState(() => favours = list);
  }

  static double? _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    if (lat1.isNaN || lon1.isNaN || lat2.isNaN || lon2.isNaN) return null;
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * asin(sqrt(a));
    return r * c;
  }

  Future<void> _loadDefaultInstitution(String type) async {
    try {
      final result = await Api.getFavouriteInstitutions();
      if (result is List && result.isNotEmpty) {
        for (final item in result) {
          final map = item is Map<String, dynamic> ? item : null;
          if (map == null) continue;
          final instType = map['type']?.toString() ?? '';
          if (instType == type) {
            final favouriteFromApi = InstitutionModel.fromJson(map);
            final favouriteId = favouriteFromApi.id;
            List<InstitutionModel> fullList = [];
            try {
              fullList = await Api.getInstitutions({'institution_type': type});
            } catch (_) {}
            InstitutionModel? institution;
            for (final e in fullList) {
              if (e.id == favouriteId) {
                institution = e.copyWith(favourite: true);
                break;
              }
            }
            final inst = institution ?? favouriteFromApi.copyWith(favourite: true);
            String distStr = '--';
            String durStr = '--';
            final coords = inst.location.coordinates;
            if (coords.length >= 2) {
              final userLat = BlocProvider.of<DangerousCubit>(context).lat;
              final userLon = BlocProvider.of<DangerousCubit>(context).lon;
              final km = _haversineKm(userLat, userLon, coords[1].toDouble(), coords[0].toDouble());
              if (km != null) {
                distStr = km.toStringAsFixed(1);
                durStr = (km / 50 * 60).round().toString();
              }
            }
            if (!mounted) return;
            setState(() {
              default_institution = true;
              institutionModel = inst.copyWith(favourite: true);
              distance = distStr;
              duration = durStr;
            });
            _loadFavours(institutionModel!.id);
            return;
          }
        }
      }
    } catch (_) {}
    await _loadNearestInstitution();
  }

  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotifContact = prefs.getBool('pay_switch_value_notif_tome') ?? false;
    });
  }

  MedcardModel? _selectedContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.gray100,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          height: getVerticalSize(48),
          leadingWidth: 43,
          leading: AppbarImage(
              height: getVerticalSize(16),
              width: getHorizontalSize(11),
              svgPath: ImageConstant.imgArrowleft,
              margin: getMargin(left: 32, top: 12, bottom: 20), 
              onTap: () async {
                final stop = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Остановить процесс?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Нет'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Да'),
                      ),
                    ],
                  ),
                );
                if (stop == true && context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRouter.appContainer);
                }
              }),
          centerTitle: true,
          title: AppbarTitle(text: "Вызвать скорую"),
          styleType: Style.bgFillBlue60001),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
            padding: getPadding(left: 24, top: 17, right: 24),
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
                            AppBloc.requestCubit.medCardId = selectedContact.id;
                          } else {
                            MedcardRepository.fetchMyCard().then((value) {
                              AppBloc.requestCubit.medCardId = value.id;
                            });
                          }
                        },
                        child: ForWhom(
                          name:
                              _selectedContact?.personalInfo.full_name ?? 'Мне',
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
                ])),
        GestureDetector(
          onTap: () {
            if (institutionModel != null && (favours == null || favours!.isEmpty)) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MedicCallPage(
                  favours: favours,
                  selectedContact: _selectedContact,
                  selectedInstitution: institutionModel,
                  institutionDistance: distance,
                  institutionDuration: duration,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 14, bottom: 24),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              color: Color.fromRGBO(178, 218, 255, 100),
            ),
            width: MediaQuery.of(context).size.width - 40,
            height: 80,
            child: Padding(
              padding: getPadding(left: 20, right: 20, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      institutionModel != null && (favours == null || favours!.isEmpty)
                          ? 'Учреждение не работает'
                          : (_displayReason.isEmpty ? 'Выбрать причину' : _displayReason),
                      style: AppStyle.txtMontserratSemiBold19,
                    ),
                  ),
                ],
              ),
            ),
          ), 
        ),
        Container(
          // height: MediaQuery.sizeOf(context).height * 0.3,
          margin: const EdgeInsets.symmetric(horizontal: 33.5),
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 18,
          ),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 0),
                blurRadius: 14.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (institutionModel != null && (favours == null || favours!.isEmpty)) {
                          ElegantNotification.error(
                            description: const Text('Учреждение не работает'),
                          ).show(context);
                          return;
                        }
                        if (favours != null && favours!.isNotEmpty && _displayReason.isEmpty) {
                          ElegantNotification.error(
                            description: const Text('Выберите причину'),
                          ).show(context);
                          return;
                        }
                        setState(() {
                          on = !on;
                        });

                        if (on) {
                          AppBloc.requestCubit.medCardId =
                              _selectedContact?.id ??
                                  AppBloc.requestCubit.medCardId;
                          RequestStatusModel resopnse =
                              await AppBloc.requestCubit.createRequest(
                            _displayReason,
                            'med',
                            false,
                            institutionModel?.id ?? '',
                          );

                          if (resopnse.isSuccess) {
                            if (widget.selectedContact != null) {
                              dynamic res = await Api.fetchCallsData(
                                  'med', widget.selectedContact!.id);
                              if (res != null) {
                                ElegantNotification.success(
                                        description: const Text(
                                            'Вызов успешно отправлен'))
                                    .show(context);
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainCallPage(
                                      text: 'Вызов скорой',
                                      requestId: res.values.first['id'],
                                      show: isNotifContact,
                                      type: 'med',
                                      latestCalls: res,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              dynamic cardId =
                                  await MedcardRepository.fetchMyCard();
                              if (cardId != null) {
                                dynamic res =
                                    await Api.fetchCallsData('med', cardId.id);
                                if (res != null) {
                                  ElegantNotification.success(
                                    description:
                                        const Text('Вызов успешно отправлен'),
                                  ).show(context);
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainCallPage(
                                        text: 'Вызов скорой',
                                        requestId: res.values.first['id'],
                                        show: isNotifContact,
                                        type: 'med',
                                        latestCalls: res,
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                            // await BlocProvider.of<DangerousCubit>(context,
                            //         listen: false)
                            //     .fetchRequests([resopnse.requestId]);

                            //TODO

                            // await PrefService.setNotifMe(true);
                            // await BlocProvider.of<DangerousCubit>(context,
                            //         listen: false)
                            //     .fetchData();
                          } else {
                            ElegantNotification.error(
                              description:
                                  const Text('Неудалось вызвать скорой'),
                            ).show(context);
                            setState(() {
                              on = false;
                            });
                          }
                        }
                      },
                      child: Opacity(
                        opacity: (institutionModel != null && (favours == null || favours!.isEmpty)) ||
                                (favours != null && favours!.isNotEmpty && _displayReason.isEmpty)
                            ? 0.5
                            : 1,
                        child: SvgPicture.asset(on
                            ? 'assets/images/m_on.svg'
                            : 'assets/images/m_off.svg'),
                      ))),
              Text(
                'Вызвать скорую',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: (institutionModel != null && (favours == null || favours!.isEmpty)) ||
                          (favours != null && favours!.isNotEmpty && _displayReason.isEmpty)
                      ? Colors.grey
                      : const Color.fromRGBO(219, 19, 91, 1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        institutionModel == null
            ? Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SelectInstituts(type: 'med'),
                      ),
                    ).then((result) async {
                      if (result == null || !mounted) return;
                      var institution = result['institution'] as InstitutionModel?;
                      if (institution != null) {
                        institution =
                            await _applyFavouriteFromApi(institution);
                      }
                      if (!mounted) return;
                      final newId = institution?.id;
                      setState(() {
                        institutionModel = institution;
                        distance = result['distance'] ?? '';
                        duration = result['duration'] ?? '';
                        _displayReason = '';
                        favours = null;
                      });
                      if (newId != null) _loadFavours(newId);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    margin: const EdgeInsets.symmetric(horizontal: 23),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(41, 142, 235, 1),
                          Color.fromRGBO(65, 73, 255, 1),
                        ])),
                    child: const Center(child: SizedBox()),
                  ),
                ))
            : Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectInstituts(type: 'med')))
                          .then((result) async {
                        if (result == null || !mounted) return;
                        var institution =
                            result['institution'] as InstitutionModel?;
                        if (institution != null) {
                          institution = await _applyFavouriteFromApi(institution);
                        }
                        if (!mounted) return;
                        final newId = institution?.id;
                        setState(() {
                          institutionModel = institution;
                          distance = result['distance'] ?? '';
                          duration = result['duration'] ?? '';
                          _displayReason = '';
                          favours = null;
                        });
                        if (newId != null) _loadFavours(newId);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 16, left: 31, right: 31, bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color.fromRGBO(0, 0, 0, 0.24),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 67,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(30)),
                                    ),
                                    child: const Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomImageView(
                                          width: 30,
                                          svgPath: 'assets/icons/medInst.svg',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          institutionModel?.name ?? '',
                                          style: const TextStyle(
                                            color: Color.fromRGBO(51, 132, 226, 1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          institutionModel?.address ?? '',
                                          style: const TextStyle(
                                            color: Color.fromRGBO(142, 150, 155, 1),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                ],
                              ),
                              const Divider(
                            color: Color.fromRGBO(221, 222, 226, 1),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 14, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                      institutionModel!.averageRating
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
                                  'Ср. цена: ${((institutionModel!.minPrice + institutionModel!.maxPrice) / 2).round()}',
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
                              children: [],
                            ),
                          ),
                            ],
                          ),
                          Positioned(
                            top: 6,
                            right: 10,
                            child: Icon(
                              institutionModel?.favourite == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 28,
                              color: institutionModel?.favourite == true
                                  ? ColorConstant.blue30001
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ))),
      ]),
      floatingActionButton: default_institution
          ? FloatingActionButton(
              backgroundColor: ColorConstant.blue60001,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение'),
                    content: const Text(
                      'Найти ближайшее учреждение?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Отмена'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _loadNearestInstitution();
                        },
                        child: const Text('Да'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.alt_route),
            )
          : null,
    );
  }
}
