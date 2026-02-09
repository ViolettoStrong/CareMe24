import 'package:careme24/features/danger_icons/controller/danger_icons_ctrl.dart';
import 'package:careme24/features/notifications/notifications_ctrl.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupLocator() async {
  getIt.registerSingleton(DangerIconsCtrl());
  getIt.registerSingleton(NotificationsCtrl());
}
