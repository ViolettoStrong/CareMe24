import 'dart:developer';

import 'package:careme24/blocs/application/application_cubit.dart';
import 'package:careme24/blocs/application/application_state.dart';
import 'package:careme24/blocs/auth/auth_cubit.dart';
import 'package:careme24/blocs/auth/auth_state.dart';
import 'package:careme24/blocs/dangerous/dangerous_cubit.dart';
import 'package:careme24/firebase_setup.dart';
import 'package:careme24/main.dart';
import 'package:careme24/pages/home/main_page.dart';
import 'package:careme24/pages/med/med_home_page.dart';
import 'package:careme24/pages/services_call/mes_main_page.dart';
import 'package:careme24/pages/police/police_main_page.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/custom_bottom_bar.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppContainer extends StatefulWidget {
  final int text;
  const AppContainer(this.text, {super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _bottomBarIndex = 0;
  ApplicationState? authorization;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgFrameBlue600,
      title: "Главная",
      type: BottomBarEnum.tf,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgLocationGray400,
      title: "Мед",
      type: BottomBarEnum.tf,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgFrameGray40001,
      title: "Полиция",
      type: BottomBarEnum.tf,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgFireGray40001,
      title: "МЧС",
      type: BottomBarEnum.tf,
    ),
  ];

  final List<Widget> tabs = [
    const MainPage(),
    const HoneyMainPage(),
    PoliceMainPage(),
    const MESMainPage()
  ];

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    _bottomBarIndex = widget.text;
    final appState = context.read<ApplicationCubit>().state;
    if (appState is ApplicationCompleted && appState.isAuthorized) {
      authorization = appState;
    } else {
      authorization = null;
    }

    super.initState();
    _initializeFirebase();
    FirebaseMessaging.onMessage.listen(onMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification Clicked: ${message.notification?.body}");
    });
    FirebaseSetup();
  }

  /// Значки без сигнала опасности — только бесшумный push (Туман, Гололёд, температура, ветер, солн. радиация, атм. давление).
  static const _silentDangerTypes = {
    'Сильный туман',
    'Гололёд',
    'Солнечная радиация',
    'Атмосферное давление',
    'Температура',
    'Ветер',
  };

  onMessage(RemoteMessage message) {
    final incidentType = message.data['incident_type']?.toString() ?? message.data['type']?.toString() ?? '';
    final silentPush = _silentDangerTypes.contains(incidentType);
    showNotification(
      message,
      isSiren: !silentPush && message.data.isNotEmpty,
      silent: silentPush,
    );

    if (message.data.isNotEmpty) {
      context.read<DangerousCubit>().addRequest(
            message.data,
            message.notification?.body ?? '',
          );
    }
  }

  void showNotification(RemoteMessage message, {bool isSiren = false, bool silent = false}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel Name
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      sound: silent ? null : RawResourceAndroidNotificationSound(
        isSiren ? 'alarm_meloboom' : 'alarm_sound',
      ),
      playSound: !silent,
    );

    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: silent ? null : 'alarm_sound.wav',
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      platformChannelSpecifics,
    );
  }

  Future<bool> _onWillPop() async {
    if (_bottomBarIndex != 0) {
      setState(() {
        _bottomBarIndex = 0;
      });
      return false;
    }
    return true;
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Get the FCM token
      String? token = await messaging.getToken();
      log("FCM Token: $token");
    } catch (e) {
      log("Firebase Initialization Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorConstant.bluegradient,
    ));

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: ColorConstant.whiteA700,
          body: tabs[_bottomBarIndex],
          bottomNavigationBar: SizedBox(
            height: 78.5,
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstant.whiteA700,
                boxShadow: [
                  BoxShadow(
                    color: ColorConstant.black9003f,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(
                      0,
                      -1,
                    ),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _bottomBarIndex,
                backgroundColor: Colors.transparent,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 0,
                items: List.generate(
                  bottomMenuList.length,
                  (index) {
                    return BottomNavigationBarItem(
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomImageView(
                            svgPath: bottomMenuList[index].icon,
                            height: getVerticalSize(
                              21,
                            ),
                            width: getHorizontalSize(
                              24,
                            ),
                            color: ColorConstant.gray400,
                          ),
                          Padding(
                            padding: getPadding(
                              top: 5,
                            ),
                            child: Text(
                              bottomMenuList[index].title ?? "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtMontserratSemiBold9Gray400
                                  .copyWith(
                                color: ColorConstant.gray400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      activeIcon: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomImageView(
                            svgPath: bottomMenuList[index].icon,
                            height: getSize(
                              23,
                            ),
                            width: getSize(
                              23,
                            ),
                            color: ColorConstant.blue600,
                          ),
                          Padding(
                            padding: getPadding(
                              top: 4,
                            ),
                            child: Text(
                              bottomMenuList[index].title ?? "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtMontserratSemiBold9.copyWith(
                                color: ColorConstant.blue600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      label: '',
                    );
                  },
                ),
                onTap: (index) {
                  if (index == 0) {
                    setState(() {
                      _bottomBarIndex = index;
                    });
                    return;
                  }

                  if (authorization != null) {
                    setState(() {
                      _bottomBarIndex = index;
                    });
                  } else {
                    ElegantNotification.error(
                      description: const Text(
                        'Для полноценного доступа необходимо авторизоваться',
                      ),
                    ).show(context);
                  }
                },
              ),
            ),
          ),
        ));
  }
}
