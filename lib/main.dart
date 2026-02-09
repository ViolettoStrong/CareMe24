import 'package:alarm/alarm.dart';
import 'package:careme24/app.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/firebase_options.dart';
import 'package:careme24/injection_container.dart';
import 'package:careme24/service/env_service.dart';
import 'package:careme24/widgets/no_internet_overlay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/timezone.dart' as tz;

GlobalKey<NavigatorState> navigatorKey = GlobalKey();
// Notification Plugin Instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background Message Handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
}

void showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel', // Channel ID
    'High Importance Notifications', // Channel Name
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.high,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound(
        'alarm_sound'), // Custom MP3 for Android
    playSound: true,
  );

  const DarwinNotificationDetails iOSPlatformChannelSpecifics =
      DarwinNotificationDetails(
    sound: 'alarm_sound.wav', // Custom MP3/WAV for iOS (must be in "Resources")
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const AndroidNotificationChannel dangerChannel = AndroidNotificationChannel(
    'danger_ws', // 👈
    'CareMe24 Service Channel',
    description: 'Channel for background WebSocket service',
    importance: Importance.high,
    //sound: RawResourceAndroidNotificationSound('alarm_sound')
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(dangerChannel);
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(message);
  });
  String? token = await FirebaseMessaging.instance.getToken();
  final prefs = await SharedPreferences.getInstance();
  final notifToMe = prefs.getBool('pay_switch_value_notif_tome') ?? false;
  final notifMe = prefs.getBool('pay_switch_value_notif_me') ?? false;
  await prefs.setBool(
    'pay_switch_value_notif_tome',
    notifToMe,
  );

  await prefs.setBool(
    'pay_switch_value_notif_me',
    notifMe,
  );
  VersionConstant.free = prefs.getBool('pay_switch_value') ?? false;
  //prefs.getBool('pay_switch_value_notif_tome')??false;
  // iOS Notification Permission
  FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Initialize Notification Settings
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true, // Ask for alert permission
    requestSoundPermission: true, // Ask for sound permission
    requestBadgePermission: true, // Ask for badge permission
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveNotificationResponse: notificationTapForeground,
    // onDidReceiveBackgroundNotificationResponse: notificationTapBg,
  );

  await initializeDateFormatting('ru', null);
  await Alarm.init();
  Intl.defaultLocale = 'ru';
  await EnvService().loadEnv();

  FlutterNativeSplash.remove();
  runApp(const App());
}

//// web run
/*void main() async {
  await EnvService().loadEnv();
  runApp( const App());
}*/

// @pragma('vm:entry-point')
// notificationTapForeground(NotificationResponse details) async {
//   Navigator.of(navigatorKey.currentContext!)
//       .pushNamed(AppRouter.monthDaySelector);
// }

// @pragma('vm:entry-point')
// notificationTapBg(NotificationResponse details) async {}

void mainForWeb() {
  runApp(const App());
}
