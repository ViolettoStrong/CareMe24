import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/widgets/reason_mes.dart';
import 'package:flutter/material.dart';

class SelectReasonScreen extends StatelessWidget {
  SelectReasonScreen({super.key, required this.type});

  final String type;

  final List<String> medReasons = <String>[
    'M1.8B11 Нарушение речи, слабость в конечеостях',
    "M1.BA41 Сильная боль в груди",
    "M1.NE81 Опасная травма, ранение, ДТП",
    "3.29. Цунами",
    "M1.MD11 Асфиксия всех видов, острое нарушение дыхания",
    "M1.5. Кровотечение сильное или внутреннее",
    "M1.6. Схватки, роды (скрыто,  добавить)",
    "C5",
    "C6",
    "C7",
    "C8"
  ];

  final List<String> policeReasons = <String>[
    "3.13. Мелкое хулиганство",
    "3.11. Проведения демонстрации, митинга,пикетирования, шествия или собрания",
    "3.11. Пропаганда либо публич. демонстрирование нацистской атрибутики",
    "3.29. Возбуждение ненависти либо вражды",
    "3.11. Кража",
    "M1.5. Мешают спать по ночам или вызывают беспорядки в общественном месте",
    "3.12. Повреждения имущества",
    "3.28. Тепловой удар",
    "3.12. Приступ астмы, проблемы с дыханием",
    "C7",
    "C8"
  ];

  final List<String> mesReasons = <String>[
    "3.13. Пожар в лесу",
    "3.12. Пожар в квартире",
    "3.18. Застряла голова в проеме",
    "3.29. Запах газа в квартире",
    "3.11. Домашнее насилие",
    "3.15. Пожар в здании",
    "3.12. Реагирования в чрезвычайных ситуациях",
    "3.28. Тепловой удар",
    "3.12. Приступ астмы, проблемы с дыханием",
    "C7",
    "C8"
  ];

  List<String> getReasons(String type) {
    if (type == 'med') {
      return medReasons;
    } else if (type == 'mes') {
      return mesReasons;
    } else if (type == 'pol') {
      return policeReasons;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          height: getVerticalSize(48),
          leadingWidth: 43,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: AppbarTitle(text: 'Выбрать причину'),
          styleType: Style.bgFillBlue60001),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: getPadding(top: 14),
                width: MediaQuery.of(context).size.width - 40,
                height: MediaQuery.of(context).size.height - 180,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          color: Color.fromRGBO(178, 218, 255, 100),
                        ),
                        width: MediaQuery.of(context).size.width - 40,
                        height: 80,
                        child: Padding(
                          padding: getPadding(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Причина вызова",
                                style: AppStyle.txtMontserratSemiBold19,
                              ),
                              CustomImageView(
                                svgPath: ImageConstant.imgSettingsLightBlue900,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListView.separated(
                        itemCount: getReasons(type).length,
                        itemBuilder: (BuildContext context, int index) {
                          return ReasonMES(
                            onTap: () {
                              Navigator.pop(context, getReasons(type)[index]);
                            },
                            text: getReasons(type)[index],
                            disable: false,
                            backgroundColor: Colors.white,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(indent: 0, height: 1),
                      ))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
