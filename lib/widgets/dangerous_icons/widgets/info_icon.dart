import 'package:careme24/features/danger_icons/domain/danger_icon_props_usecase.dart';
import 'package:careme24/features/danger_icons/models/danger_model.dart';
import 'package:careme24/pages/dangerous/dang_info_screen.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/size_utils.dart';

class InfoIcon extends StatelessWidget {
  final DangerModel icon;
  final String city;

  const InfoIcon({
    super.key,
    required this.icon,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DangerInfoScreen(
              model: icon,
              city: city,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                icon.incidentType == "Чистота воздуха"
                    ? "Чист.воздух"
                    : icon.incidentType == "Атмосферное давление"
                        ? "Атм.давление"
                        : icon.incidentType == "Солнечная радиация"
                            ? "Солн.радиация"
                            : icon.incidentType == "Радиактивный фон"
                                ? "Радиоактивность"
                                : icon.incidentType ==
                                        "Электромагнитное излучение"
                                    ? "Эл.магн.изл."
                                    : icon.incidentType == "Пожар"
                                        ? "Пожар"
                                        : icon.incidentType == "Наводнение"
                                            ? "Наводнение"
                                            : icon.incidentType ==
                                                    "Торнадо смерч"
                                                ? "Торнадо"
                                                : icon.incidentType ==
                                                        "Землятрясение"
                                                    ? "Землятрясение"
                                                    : icon.incidentType ==
                                                            "Террористическая опасность"
                                                        ? "Терр.опасность"
                                                        : icon.incidentType ==
                                                                "Воздушная тревога"
                                                            ? "Возд.тревога"
                                                            : icon.incidentType ==
                                                                    "Химическое заражение"
                                                                ? "Хим.заражение"
                                                                : icon.incidentType ==
                                                                        "Вирусное / бактериологическое заражение"
                                                                    ? "Вирус. заражение"
                                                                    : icon.incidentType ==
                                                                            "Аллерген"
                                                                        ? "Аллерген"
                                                                        : icon.incidentType ==
                                                                                "Цунами"
                                                                            ? "Цунами"
                                                                            : icon.incidentType == "Извержение вулкана"
                                                                                ? "Изв. вулкана"
                                                                                : icon.incidentType == "Крупный град"
                                                                                    ? "Град"
                                                                                    : icon.incidentType == "Гололёд"
                                                                                        ? "Гололёд"
                                                                                        : icon.incidentType == "Снежная лавина"
                                                                                            ? "Лавина"
                                                                                            : icon.incidentType == "Сильный туман"
                                                                                                ? "Туман"
                                                                                                : icon.incidentType == "Камнепад / Оползень"
                                                                                                    ? "Камнепад"
                                                                                                    : "",
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: icon.isActive
                      ? getGradient(icon.dangerLevel)
                      : icon.dangerLevel == 'Не активно'
                          ? DangerousColors.grey
                          : icon.dangerLevel == 'В норме'
                              ? DangerousColors.green
                              : icon.dangerLevel == 'Повышенный'
                                  ? DangerousColors.red
                                  : icon.dangerLevel == 'Опасный'
                                      ? DangerousColors.yellow
                                      : DangerousColors.darkgrey),
              child: SvgPicture.asset(
                getIcon(icon.incidentType),
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Padding(
              padding: getPadding(top: 7),
              child: Text(
                icon.dangerLevel,
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

//  icon. incidentType  ==  'Гололёд' ?  Column(
//               children: [
// Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('02.01.2023', style: TextStyle(color: Colors.grey)),
//                   const SizedBox(height: 4),
//                   const Text(
//                     'Гололедица ожидается на столичных дорогах ночью',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 4),
//                   TextButton(
//                     onPressed: () {},
//                     child: const Text(
//                       'Узнать больше в новостях',
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text('Прогноз', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(5, (index) {
//                 return Column(
//                   children: const [
//                     Text('-25.7°', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     Text('16:00', style: TextStyle(fontSize: 14, color: Colors.grey)),
//                   ],
//                 );
//               }),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(5, (index) {
//                 return Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     children: const [
//                       Icon(Icons.arrow_upward, color: Colors.blue),
//                       Text('C 0.99', style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Скорость ветра м/с              максимум сегодня 0.99 м/с',
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(3, (index) {
//                 return Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: index == 0 ? Colors.blue : Colors.grey.shade300),
//                     color: index == 0 ? Colors.blue.shade50 : Colors.white,
//                   ),
//                   child: const Column(
//                     children: [
//                       Text('ПН', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                       Text('+25.7 / +30.8', style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   side: const BorderSide(color: Colors.blue),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: () {},
//               child: const Text('Рекомендации', style: TextStyle(fontSize: 18, color: Colors.blue)),
//             ),
//               ],
//             ) : Container()
