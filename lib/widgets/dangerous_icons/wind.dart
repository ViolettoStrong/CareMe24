import 'package:careme24/features/danger_icons/models/pressure_wind_model.dart';
import 'package:careme24/pages/dangerous/wind_info.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/dangerous_colors.dart';

class WindIcon extends StatelessWidget {
  final PressureAndWindData pressureAndWindData;
  final String city;

  const WindIcon({
    super.key,
    required this.pressureAndWindData,
    required this.city,
  });

  int getValueFromSpeed(num speed) {
    if (speed > 36) {
      return 3;
    } else if (speed > 18 && speed <= 35) {
      return 2;
    } else {
      return 1;
    }
  }

  String getIcon(int value, double direction) {
    int rounded = ((direction / 45).round() * 45) % 360;

    if (rounded < 0) rounded += 360;

    return 'assets/icons/wind/$value-$rounded.svg';
  }

  LinearGradient getColor(int value) {
    switch (value) {
      case 3:
        return DangerousColors.red;
      case 2:
        return DangerousColors.yellow;
      case 1:
        return DangerousColors.green;
      default:
        return DangerousColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final speed = pressureAndWindData.currentWindSpeed;
    final haveData = pressureAndWindData.haveData;
    String formattedSpeed = haveData ? speed.toStringAsFixed(2) : '0.00';

    return InkWell(
      onTap: pressureAndWindData.haveData
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WindInfo(
                    city: city,
                    wind: pressureAndWindData,
                  ),
                ),
              );
            }
          : null,
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0, left: 4, right: 4),
              child: Text(
                'Ветер',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.txtInterExtraBold12.copyWith(
                  fontSize: 10,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              height: 79,
              width: 79,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: haveData
                    ? getColor(getValueFromSpeed(speed))
                    : DangerousColors.grey,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SvgPicture.asset(
                        color: haveData ? null : Colors.white,
                        getIcon(
                            getValueFromSpeed(speed),
                            pressureAndWindData.currentWindDirection
                                .toDouble()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: getPadding(top: 7),
              child: Text(
                haveData ? '$formattedSpeed м/с' : 'Нет данных',
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
