import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static String? _userId;
  static List<String>? _friendsUserIds;

  static Future<void> setUserId(String id) async {
    _userId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
  }

  static Future<String?> getUserId() async {
    if (_userId != null) return _userId;
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    return _userId;
  }

  static List<Map<String, dynamic>>? _otherCards;

  static List<String>? _otherCardIds;

  static Future<void> setOtherCards(List<String> ids) async {
    _otherCardIds = ids;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('otherCardIds', ids);
  }

  static Future<List<String>> getOtherCards() async {
    if (_otherCardIds != null) return _otherCardIds!;
    final prefs = await SharedPreferences.getInstance();
    _otherCardIds = prefs.getStringList('otherCardIds') ?? [];
    return _otherCardIds!;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('friendsUserIds');
    await prefs.remove('otherCardIds');
    _userId = null;
    _friendsUserIds = null;
    _otherCardIds = null;
    _otherCards = null;
  }
}
