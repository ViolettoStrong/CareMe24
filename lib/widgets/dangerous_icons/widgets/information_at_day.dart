import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class InfoAtDay extends StatelessWidget {
  late String date;
  late String infoText;

  InfoAtDay({
    super.key,
    required this.date,
    required this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: getMargin(bottom: 8, top: 8, left: 16, right: 16),
        width: MediaQuery.of(context).size.width - 40,
        padding: getPadding(left: 12, top: 10, right: 12, bottom: 10),
        decoration: AppDecoration.outlineBlack9003f3
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(date,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtMontserratMedium12Black900),
              Container(
                  width: 250,
                  margin: getMargin(top: 11, right: 55),
                  child: Text(infoText,
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtMontserratMedium15Black900)),
              Padding(
                  padding: getPadding(top: 7, right: 1),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Узнать больше в новостях",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtMontserratMedium15Blue600),
                        CustomImageView(
                            svgPath: ImageConstant.imgVector87Blue600,
                            height: getVerticalSize(11),
                            width: getHorizontalSize(5),
                            margin: getMargin(top: 4, bottom: 3))
                      ]))
            ]));
  }
}
