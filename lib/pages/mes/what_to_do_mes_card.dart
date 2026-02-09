import 'package:careme24/pages/mes/mes_call.dart';
import 'package:careme24/pages/mes/mes_recomendation.dart';
import 'package:careme24/pages/services_call/select_mes_screen.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class WhatDoMESCard extends StatelessWidget {
  final Color color_icon;
  final String icon_path;
  final String action_text;

  const WhatDoMESCard({
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
                      builder: (context) => const MESRecomendation()));
            } else if (action_text == 'Заявление') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectMesScreen(
                      appbartitle: 'МЧС',
                      isStatament: true,
                    ), //CreateStatementScreen(reason: 'med', serviceId: ,)
                  ));
            } else if (action_text == 'Сообщить') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectMesScreen(
                            appbartitle: 'МЧС',
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallMESScreen(action_text, 'mch')));
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
