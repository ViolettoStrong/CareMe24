import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';

class InfoAboutVirus extends StatelessWidget {
  const InfoAboutVirus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: getMargin(bottom: 16, top: 12),
            width: MediaQuery.of(context).size.width - 40,
            child: Text("COVID-19 (Коронавирусная инфекция ",
                maxLines: null,
                textAlign: TextAlign.left,
                style: AppStyle.txtMontserratMedium18Black900)),
        Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              width: MediaQuery.of(context).size.width - 40,
              margin: getMargin(bottom: 16),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: getPadding(top: 12, left: 12),
                      child: Row(
                        children: [
                          Text(
                            "Данные на ",
                            textAlign: TextAlign.start,
                            style: AppStyle.txtMontserratMedium15Black900,
                          ),
                          Text(
                            "2 января",
                            textAlign: TextAlign.start,
                            style: AppStyle.txtMontserratMedium15Blue600,
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1),
                    Padding(
                        padding: getPadding(
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Случаев выявлено",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtMontserratMedium12Black900),
                                    Container(
                                        width: 93,
                                        margin: getMargin(top: 6),
                                        padding: getPadding(top: 4, bottom: 4),
                                        decoration: AppDecoration
                                            .txtOutlineBlue30001
                                            .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .txtRoundedBorder10),
                                        child: Text("3 332 707",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: AppStyle
                                                .txtMontserratMedium15Blue600))
                                  ]),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Выздоровили",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtMontserratMedium12Black900),
                                    Container(
                                        width: 93,
                                        margin: getMargin(top: 6),
                                        padding: getPadding(top: 4, bottom: 4),
                                        decoration: AppDecoration
                                            .txtOutlineBlue30001
                                            .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .txtRoundedBorder10),
                                        child: Text("3 136 551",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: AppStyle
                                                .txtMontserratMedium15Blue600))
                                  ]),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Скончалось",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtMontserratMedium12Black900),
                                    Container(
                                        width: 93,
                                        margin: getMargin(top: 6),
                                        padding: getPadding(top: 4, bottom: 4),
                                        decoration: AppDecoration
                                            .txtOutlineBlue30001
                                            .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .txtRoundedBorder10),
                                        child: Text("47 809",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: AppStyle
                                                .txtMontserratMedium15Blue600))
                                  ])
                            ]))
                  ])),
        )
      ],
    );
  }
}
