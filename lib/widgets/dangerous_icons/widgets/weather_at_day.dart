import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';

class WheatherAtDay extends StatelessWidget {
  late String day;
  late String? minTemperature;
  late String? maxTemperature;
  late bool isToday;

  WheatherAtDay({
    super.key,
    required this.day,
    this.minTemperature,
    this.maxTemperature,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(right: 16),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        elevation: 2,
        child: Container(
          width: 96,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            border: isToday
                ? Border(
                    bottom: BorderSide(color: ColorConstant.blue600, width: 0),
                    right: BorderSide(color: ColorConstant.blue600, width: 0),
                    left: BorderSide(color: ColorConstant.blue600, width: 0),
                    top: BorderSide(color: ColorConstant.blue600, width: 4))
                : null,
            //      borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: getPadding(
                  top: 10,
                ),
                child: Text(
                  day,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtMontserratSemiBold15Bluegray800,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    minTemperature ?? '-' " / ",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratRegular12Gray50001,
                  ),
                  Text(
                    maxTemperature ?? '-',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratRegular12Gray50001,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
