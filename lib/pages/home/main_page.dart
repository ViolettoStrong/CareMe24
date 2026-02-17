import 'dart:async';
import 'dart:ui';

import 'package:careme24/api/api.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/application/application_cubit.dart';
import 'package:careme24/blocs/application/application_state.dart';
import 'package:careme24/blocs/auth/auth_cubit.dart';
import 'package:careme24/blocs/auth/auth_state.dart';
import 'package:careme24/blocs/dangerous/dangerous_cubit.dart';
import 'package:careme24/blocs/dangerous/dangerous_state.dart';
import 'package:careme24/features/danger_icons/controller/danger_icons_ctrl.dart';
import 'package:careme24/features/danger_icons/presentation/widgets/danger_icon_card.dart';
import 'package:careme24/features/notifications/notifications_ctrl.dart';
import 'package:careme24/injection_container.dart';
import 'package:careme24/locator.dart';
import 'package:careme24/main.dart';
import 'package:careme24/pages/calls/help_screen_touch_page.dart';
import 'package:careme24/pages/calls/main_call_page.dart';
import 'package:careme24/pages/contact_help_info.dart';
import 'package:careme24/features/notifications/presentation/notifications_screen.dart';
import 'package:careme24/pages/home/animation_calls.dart';
import 'package:careme24/pages/settings/settings_page.dart';
import 'package:careme24/repositories/medcard_repository.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/features/danger_icons/presentation/dangerous_icons_list.dart';
import 'package:careme24/widgets/drawer_widget.dart';
import 'package:careme24/widgets/no_auth_overlay.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';

@pragma('vm:entry-point')
void onServiceStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  await init(); // getIt init

  final dangerIconsCtrl = getIt<DangerIconsCtrl>();
  await dangerIconsCtrl.initDangerIcons();

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  service.on('stopService').listen((_) {
    service.stopSelf();
  });
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomeScreenState();
}

bool isGeolocationEnable = false;
String addres = '';

class _HomeScreenState extends State<MainPage> {
  bool showContactNotif = true;
  bool isNotifContact = false;
  late Timer _timer;
  late bool authorization;
  late bool isCallingPol = false;
  late bool isCallingMed = false;
  late bool isCallingMch = false;
  dynamic resPol;
  dynamic resMed;
  dynamic resMch;

  DangerIconsCtrl dangerIconsCtrl = getIt<DangerIconsCtrl>();
  final notificationsCtrl = getIt<NotificationsCtrl>();
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;

  late bool centerValue = false;
  late bool shakeValue = false;
  bool isFingerDown = false;
  bool showShakeText = false;
  StreamSubscription? _volumeButtonSubscription;
  bool isVolumePressed = false;

  @override
  void initState() {
    final appState = context.read<ApplicationCubit>().state;
    authorization = appState is ApplicationCompleted && appState.isAuthorized;
    getMyCalls();
    setValue();
    dangerIconsCtrl.initDangerIcons();
    _initVolumeListener();
    _initializeShakeListener();

    if (appState is ApplicationCompleted && appState.isAuthorized) {
      AppBloc.dangerousCubit.getLocation();
      notificationsCtrl.fetchNotifications();
    }
    super.initState();
    _loadSavedSwitchValue();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      AppBloc.dangerousCubit.fetchData();
    });
    _startBackgroundService();
  }

  bool isNavigating = false;

  void _initVolumeListener() {
    VolumeController().listener((volume) {
      // user pressed volume button → volume changed
      isVolumePressed = true;

      // pressed state should last only a short time
      Future.delayed(const Duration(milliseconds: 300), () {
        isVolumePressed = false;
      });
    });

    // Enable listener
    VolumeController().showSystemUI = false;
  }

  void _initializeShakeListener() {
    _accelerometerSubscription = userAccelerometerEvents.listen((event) {
      final acceleration = event.x.abs() + event.y.abs() + event.z.abs();
      if (!mounted) return;

      final bool shakeEnabled = shakeSwitchNotifier.value;
      final bool centerEnabled = centerSwitchNotifier.value;

      // ------------ CASE 1: SHAKE SWITCH + VOLUME BUTTON ------------
      if (shakeEnabled &&
          acceleration > 10 &&
          isVolumePressed &&
          !isNavigating) {
        _openShakePage();
        return;
      }

      if (centerEnabled && acceleration > 10 && isFingerDown && !isNavigating) {
        _openShakePage();
        return;
      }
    });
  }

  void _openShakePage() {
    print('Shake detected');
    isNavigating = true;
    navigatorKey.currentState?.pushNamed(AppRouter.careMeScreen,
        arguments: {'isShake': true}).then((_) {
      setState(() {
        isNavigating = false;
      });
    });
  }

  Future<void> _loadSavedSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    bool? cValue = prefs.getBool('center_shake_switch_value');
    bool? sValue = prefs.getBool('volume_shake_switch_value');
    if (cValue != null) {
      centerValue = cValue;
      centerSwitchNotifier.value = cValue;
    } else {
      centerSwitchNotifier.value = false;
      centerValue = false;
    }
    if (sValue != null) {
      shakeValue = sValue;
      shakeSwitchNotifier.value = sValue;
    } else {
      shakeSwitchNotifier.value = false;
      shakeValue = false;
    }
  }

  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotifContact = prefs.getBool('pay_switch_value_notif_tome') ?? false;
    });
  }

  Future<void> getMyCalls() async {
    final card = await MedcardRepository.fetchMyCard();
    if (card == null) return;

    try {
      final dynamic response = await Api.fetchCallsData('any', card.id);
      final dynamic responseList = response;

      if (responseList.isEmpty) {
        setState(() {
          isCallingPol = false;
          isCallingMed = false;
          isCallingMch = false;
          resPol = null;
          resMed = null;
          resMch = null;
        });
        return;
      }
      final polList = responseList.where((e) => e['type'] == 'pol').toList();
      final medList = responseList.where((e) => e['type'] == 'med').toList();
      final mchList = responseList.where((e) => e['type'] == 'mch').toList();

      Map<String, dynamic>? latestByDate(List list) {
        if (list.isEmpty) return null;
        list.sort((a, b) => DateTime.parse(b['created_at'])
            .compareTo(DateTime.parse(a['created_at'])));
        return list.first;
      }

      Map<String, Map<String, dynamic>>? wrapAsNestedMap(
          Map<String, dynamic>? call) {
        if (call == null) return null;
        final cardId = call['card_id'] ?? 'unknown_card';
        return {cardId: call};
      }

      setState(() {
        resPol = wrapAsNestedMap(latestByDate(polList));
        resMed = wrapAsNestedMap(latestByDate(medList));
        resMch = wrapAsNestedMap(latestByDate(mchList));

        isCallingPol = resPol != null;
        isCallingMed = resMed != null;
        isCallingMch = resMch != null;
      });
    } catch (e) {
      setState(() {
        isCallingPol = false;
        isCallingMed = false;
        isCallingMch = false;
        resPol = null;
        resMed = null;
        resMch = null;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _accelerometerSubscription?.cancel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DangerousCubit dangerousCubit =
        BlocProvider.of<DangerousCubit>(context, listen: false);
    return NoAuthOverlay(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(41, 142, 235, 1),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(children: [
          Expanded(
            child: Container(
                height: 34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConstant.whiteA700),
                child: Center(
                  child: Row(children: [
                    Image.asset(
                      'assets/images/location_on.png',
                    ),
                    Expanded(
                      child: Text(
                        addres,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Color(0xffB8BBC3),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                )),
          ),
          const SizedBox(width: 20),
          ListenableBuilder(
            listenable: notificationsCtrl,
            builder: (context, _) {
              return ListenableBuilder(
                listenable: dangerIconsCtrl,
                builder: (context, _) {
                  final hasNotif = !notificationsCtrl.isLoading &&
                      (notificationsCtrl.notifications.isNotEmpty ||
                          dangerIconsCtrl.notifIcons.isNotEmpty);
                  final notifCount = dangerIconsCtrl.notifIcons.length +
                      notificationsCtrl.notifications.length;

                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.notifications,
                              size: 30,
                              color: Colors.white,
                            ),
                            if (hasNotif)
                              Positioned(
                                left: 14,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  constraints: const BoxConstraints(
                                    minWidth: 15,
                                    minHeight: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      notifCount >= 10
                                          ? '9+'
                                          : notifCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )),
                  );
                },
              );
            },
          )
        ]),
      ),
      backgroundColor: ColorConstant.whiteA700,
      drawer: Drawer(child: DrawerWidget()),
      body: BlocConsumer<DangerousCubit, DangerousState>(
        listener: (context, state) => {
          if (state is DangerousLoaded)
            {
              setState(() {
                isGeolocationEnable = state.isGeoEnable;
                addres = state.address;
              })
            }
        },
        builder: (context, state) {
          final double parentHeight = MediaQuery.of(context).size.height -
              131 -
              20 -
              78.5 -
              MediaQuery.of(context).padding.top -
              110;
          if (state is DangerousLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: getPadding(top: 4, bottom: 0),
                      decoration: AppDecoration.outlineBlack90026,
                      child: DangerousIconsList(
                        isGeoEnable: state is DangerousLoaded
                            ? state.isGeoEnable
                            : false,
                      ),
                    ),
                    Padding(
                        padding: getPadding(
                            top: 18, right: 10, left: 10, bottom: 10),
                        child: SizedBox(
                          height: parentHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: centerSwitchNotifier,
                                builder: (context, centerVal, _) {
                                  return ValueListenableBuilder(
                                    valueListenable: shakeSwitchNotifier,
                                    builder: (context, shakeVal, __) {
                                      final shouldShowSmallCards =
                                          !centerVal && !shakeVal;

                                      return shouldShowSmallCards
                                          ? Padding(
                                              padding: getPadding(left: 3),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                            ElegantNotification.info(
                                                                    description:
                                                                        const Text(
                                                                            'Компонент в разработке'))
                                                                .show(context);
                                                          },
                                                          child: Container(
                                                              height:
                                                                  parentHeight *
                                                                      0.32,
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      2 -
                                                                  15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    67,
                                                                    211,
                                                                    194),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  getHorizontalSize(
                                                                    10,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                8,
                                                                            top:
                                                                                8),
                                                                        child:
                                                                            Text(
                                                                          "Care Me 24",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                ColorConstant.whiteA700,
                                                                            fontSize:
                                                                                20,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Positioned(
                                                                    right: -9,
                                                                    bottom: -8,
                                                                    child:
                                                                        CustomImageView(
                                                                      width:
                                                                          105,
                                                                      height:
                                                                          95,
                                                                      color: isGeolocationEnable
                                                                          ? null
                                                                          : ColorConstant
                                                                              .gray1001,
                                                                      svgPath:
                                                                          ImageConstant
                                                                              .aiicon,
                                                                    ),
                                                                  )
                                                                ],
                                                              )))),
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
                                                            if (isGeolocationEnable) {
                                                              if (authorization ==
                                                                  false) {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    AppRouter
                                                                        .careMeCallStartPage);
                                                              } else if (state
                                                                      is DangerousLoaded &&
                                                                  state
                                                                      .myMedCard
                                                                      .haveCard) {
                                                                AppBloc
                                                                    .requestCubit
                                                                    .setMedCardID(state
                                                                        .myMedCard
                                                                        .id);
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    AppRouter
                                                                        .careMeCallStartPage);
                                                              } else {
                                                                ElegantNotification.error(
                                                                        description:
                                                                            const Text(
                                                                                'У вас нет профиля'))
                                                                    .show(
                                                                        context);
                                                              }
                                                            } else {
                                                              AppBloc
                                                                  .dangerousCubit
                                                                  .getLocation();
                                                            }
                                                          },
                                                          child: Container(
                                                              height:
                                                                  parentHeight *
                                                                      0.32,
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      2 -
                                                                  15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xFFA349A3),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  getHorizontalSize(
                                                                    10,
                                                                  ),
                                                                ),
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                8,
                                                                            top:
                                                                                8),
                                                                        child:
                                                                            Text(
                                                                          "Я очевидец",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                ColorConstant.whiteA700,
                                                                            fontSize:
                                                                                20,
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Positioned(
                                                                    right: -10,
                                                                    bottom: -3,
                                                                    child:
                                                                        CustomImageView(
                                                                      width:
                                                                          105,
                                                                      height:
                                                                          95,
                                                                      color: isGeolocationEnable
                                                                          ? null
                                                                          : ColorConstant
                                                                              .gray1001,
                                                                      svgPath:
                                                                          ImageConstant
                                                                              .camera,
                                                                    ),
                                                                  )
                                                                ],
                                                              )))),
                                                ],
                                              ))
                                          : Padding(
                                              padding: getPadding(left: 3),
                                              child: Material(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      onTap: () {
                                                        ElegantNotification
                                                            .info(
                                                          description: const Text(
                                                              'Компонент в разработке'),
                                                        ).show(context);
                                                      },
                                                      child: Container(
                                                          height: parentHeight *
                                                              0.32,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: (isGeolocationEnable
                                                                  ? AppDecoration
                                                                      .fillcyan300
                                                                  : AppDecoration
                                                                      .fillgrey)
                                                              .copyWith(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .roundedBorder10,
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 8,
                                                                        top: 8),
                                                                    child: Text(
                                                                      "CareMe 24",
                                                                      style:
                                                                          TextStyle(
                                                                        color: ColorConstant
                                                                            .whiteA700,
                                                                        fontSize:
                                                                            20,
                                                                        fontFamily:
                                                                            'Montserrat',
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Positioned(
                                                                right: -10,
                                                                bottom: -8,
                                                                child:
                                                                    CustomImageView(
                                                                  width: 120,
                                                                  height: 110,
                                                                  color: isGeolocationEnable
                                                                      ? null
                                                                      : ColorConstant
                                                                          .gray1001,
                                                                  svgPath:
                                                                      ImageConstant
                                                                          .aiicon,
                                                                ),
                                                              )
                                                            ],
                                                          )))));
                                    },
                                  );
                                },
                              ),
                              /////////////////////////////////////////////////////
                              ///////////////////////////////////////////////////
                              ///
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Column(
                                      children: [
                                        HoldDetector(
                                            type: 'pol',
                                            onHoldComplete: () {
                                              if (isCallingPol) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => MainCallPage(
                                                      text: 'Вызов полиции',
                                                      requestId: resPol.values.first['id'],
                                                      show: isNotifContact,
                                                      type: 'pol',
                                                      latestCalls: resPol,
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }
                                              if (isGeolocationEnable) {
                                                if (authorization == false) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              HelpScreenTouch(
                                                                type: 'pol',
                                                              )));
                                                } else if (state
                                                        is DangerousLoaded &&
                                                    state.myMedCard.haveCard) {
                                                  AppBloc.requestCubit
                                                      .setMedCardID(
                                                          state.myMedCard.id);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              HelpScreenTouch(
                                                                type: 'pol',
                                                              )));
                                                  ;
                                                } else {
                                                  ElegantNotification.error(
                                                          description: const Text(
                                                              'У вас нет профиля'))
                                                      .show(context);
                                                }
                                              } else {
                                                AppBloc.dangerousCubit
                                                    .getLocation();
                                              }
                                            },
                                            child: Material(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    onTap: null,
                                                    child: Container(
                                                        height:
                                                            parentHeight * 0.32,
                                                        width: MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            15,
                                                        decoration: isGeolocationEnable
                                                            ? AppDecoration
                                                                .fillIndigoA100
                                                                .copyWith(
                                                                    borderRadius:
                                                                        BorderRadiusStyle
                                                                            .roundedBorder10)
                                                            : AppDecoration
                                                                .fillgrey
                                                                .copyWith(
                                                                    borderRadius:
                                                                        BorderRadiusStyle
                                                                            .roundedBorder10),
                                                        child: Stack(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8,
                                                                          top:
                                                                              8),
                                                                  child: Text(
                                                                      "Охрана\nправопорядка",
                                                                      softWrap:
                                                                          true,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtMontserratSemiBold15),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 8,
                                                                        top: 4),
                                                                    child:
                                                                        Container(
                                                                      margin: getMargin(
                                                                          top:
                                                                              4),
                                                                      child:
                                                                          Text(
                                                                        "Совершается\nпреступление ",
                                                                        maxLines:
                                                                            null,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: AppStyle
                                                                            .txtMontserratMedium12WhiteA700,
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                            Positioned(
                                                              right: -2,
                                                              bottom: 0,
                                                              child:
                                                                  CustomImageView(
                                                                width: 120,
                                                                height: 110,
                                                                color: isGeolocationEnable
                                                                    ? null
                                                                    : ColorConstant
                                                                        .gray1001,
                                                                svgPath:
                                                                    ImageConstant
                                                                        .imgFrameHalf,
                                                              ),
                                                            ),
                                                            isCallingPol
                                                                ? Positioned(
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child: SizedBox(
                                                                        width: MediaQuery.of(context).size.width / 2.5,
                                                                        height: 35,
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => MainCallPage(
                                                                                    text: 'Вызов полиции',
                                                                                    requestId: resPol.values.first['id'],
                                                                                    show: isNotifContact,
                                                                                    type: 'pol',
                                                                                    latestCalls: resPol,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            child: AutoExpandBox())))
                                                                : Container()
                                                          ],
                                                        ))))),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        HoldDetector(
                                            type: 'mch',
                                            onHoldComplete: () {
                                              if (isCallingMch) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => MainCallPage(
                                                      text: 'Вызов МЧС',
                                                      requestId: resMch.values.first['id'],
                                                      show: isNotifContact,
                                                      type: 'mch',
                                                      latestCalls: resMch,
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }
                                              if (isGeolocationEnable) {
                                                if (authorization == false) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            HelpScreenTouch(
                                                              type: 'med',
                                                            )),
                                                  );
                                                } else if (state
                                                        is DangerousLoaded &&
                                                    state.myMedCard.haveCard) {
                                                  AppBloc.requestCubit
                                                      .setMedCardID(
                                                          state.myMedCard.id);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            HelpScreenTouch(
                                                              type: 'mch',
                                                            )),
                                                  );
                                                } else {
                                                  ElegantNotification.error(
                                                          description: const Text(
                                                              'У вас нет профиля'))
                                                      .show(context);
                                                }
                                              } else {
                                                AppBloc.dangerousCubit
                                                    .fetchData();
                                              }
                                            },
                                            child: Material(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    onTap: null,
                                                    child: Container(
                                                        height:
                                                            parentHeight * 0.32,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            15,
                                                        decoration:
                                                            isGeolocationEnable
                                                                ? AppDecoration
                                                                    .fillYellow700
                                                                    .copyWith(
                                                                        borderRadius:
                                                                            BorderRadiusStyle
                                                                                .roundedBorder10)
                                                                : AppDecoration
                                                                    .fillgrey
                                                                    .copyWith(
                                                                    borderRadius:
                                                                        BorderRadiusStyle
                                                                            .roundedBorder10,
                                                                  ),
                                                        child: Stack(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8,
                                                                          top:
                                                                              8),
                                                                  child: Text(
                                                                      "Служба спасения",
                                                                      maxLines:
                                                                          null,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: AppStyle
                                                                          .txtMontserratSemiBold15),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: 8,
                                                                        top: 4),
                                                                    child:
                                                                        Container(
                                                                      margin: getMargin(
                                                                          top:
                                                                              4),
                                                                      child:
                                                                          Text(
                                                                        "Стихийное\nбедствие ",
                                                                        maxLines:
                                                                            null,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: AppStyle
                                                                            .txtMontserratMedium12WhiteA700,
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                            Positioned(
                                                              right: -18,
                                                              bottom: 0,
                                                              child:
                                                                  CustomImageView(
                                                                width: 130,
                                                                height: 110,
                                                                color: isGeolocationEnable
                                                                    ? null
                                                                    : ColorConstant
                                                                        .gray1001,
                                                                svgPath:
                                                                    ImageConstant
                                                                        .imgFire,
                                                              ),
                                                            ),
                                                            isCallingMch
                                                                ? Positioned(
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    child: SizedBox(
                                                                        width: MediaQuery.of(context).size.width / 2.5,
                                                                        height: 35,
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => MainCallPage(
                                                                                    text: 'Вызов МЧС',
                                                                                    requestId: resMch.values.first['id'],
                                                                                    show: isNotifContact,
                                                                                    type: 'mch',
                                                                                    latestCalls: resMch,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            child: AutoExpandBox())))
                                                                : Container()
                                                          ],
                                                        ))))),
                                      ],
                                    )),
                                    HoldDetector(
                                        type: 'med',
                                        onHoldComplete: () {
                                          if (isCallingMed) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MainCallPage(
                                                  text: 'Вызов скорой',
                                                  requestId: resMed.values.first['id'],
                                                  show: isNotifContact,
                                                  type: 'med',
                                                  latestCalls: resMed,
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          if (isGeolocationEnable) {
                                            if (authorization == false) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        HelpScreenTouch(
                                                            type: 'med')),
                                              );
                                            } else if (state
                                                    is DangerousLoaded &&
                                                state.myMedCard.haveCard) {
                                              AppBloc.requestCubit.setMedCardID(
                                                  state.myMedCard.id);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        HelpScreenTouch(
                                                            type: 'med')),
                                              );
                                            } else {
                                              ElegantNotification.error(
                                                description: const Text(
                                                    'У вас нет профиля'),
                                              ).show(context);
                                            }
                                          } else {
                                            AppBloc.dangerousCubit
                                                .getLocation();
                                          }
                                        },
                                        child: Material(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: null,
                                                child: Container(
                                                    height:
                                                        parentHeight * 0.67 - 5,
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            15,
                                                    decoration: isGeolocationEnable
                                                        ? AppDecoration
                                                            .fillPink300
                                                            .copyWith(
                                                                borderRadius:
                                                                    BorderRadiusStyle
                                                                        .roundedBorder10)
                                                        : AppDecoration.fillgrey
                                                            .copyWith(
                                                                borderRadius:
                                                                    BorderRadiusStyle
                                                                        .roundedBorder10),
                                                    child: Stack(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 8,
                                                                      top: 8),
                                                              child: Text(
                                                                  "Медицинская помощь ",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: AppStyle
                                                                      .txtMontserratSemiBold15),
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 8,
                                                                        top: 4),
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      getMargin(
                                                                          top:
                                                                              4),
                                                                  child: Text(
                                                                    "Экстренный вызов ",
                                                                    maxLines:
                                                                        null,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: AppStyle
                                                                        .txtMontserratMedium12WhiteA700,
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                        Positioned(
                                                          right: -50,
                                                          bottom: 8,
                                                          child: Image.asset(
                                                            ImageConstant
                                                                .imgGroup7335,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.2,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        isCallingMed
                                                            ? Positioned(
                                                                right: 0,
                                                                bottom: 0,
                                                                child: SizedBox(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        2.5,
                                                                    height: 35,
                                                                    child: GestureDetector(
                                                                        onTap: () {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => MainCallPage(
                                                                                text: 'Вызов скорой',
                                                                                requestId: resMed.values.first['id'],
                                                                                show: isNotifContact,
                                                                                type: 'med',
                                                                                latestCalls: resMed,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        child: AutoExpandBox())))
                                                            : Container()
                                                      ],
                                                    ))))),
                                  ])
                            ],
                          ),
                        ))
                  ],
                ),
                if (state is DangerousLoaded &&
                    state.showcontactNotif &&
                    showContactNotif)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(120, 120, 120, 0.24),
                              blurRadius: 13)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    setState(() {
                                      showContactNotif = false;
                                    });
                                  },
                                  child: const Icon(Icons.close),
                                ),
                              )),
                          const Text(
                            textAlign: TextAlign.center,
                            'Вам пришел запрос на\nдобавление из контактов',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  setState(() {
                                    showContactNotif = false;
                                  });
                                  Navigator.pushNamed(context, AppRouter.calls);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(65, 73, 255, 1),
                                      Color.fromRGBO(41, 142, 235, 1),
                                    ]),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Перейти',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ListenableBuilder(
                  listenable: dangerousCubit,
                  builder: (context, _) {
                    if (state is DangerousLoaded) {
                      for (var request in state.requests) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.maxFinite,
                            margin: const EdgeInsets.only(
                                right: 24, left: 24, bottom: 24),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(120, 120, 120, 0.24),
                                    blurRadius: 13)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          setState(() {
                                            state.requests.remove(request);
                                          });
                                          // dangerousCubit.removeRequest(request.id);
                                        },
                                        child: const Icon(Icons.close),
                                      ),
                                    )),
                                Text(
                                  request.fullName,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(44, 62, 79, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${request.phone}',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(51, 132, 226, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 26),
                                const Text(
                                  'Был осуществлен вызов',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SvgPicture.asset(
                                    'assets/icons/${request.type}.svg'),
                                const SizedBox(
                                  height: 20,
                                ),
                                Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ContactHelpInfo(
                                                    request: request),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 9),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color.fromRGBO(41, 142, 235, 1),
                                                Color.fromRGBO(65, 73, 255, 1)
                                              ]),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Перейти',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        );
                      }
                    }

                    return const SizedBox();
                  },
                ),
                ListenableBuilder(
                  listenable: dangerIconsCtrl,
                  builder: (context, _) {
                    if (dangerIconsCtrl.newIcons.isEmpty) {
                      return const SizedBox();
                    }
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: dangerIconsCtrl.newIcons
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final e = entry.value;
                          if (index == dangerIconsCtrl.newIcons.length - 1) {
                            newIconsShownThisSession = false;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 24, left: 24, bottom: 24),
                            child: DangerIconCard(
                              icon: e,
                              onClose: () {
                                dangerIconsCtrl
                                    .removeNewDangerIcon(e.incidentType);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                Positioned.fill(
                  top: parentHeight * 0.57,
                  child: ValueListenableBuilder(
                    valueListenable: centerSwitchNotifier,
                    builder: (context, centerVal, _) {
                      return ValueListenableBuilder(
                        valueListenable: shakeSwitchNotifier,
                        builder: (context, shakeVal, __) {
                          return centerVal == true
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTapDown: (_) {
                                          setState(() {
                                            isFingerDown = true;
                                            showShakeText = true;
                                          });
                                        },
                                        onTapUp: (_) {
                                          setState(() {
                                            isFingerDown = false;
                                            showShakeText = false;
                                          });
                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            isFingerDown = false;
                                            showShakeText = false;
                                          });
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: CustomImageView(
                                              color: isGeolocationEnable
                                                  ? null
                                                  : ColorConstant.gray1001,
                                              height: (MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          4) /
                                                      2 -
                                                  48,
                                              svgPath: ImageConstant.camera,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      if (showShakeText)
                                        const Text(
                                          'Встряхните телефон!',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : const SizedBox();
                        },
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    ));
  }

  Future<void> _startBackgroundService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onServiceStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'danger_ws',
        initialNotificationTitle: 'CareMe24',
        initialNotificationContent: 'Вы всегда будете в курсе опасностей',
        foregroundServiceNotificationId: 111,
      ),
      iosConfiguration: IosConfiguration(
        onForeground: onServiceStart,
        onBackground: (_) => true,
      ),
    );

    final isRunning = await service.isRunning();

    if (!isRunning) {
      await service.startService();
    } else {
      debugPrint("⚡ BackgroundService already running, skip start");
    }
  }
}

class HoldDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onHoldComplete;
  final String type;

  const HoldDetector(
      {super.key,
      required this.child,
      required this.onHoldComplete,
      required this.type});

  @override
  State<HoldDetector> createState() => _HoldDetectorState();
}

class _HoldDetectorState extends State<HoldDetector>
    with SingleTickerProviderStateMixin {
  Offset? pos;
  bool showIcon = false;

  late AnimationController _controller;
  final double moveTolerance = 20.0;
  Offset? initialPos;

  Timer? timer;
  int secondsPassed = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startHoldTimer() {
    secondsPassed = 0;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => secondsPassed++);

      if (secondsPassed >= 4) {
        t.cancel();
      }
    });

    _controller.forward().whenComplete(() {
      cancelAll();
      widget.onHoldComplete();
    });
  }

  Color getBgColor(String type) {
    switch (type) {
      case 'pol':
        return Colors.blue.withOpacity(0.15);
      case 'mch':
        return Colors.yellow.withOpacity(0.15);
      case 'med':
        return Colors.pink.withOpacity(0.15);
      default:
        return Colors.grey.withOpacity(0.15);
    }
  }

  void cancelAll() {
    timer?.cancel();
    _controller.reset();
    setState(() {
      showIcon = false;
      secondsPassed = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        setState(() {
          pos = details.localPosition;
          initialPos = details.localPosition;
          showIcon = true;
        });
        startHoldTimer();
      },
      onLongPressEnd: (_) => cancelAll(),
      onLongPressMoveUpdate: (details) {
        final dx = (details.localPosition.dx - initialPos!.dx).abs();
        final dy = (details.localPosition.dy - initialPos!.dy).abs();

        if (dx > moveTolerance || dy > moveTolerance) {
          cancelAll();
        }
      },
      child: Stack(
        children: [
          widget.child,

          // ---------- Fingerprint + Circle ----------
          if (showIcon && pos != null)
            Positioned(
              left: pos!.dx - 80,
              top: pos!.dy - 80,
              child: SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress circle
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return SizedBox(
                          width: 105,
                          height: 105,
                          child: CircularProgressIndicator(
                            value: _controller.value,
                            strokeWidth: 10,
                            color: getBgColor(widget.type),
                            backgroundColor: getBgColor(widget.type),
                          ),
                        );
                      },
                    ),

                    // Fingerprint icon
                    Icon(
                      Icons.fingerprint,
                      size: 80,
                      color: getBgColor(widget.type),
                    ),
                  ],
                ),
              ),
            ),

          // ----------- Bottom timer -----------
          if (showIcon)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Держи ${4 - secondsPassed} сек",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
