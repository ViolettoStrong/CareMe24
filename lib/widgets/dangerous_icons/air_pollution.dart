import 'package:careme24/features/danger_icons/models/air_pollution_model.dart';
import 'package:careme24/pages/dangerous/air_pollution.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/size_utils.dart';

class AirPollutionIcon extends StatelessWidget {
  final AirQualityResponse airQualityResponse;
  final String city;
  const AirPollutionIcon({
    super.key,
    required this.airQualityResponse,
    required this.city,
  });

  String getValue(int value) {
    switch (value) {
      case 1:
        return 'Низкий';
      case 2:
        return 'Средний';
      case 3:
        return 'Повышенный';
      case 4:
        return 'Высокий';
      case 5:
        return 'Очень высокий';
    }
    return 'Нет данных';
  }

  String getIcon(int value) {
    switch (value) {
      case 1:
        return 'assets/icons/air_pollution/1.svg';
      case 2:
        return 'assets/icons/air_pollution/2.svg';
      case 3:
        return 'assets/icons/air_pollution/3.svg';
      case 4:
        return 'assets/icons/air_pollution/4.svg';
      case 5:
        return 'assets/icons/air_pollution/5.svg';
    }
    return 'assets/icons/air_pollution/1.svg';
  }

  LinearGradient getColor(int value) {
    switch (value) {
      case 1:
        return DangerousColors.green;
      case 2:
        return DangerousColors.yellow;
      case 3:
        return DangerousColors.darkYellow;
      case 4:
        return DangerousColors.red;
      case 5:
        return DangerousColors.darkRed;
    }
    return DangerousColors.grey;
  }

  @override
  Widget build(BuildContext context) {
    int aqi = 0;
    if (airQualityResponse.list.isNotEmpty) {
      aqi = airQualityResponse.list.first.aqi;
    }
    bool haveData = airQualityResponse.haveData;
    return InkWell(
      onTap: airQualityResponse.list.isNotEmpty
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AirPollutionInfo(
                    city: city,
                    airQuality: airQualityResponse.list[0],
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
                'Чистота возд.',
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
                    gradient: haveData ? getColor(aqi) : DangerousColors.grey),
                child: SvgPicture.asset(
                  getIcon(aqi),
                  color: haveData ? null : Colors.white,
                )),
            Padding(
                padding: getPadding(top: 7),
                child: Text(haveData ? getValue(aqi) : 'Нет данных',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratF14W600Gray2))
          ],
        ),
      ),
    );
  }
}
