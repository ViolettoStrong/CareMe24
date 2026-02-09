import 'package:careme24/injection_container.dart';
import 'package:get_it/get_it.dart';
import 'features/danger_icons/controller/danger_icons_ctrl.dart';

Future<void> init() async {
  if (!getIt.isRegistered<DangerIconsCtrl>()) {
    getIt.registerLazySingleton<DangerIconsCtrl>(
      () => DangerIconsCtrl(),
    );
  }
}
