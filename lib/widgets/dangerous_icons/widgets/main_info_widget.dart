import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';

class MainInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        margin: getMargin(bottom: 8, top: 16, left: 16, right: 16),
        padding: getPadding(left: 12, top: 19, right: 12, bottom: 19),
        decoration: AppDecoration.outlineBlack9003f3
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Градусы",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratMedium15Bluegray800),
                Text("Москва",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratSemiBold18)
              ]),
          Text("+25,7°",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtMontserratRomanSemiBold32)
        ]));
  }
}
