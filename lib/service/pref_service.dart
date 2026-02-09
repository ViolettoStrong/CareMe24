import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static String notifContact = 'notif_contact';
  static String notifMe = 'notif_me';

  static Future<bool> isNotifContact() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isNotifContact = preferences.getBool(notifContact) ?? false;
    return isNotifContact;
  }

  static Future<bool> isNotifMe() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isNotifContact = preferences.getBool(notifMe) ?? false;
    return isNotifContact;
  }

  static Future setNotifContact(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(notifContact, value);
    log('cont');
  }

  static Future setNotifMe(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(notifMe, value);
    log('me');
  }

  static Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(notifContact);
    await prefs.remove(notifMe);
  }
}
