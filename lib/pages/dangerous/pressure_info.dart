import 'package:careme24/features/danger_icons/models/pressure_wind_model.dart';
import 'package:careme24/pages/dangerous/recomendation_page.dart';
import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:careme24/widgets/info/info_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PressureInfo extends StatelessWidget {
  const PressureInfo({
    super.key,
    required this.city,
    required this.pressure,
  });

  final String city;
  final PressureAndWindData pressure;

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
                        gradient: getColor(
                            getValue(pressure.currentPressure.toInt()))),
                    child: SvgPicture.asset(
                        getIcon(getValue(pressure.currentPressure.toInt())))),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Атмосферное\nдавление',
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
                        gradient: getColor(
                            getValue(pressure.currentPressure.toInt())),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 8),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        getPressureDescription(
                            getValue(pressure.currentPressure.toInt())),
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
                    const Text('Миллибары',
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
                    Text('${pressure.currentPressure}',
                        style: const TextStyle(
                            color: Color.fromRGBO(51, 132, 226, 1),
                            fontSize: 32,
                            fontWeight: FontWeight.w600)),
                    const Text('мбар',
                        style: TextStyle(
                            color: Color.fromRGBO(51, 132, 226, 1),
                            fontSize: 32,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
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
                          ...List.generate(pressure.date.length, (index) {
                            return InfoLabel(
                                date: DateFormat("MM dd HH:mm").format(
                                    DateTime.parse(pressure.date[index])),
                                value: pressure.pressureList[index].toString());
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
                                        imagePath: 'assets/rec/people.svg',
                                        text:
                                            'Повысить активность сердечно-сосудистой системы за счет физических упражнений и нагрузок.'),
                                    Recomendation(
                                        imagePath: 'assets/rec/moon.svg',
                                        text:
                                            'Надо хорошо выспаться, спать достаточное количество часов'),
                                    Recomendation(
                                        imagePath: 'assets/rec/tea.svg',
                                        text:
                                            'Не злоупотреблять крепкими напитками'),
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

String getPressureDescription(int value) {
  switch (value) {
    case 5:
      return "Низкое";
    case 4:
      return "Пониженное";
    case 3:
      return "В норме";
    case 2:
      return 'Повышенное';
    case 1:
      return 'Высокое';
    default:
      return "";
  }
}
