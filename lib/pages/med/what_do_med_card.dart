// ignore_for_file: non_constant_identifier_names

import 'package:careme24/pages/services_call/select_doctor.dart';
import 'package:careme24/pages/med/self_help_screen.dart';
import 'package:careme24/pages/mes/mes_call.dart';
import 'package:careme24/pages/police/police_recomendation.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class WhatDoMedCard extends StatelessWidget {
  final Color color_icon;
  final String icon_path;
  final String action_text;

  const WhatDoMedCard({
    super.key,
    required this.color_icon,
    required this.icon_path,
    required this.action_text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (action_text == "Самопомощь") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SelfHelpScreen()));
        } else if (action_text == "Рекомендации") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PoliceRecomendation()));
        } else if (action_text == 'Помощь онлайн') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CallMESScreen(action_text, 'med')));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectDoctorScreen(action_text)));
        }
      },
      child: Card(
        margin: getMargin(bottom: 24),
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(2),
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          height: 80,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(2),
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2)),
          ),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 96,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(44),
                        bottomLeft: Radius.circular(2),
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2)),
                    color: color_icon),
                child: Stack(alignment: Alignment.center, children: [
                  CustomImageView(
                    svgPath: icon_path,
                  ),
                ]),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      action_text,
                      style: AppStyle.txtMontserratSemiBold18Black900,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
