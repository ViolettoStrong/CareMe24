import 'package:careme24/features/danger_icons/models/air_pollution_model.dart';
import 'package:careme24/pages/dangerous/recomendation_page.dart';
import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AirPollutionInfo extends StatelessWidget {
  const AirPollutionInfo({
    super.key,
    required this.city,
    required this.airQuality,
  });

  final String city;
  final AirQuality airQuality;

  final num maxValueCO = 1000; // Угарный газ (CO)
  final num maxValueNO = 200; // Оксид азота (NO)
  final num maxValueNH3 = 2000; // Аммиак (NH3)

  final num maxValuePM10 = 100.0; // Частицы (PM10)
  final num maxValuePM25 = 71.0; // Тонкие частицы (PM2.5)
  final num maxValueSO2 = 1065.0; // Диоксид серы (SO2)
  final num maxValueNO2 = 600.0; // Диоксид азота (NO2)
  final num maxValueO3 = 240.0; // Озон (O3)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 43,
        centerTitle: true,
        title: const Text(
          "Фактор опасности",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAirQualityHeader(),
            _buildAirQualityData(),
            _buildPollutionCharacteristics(),
            _buildRecommendationsButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAirQualityHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Row(
        children: [
          Container(
            height: 79,
            width: 79,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: getColor(airQuality.aqi),
            ),
            child: SvgPicture.asset(getIcon(airQuality.aqi)),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Чистота воздуха', style: AppStyle.txtMontserratBold18),
              Text(
                city,
                style: const TextStyle(
                    color: Color.fromRGBO(51, 132, 226, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.only(top: 9),
                decoration: BoxDecoration(
                  gradient: getColor(airQuality.aqi),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                child: Text(
                  getDescription(airQuality.aqi),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAirQualityData() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26.5),
      margin: const EdgeInsets.only(top: 18, bottom: 18, left: 23, right: 23),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Оксид углерода (СO)',
                  style: TextStyle(
                      color: Color.fromRGBO(44, 62, 79, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
              Text(city,
                  style: const TextStyle(
                      color: Color.fromRGBO(51, 132, 226, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Column(
            children: [
              Text('${airQuality.components.co}',
                  style: const TextStyle(
                      color: Color.fromRGBO(51, 132, 226, 1),
                      fontSize: 32,
                      fontWeight: FontWeight.w600)),
              const Text('мкг/м³',
                  style: TextStyle(
                      color: Color.fromRGBO(51, 132, 226, 1),
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPollutionCharacteristics() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: AppDecoration.outlineGray3004.copyWith(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Характеристики",
            style: AppStyle.txtH1,
          ),
          const SizedBox(height: 18),
          _buildPollutionTableHeader(),
          const SizedBox(height: 12),
          _buildPollutionBars(),
        ],
      ),
    );
  }

  Widget _buildPollutionTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Загрязнитель',
            style: AppStyle.txtMontserratBold14.copyWith(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        Text('Концентрация',
            style: AppStyle.txtMontserratBold14.copyWith(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        Text('%',
            style: AppStyle.txtMontserratBold14.copyWith(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPollutionBars() {
    return Column(
      children: [
        PollutionProgressBar(
          name: 'оксид углерода (CO)',
          value: airQuality.components.co.toDouble(),
          maxValue: maxValueCO,
        ),
        PollutionProgressBar(
          name: 'оксид азота (NO)',
          value: airQuality.components.no.toDouble(),
          maxValue: maxValueNO,
        ),
        PollutionProgressBar(
          name: 'диоксид азота (NO2)',
          value: airQuality.components.no2.toDouble(),
          maxValue: maxValueNO2,
        ),
        PollutionProgressBar(
          name: "озон (O3)",
          value: airQuality.components.o3.toDouble(),
          maxValue: maxValueO3,
        ),
        PollutionProgressBar(
          name: "диоксид серы (SO2)",
          value: airQuality.components.so2.toDouble(),
          maxValue: maxValueSO2,
        ),
        PollutionProgressBar(
          name: 'тонкие частицы (PM2.5)',
          value: airQuality.components.pm2_5.toDouble(),
          maxValue: maxValuePM25,
        ),
        PollutionProgressBar(
          name: 'твердые частицы (PM10)',
          value: airQuality.components.pm10.toDouble(),
          maxValue: maxValuePM10,
        ),
        PollutionProgressBar(
          name: "аммиак (NH3)",
          value: airQuality.components.nh3.toDouble(),
          maxValue: maxValueNH3,
        ),
      ],
    );
  }

  Widget _buildRecommendationsButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecomendationPage(
                    recomendations: [
                      Recomendation(
                          imagePath: 'assets/rec/mask.svg',
                          text: 'Носите маску на улице'),
                      Recomendation(
                          imagePath: 'assets/rec/window.svg',
                          text:
                              'Закройте окна, чтобы избежать загрязнения наружным воздухом'),
                      Recomendation(
                          imagePath: 'assets/rec/airClinner.svg',
                          text: 'Включите очиститель воздуха'),
                      Recomendation(
                          imagePath: 'assets/rec/apple.svg',
                          text: 'Избегайте нагрузок на улице'),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 30),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color.fromRGBO(65, 73, 255, 1)),
              ),
              child: Center(
                child: Text(
                  'Рекомендации',
                  style: AppStyle.txtMontserratf18w600
                      .copyWith(color: const Color.fromRGBO(51, 132, 226, 1)),
                ),
              ),
            ),
          )),
    );
  }
}

String getDescription(int value) {
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
  return 'Нет данных';
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

class PollutionProgressBar extends StatelessWidget {
  final String name;
  final double value;
  final num maxValue;

  const PollutionProgressBar({
    super.key,
    required this.name,
    required this.value,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    double progressValue = value / maxValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(30),
                  value: progressValue,
                  minHeight: 20,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      getPollutionColor(progressValue * 100)),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: AppStyle.txtMontserratBold14.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      "${value.toStringAsFixed(1)} мкг/м³",
                      style: AppStyle.txtMontserratBold14.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 17),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(214, 218, 220, 1),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              '${(progressValue * 100).toInt()}%',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  int getPollutionLevel(double value, List<num> thresholds) {
    for (int i = 0; i < thresholds.length; i++) {
      if (value < thresholds[i]) {
        return i + 1; // Уровень начинается с 1
      }
    }
    return thresholds.length;
  }

  Color getPollutionColor(double pollutionPercentage) {
    if (pollutionPercentage < 2) {
      return Colors.green; // Хороший уровень (0% - 20%)
    } else if (pollutionPercentage < 40) {
      return Color.lerp(
          Colors.green,
          Colors.yellow,
          (pollutionPercentage - 20) /
              20)!; // Переход от зеленого к желтому (20% - 40%)
    } else if (pollutionPercentage < 60) {
      return Color.lerp(
          Colors.yellow,
          Colors.orange,
          (pollutionPercentage - 40) /
              20)!; // Переход от желтого к оранжевому (40% - 60%)
    } else if (pollutionPercentage < 80) {
      return Color.lerp(
          Colors.orange,
          Colors.red,
          (pollutionPercentage - 60) /
              20)!; // Переход от оранжевого к красному (60% - 80%)
    } else {
      return Colors.red; // Очень плохой уровень (80% - 100%)
    }
  }
}
