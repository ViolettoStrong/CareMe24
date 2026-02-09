import 'package:careme24/features/danger_icons/models/weather_forecast_model.dart';
import 'package:careme24/pages/dangerous/recomendation_page.dart';
import 'package:careme24/widgets/info/info_label.dart';
import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TempInfo extends StatelessWidget {
  const TempInfo(
      {super.key,
      required this.city,
      required this.temp,
      required this.forecast});

  final String city;
  final WeatherForecast forecast;
  final int temp;

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
      body: Column(
        children: [
          Container(
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
                        gradient: getColor(getValue(temp))),
                    child: SvgPicture.asset(getIcon(getValue(temp)))),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Температура',
                      style: AppStyle.txtMontserratBold18,
                    ),
                    Text(city,
                        style: const TextStyle(
                            color: Color.fromRGBO(51, 132, 226, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    Container(
                      margin: const EdgeInsets.only(top: 9),
                      decoration: BoxDecoration(
                        gradient: getColor(getValue(temp)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 8),
                      child: Text(
                        getTemperatureDescription(temp),
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
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26.5),
            margin:
                const EdgeInsets.only(top: 18, bottom: 18, left: 23, right: 23),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Градусы',
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
                Text('$temp°',
                    style: const TextStyle(
                        color: Color.fromRGBO(51, 132, 226, 1),
                        fontSize: 32,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Visibility(
            visible: true,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration:
                    AppDecoration.outlineGray3004.copyWith(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Прогноз",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtH1),
                    const SizedBox(
                      height: 18,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate(forecast.forecast.length, (index) {
                            return InfoLabel(
                                date: DateFormat("MM dd HH:mm")
                                    .format(DateTime.parse(
                                        forecast.forecast[index].dateTime))
                                    .toString(),
                                value:
                                    '${forecast.forecast[index].temperature.toInt().toString()}°');
                          })
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Align(
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
                                        imagePath: 'assets/rec/tshirt.svg',
                                        text:
                                            'В жаркие дни носить легкую, свободную одежду из натуральных тканей свободного кроя'),
                                    Recomendation(
                                        imagePath: 'assets/rec/cap.svg',
                                        text: 'Надевать легкие головные уборы'),
                                    Recomendation(
                                        imagePath: 'assets/rec/wather.svg',
                                        text:
                                            'Необходимо больше пить – не менее 1,5 – 3 литров в день'),
                                    Recomendation(
                                        imagePath: 'assets/rec/shower.svg',
                                        text:
                                            'По возможности чаще принимайте водные процедуры')
                                  ],
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 23, vertical: 30),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color.fromRGBO(65, 73, 255, 1))),
                    child: Center(
                      child: Text(
                        'Рекомендации',
                        style: AppStyle.txtMontserratf18w600.copyWith(
                            color: const Color.fromRGBO(51, 132, 226, 1)),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

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

String getTemperatureDescription(num value) {
  if (value >= 25) {
    return "Очень горячо";
  } else if (value >= 5 && value < 25) {
    return "Тепло"; // Тепло
  } else if (value >= -10 && value <= 4) {
    return "Прохладно";
  } else if (value >= -25 && value <= -11) {
    return "Холодно"; // Умеренно тепло
  } else if (value <= -26) {
    return "Очень холодно";
  } else {
    return '';
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
