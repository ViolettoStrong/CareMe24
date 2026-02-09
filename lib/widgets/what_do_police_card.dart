import 'package:careme24/pages/services_call/call_police.dart';
import 'package:careme24/pages/police/police_recomendation.dart';
import 'package:flutter/material.dart';
import '../pages/mes/mes_call.dart';
import '../theme/app_style.dart';
import '../utils/size_utils.dart';
import '../widgets/custom_image_view.dart';

class WhatDoPoliceCard extends StatelessWidget {
  late Color color_icon;
  late String icon_path;
  late String action_text;

  WhatDoPoliceCard({
    super.key,
    required this.color_icon,
    required this.icon_path,
    required this.action_text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (action_text == "Рекомендации") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PoliceRecomendation()));
            } else if (action_text == 'Юрист онлайн') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallMESScreen(action_text, 'pol')));
            } else if (action_text == 'Заявление') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallPoliceScreen(
                            appbartitle: action_text,
                            isStatament:
                                true, // CreateStatementScreen(reason: 'pol',)
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallPoliceScreen(
                            appbartitle: action_text,
                          )));
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
          )),
    );
  }
}
