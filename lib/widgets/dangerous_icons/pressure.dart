import 'package:careme24/features/danger_icons/models/pressure_wind_model.dart';
import 'package:careme24/pages/dangerous/pressure_info.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/size_utils.dart';

class PressureIcon extends StatelessWidget {
  final PressureAndWindData pressureAndWindData;
  final String city;

  const PressureIcon({
    super.key,
    required this.pressureAndWindData,
    required this.city,
  });

  int getValue(int pressure) {
    if (pressure >= 1040) {
      return 1; // Высокое давление
    } else if (pressure >= 1020 && pressure < 1040) {
      return 2; // Немного высокое давление
    } else if (pressure >= 1000 && pressure < 1020) {
      return 3; // Нормальное давление
    } else if (pressure >= 950 && pressure < 1000) {
      return 4; // Низкое давление
    } else {
      return 5; // Очень низкое давление
    }
  }

  String getIcon(int value) {
    switch (value) {
      case 5:
        return 'assets/icons/pressure/1.svg';
      case 4:
        return 'assets/icons/pressure/2.svg';
      case 3:
        return 'assets/icons/pressure/3.svg';
      case 2:
        return 'assets/icons/pressure/4.svg';
      case 1:
        return 'assets/icons/pressure/5.svg';
    }
    return '';
  }

  LinearGradient getColor(int value) {
    switch (value) {
      case 1:
        return DangerousColors.red;
      case 2:
        return DangerousColors.yellow;
      case 3:
        return DangerousColors.green;
      case 4:
        return DangerousColors.yellow;
      case 5:
        return DangerousColors.red;
    }
    return DangerousColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final haveData = pressureAndWindData.haveData;
    final pressure = pressureAndWindData.currentPressure.toInt();
    return InkWell(
      onTap: pressureAndWindData.haveData
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PressureInfo(
                    city: city,
                    pressure: pressureAndWindData,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                'Атм. давление',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.txtInterExtraBold12.copyWith(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
                height: 79,
                width: 79,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: haveData
                        ? getColor(getValue(pressure.toInt()))
                        : DangerousColors.grey),
                child: SvgPicture.asset(
                    color: haveData ? null : Colors.white,
                    getIcon(getValue(pressure.toInt())))),
            Padding(
              padding: getPadding(top: 7),
              child: Text(
                haveData ? '$pressure мбар' : 'Нет данных',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtMontserratF14W600Gray2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
