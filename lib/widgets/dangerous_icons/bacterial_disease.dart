import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/size_utils.dart';

class BacterialDiseaseIcon extends StatelessWidget {
  final int temp;
  final bool haveData;
  final VoidCallback onTap;

  const BacterialDiseaseIcon({
    super.key,
    required this.onTap,
    required this.haveData,
    required this.temp,
  });

  int getValue(int value) {
    if (value >= 25) {
      return 3;
    } else if (value >= 5 && value < 25) {
      return 2; // Средне высокая температура
    } else if (value >= -10 && value <= 4) {
      return 1; // Средняя температура
    } else if (value >= -25 && value <= -11) {
      return 4; // Низкая температура
    } else if (value <= -26) {
      return 5; // Низкая температура
    } else {
      return 0;
    }
  }

  String getIcon(int value) {
    switch (value) {
      case 1:
        return 'assets/icons/temperature/1.svg';
      case 2:
        return 'assets/icons/temperature/2.svg';
      case 3:
        return 'assets/icons/temperature/3.svg';
      case 4:
        return 'assets/icons/temperature/4.svg';
      case 5:
        return 'assets/icons/temperature/5.svg';
    }
    return 'Нет данных';
  }

  LinearGradient getColor(int value) {
    switch (value) {
      case 1:
        return DangerousColors.green;
      case 2:
        return DangerousColors.yellow;
      case 3:
        return DangerousColors.red;
      case 4:
        return DangerousColors.blue;
      case 5:
        return DangerousColors.darkBlue;
    }
    return DangerousColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 4.0, left: 4, right: 4),
                  child: Text('Температура',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.txtInterExtraBold12.copyWith(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                ),
                Container(
                    height: 79,
                    width: 79,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: haveData
                            ? getColor(getValue(temp))
                            : DangerousColors.grey),
                    child: SvgPicture.asset(
                      getIcon(getValue(temp)),
                      color: haveData ? null : Colors.white,
                    )),
                Padding(
                    padding: getPadding(top: 7),
                    child: Text(haveData ? '$temp°' : 'Нет данных',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtMontserratF14W600Gray2))
              ],
            ),
          ),
        ));
  }
}
