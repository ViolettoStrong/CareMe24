import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class InfoMainIcon extends StatelessWidget {
  late String backGroundColor;
  late String pictureOnIcon;
  late String warningName;
  late String infoOfWarning;

  bool visibleMainInfo = false;
  bool visibleInfoAtDay = false;
  bool visibleForecast = false;
  bool visibleWind = false;
  bool visibleWeatherAtHour = false;
  bool visibleWindowAtHour = false;
  bool visibleWeatherAtDay = false;
  bool visibleInfoVirus = false;
  bool visibleInfoAir = false;
  bool visibleInfoDirtyAir = false;

  InfoMainIcon({
    super.key,
    required this.backGroundColor,
    required this.pictureOnIcon,
    required this.warningName,
    required this.infoOfWarning,
  });

  void changePage() {
    print(warningName);
    switch (warningName) {
      case "Загрязнение воздуха":
        visibleInfoAir = true;
        visibleInfoDirtyAir = true;
        break;
      case "Ветер":
        visibleWind = true;
        visibleForecast = true;
        visibleWindowAtHour = true;
        visibleWeatherAtDay = true;
        break;
      case "Шквал":
        visibleMainInfo = true;
        visibleForecast = true;
        visibleWindowAtHour = true;
        break;
      case "Ураган":
        visibleMainInfo = true;
        visibleForecast = true;
        visibleWindowAtHour = true;
        break;
      case "Высокая температура":
        visibleMainInfo = true;
        visibleForecast = true;
        visibleWeatherAtHour = true;
        break;
      case "Низкая температура":
        visibleMainInfo = true;
        visibleForecast = true;
        visibleWeatherAtHour = true;
        break;
      case "Атм.давл.":
        visibleMainInfo = true;
        visibleForecast = true;
        visibleWeatherAtHour = true;
        visibleWeatherAtDay = true;
        break;
      case "Бакт.зараж.":
        visibleMainInfo = true;
        visibleInfoAtDay = true;
        visibleInfoVirus = true;
        break;
      case "Град":
        visibleInfoAtDay = true;
        visibleForecast = true;
        visibleWeatherAtHour = true;
        visibleWindowAtHour = true;
        visibleWeatherAtDay = true;
        break;
      case "Гололед":
        visibleInfoAtDay = true;
        visibleForecast = true;
        visibleWeatherAtHour = true;
        visibleWindowAtHour = true;
        visibleWeatherAtDay = true;
        break;
      case "Землетрясение":
        visibleMainInfo = true;
        visibleInfoAtDay = true;
        break;
      case "Вулкан":
        visibleMainInfo = true;
        visibleInfoAtDay = true;
        break;
      case "Камнепад / Оползень":
        visibleInfoAtDay = true;
        break;
      case "Наводнение":
        visibleInfoAtDay = true;
        break;
      case "Пожар":
        visibleInfoAtDay = true;
        visibleForecast = true;
        visibleWeatherAtHour = true;
        visibleWindowAtHour = true;
        break;
      case "Радиация":
        visibleMainInfo = true;
        visibleInfoAtDay = true;
        break;
      case "Солн.рад.":
        visibleInfoAtDay = true;
        break;
      case "Эл.магн.изл.":
        visibleInfoAtDay = true;
        break;
      case "Сн.лавина":
        visibleInfoAtDay = true;
        break;
      case "Терр.опасн.":
        visibleInfoAtDay = true;
        break;
      case "Торнадо":
        visibleInfoAtDay = true;
        break;
      case "Туман":
        visibleInfoAtDay = true;
        break;
      case "Цунами":
        visibleInfoAtDay = true;
        break;
      case "Возд.трев.":
        visibleInfoAir = true;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          /*  onTap: () {
        changePage();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InfoAtDayPage(
                      cityName: "Москва",
                      infoAboutName: warningName,
                      visibleMainInfo: visibleMainInfo,
                      visibleWind: visibleWind,
                      visibleInfoAtDay: visibleInfoAtDay,
                      visibleForecast: visibleForecast,
                      visibleWeatherAtHour: visibleWeatherAtHour,
                      visibleWindowAtHour: visibleWindowAtHour,
                      visibleWeatherAtDay: visibleWeatherAtDay,
                      visibleInfoVirus: visibleInfoVirus,
                      visibleInfoAir: visibleInfoAir,
                      visibleInfoDirtyAir: visibleInfoDirtyAir,
                      backGroundColor: backGroundColor,
                      pictureOnIcon: pictureOnIcon,
                    )));
      }, */
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
                width: 110,
                child: Text(
                  warningName,
                  maxLines: null,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.txtInterExtraBold12.copyWith(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )),
            Stack(alignment: Alignment.center, children: [
              CustomImageView(
                  color: const Color.fromRGBO(162, 167, 171, 1),
                  svgPath: backGroundColor,
                  height: getSize(79),
                  width: getSize(79),
                  margin: getMargin(top: 2)),
              Center(
                child: CustomImageView(
                  color: Colors.white,
                  svgPath: pictureOnIcon,
                  height: getSize(60),
                  width: getSize(60),
                ),
              ),
            ]),
            Padding(
                padding: getPadding(top: 0),
                child: Text(infoOfWarning,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratF14W600Gray2))
          ]),
        ));
  }
}
