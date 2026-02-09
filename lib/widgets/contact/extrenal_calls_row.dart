import 'dart:developer';
import 'package:careme24/service/pref_service.dart';
import 'package:careme24/widgets/paid_service_switcher_notif.dart';
import 'package:careme24/widgets/paid_service_swither.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtrenalCallsWidget extends StatelessWidget {
  const ExtrenalCallsWidget({
    super.key,
    required this.fromMe,
  });

  final bool fromMe;
  Future<Map<String, bool>> _getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final notifToMe = prefs.getBool('pay_switch_value_notif_tome') ?? false;
    final notifMe = prefs.getBool('pay_switch_value_notif_me') ?? false;

    return {
      'toMe': notifToMe,
      'me': notifMe,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
      future: _getNotificationSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final notifToMe = snapshot.data?['toMe'] ?? false;
        final notifMe = snapshot.data?['me'] ?? false;

        return Container(
          margin: const EdgeInsets.only(top: 14),
          padding: const EdgeInsets.all(18),
          color: Colors.white,
          child: Row(
            children: [
              Image.asset('assets/images/Frame 8002.png'),
              Container(
                height: 57,
                width: 57,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xff92a3ff),
                ),
                child: Image.asset('assets/images/Frame.png'),
              ),
              SvgPicture.asset('assets/icons/mch.svg'),
              const Spacer(),
              fromMe
                  ? PaySwitcherNotiftoMe(
                      onChanged: (value) async {
                        log('$value');
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool(
                            'pay_switch_value_notif_tome', value);
                      },
                      on: notifToMe,
                    )
                  : PaySwitcherNotifMe(
                      onChanged: (value) async {
                        log('$value');
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('pay_switch_value_notif_me', value);
                        PrefService.setNotifContact(value);
                      },
                      on: notifMe,
                    ),
            ],
          ),
        );
      },
    );
  }
}
