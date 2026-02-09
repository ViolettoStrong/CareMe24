import 'dart:developer';

import 'package:careme24/api/api.dart';

import 'package:careme24/models/request_model.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

class NotificationsCtrl with ChangeNotifier {
  // DangerIconsCtrl dangerIconsCtrl = getIt<DangerIconsCtrl>();

  double lat = 0.0;
  double lon = 0.0;

  List<RequestModel> notifications = [];
  // List<DangerModel> dangerIcons = [];

  bool isLoading = true;
  String? error;

  Future<void> fetchNotifications({List<String>? lastActiveIcons}) async {
    error = null;
    isLoading = true;
    notifyListeners();

    // dangerIcons = dangerIconsCtrl.newMainIcons;

    Position location = await Geolocator.getCurrentPosition();
    log('${location.latitude} ${location.longitude}');
    lat = location.latitude;
    lon = location.longitude;

    try {
      final queryParams = {
        'lat': lat.toString(),
        'lon': lon.toString(),
      };
      if (lastActiveIcons != null) {
        queryParams['last_active_icons'] = lastActiveIcons.join(',');
      }
      notifications = await Api.getNotficationIcons(queryParams);
    } catch (e) {
      error = e.toString();
      debugPrint(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> closeNotification({required RequestModel e}) async {
    try {
      // final queryParams = {
      //   'lat': lat.toString(),
      //   'lon': lon.toString(),
      //   'last_active_icons':
      //       lastActiveIcons.join(','), // Join the list of strings
      // };
      if (e.is112) {
        await Api.seenContactRequest112({
          'contact_request_id': e.id,
        });
      } else {
        await Api.seenContactRequest({
          'contact_request_id': e.id,
        });
      }

      print(e.id);
      notifications.removeWhere((element) => element.id == e.id);
      notifyListeners();
      // emit(const NotificationsLoaded());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
