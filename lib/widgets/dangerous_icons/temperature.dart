import 'package:careme24/features/danger_icons/models/weather_forecast_model.dart';
import 'package:careme24/pages/dangerous/temp_info.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/size_utils.dart';

class TemperatureIcon extends StatelessWidget {
  final WeatherForecast weatherForecast;
  final String city;

  const TemperatureIcon({
    super.key,
    required this.weatherForecast,
    required this.city,
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
        return DangerousColors.blue;
      case 2:
        return DangerousColors.green;
      case 3:
        return DangerousColors.yellow;
      case 4:
        return DangerousColors.blueMedium;
      case 5:
        return DangerousColors.darkBlue;
    }
    return DangerousColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    int temp = weatherForecast.currentTemperature.toInt();
    return InkWell(
      onTap: weatherForecast.haveData
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TempInfo(
                    temp: weatherForecast.currentTemperature.toInt(),
                    city: city,
                    forecast: weatherForecast,
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
              padding: const EdgeInsets.only(bottom: 4.0, left: 4, right: 4),
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
                  gradient: weatherForecast.haveData
                      ? getColor(getValue(temp))
                      : DangerousColors.grey),
              child: SvgPicture.asset(
                getIcon(getValue(temp)),
                // color: weatherForecast.haveData ? null : Colors.white,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Padding(
              padding: getPadding(top: 7),
              child: Text(
                weatherForecast.haveData ? '$temp°' : 'Нет данных',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtMontserratF14W600Gray2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
