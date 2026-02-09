import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_button.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/widgets/dangerous_icons/widgets/dirtyMap.dart';
import 'package:careme24/widgets/dangerous_icons/widgets/information_about_virus.dart';
import 'package:careme24/widgets/dangerous_icons/widgets/information_at_day.dart';
import 'package:careme24/widgets/dangerous_icons/widgets/main_info_widget.dart';
import 'package:careme24/widgets/dangerous_icons/widgets/weather_at_day.dart';
import 'package:careme24/widgets/dangerous_icons/widgets/weather_at_hour.dart';
import 'package:flutter/material.dart';

class InfoAtDayPage extends StatefulWidget {
  late String cityName;
  late String infoAboutName;
  late bool visibleMainInfo;
  late bool visibleWind;
  late bool visibleInfoAtDay;
  late bool visibleForecast;
  late bool visibleWeatherAtHour;
  late bool visibleWindowAtHour;
  late bool visibleWeatherAtDay;
  late bool visibleInfoVirus;
  late bool visibleInfoAir;
  late bool visibleInfoDirtyAir;
  late String backGroundColor;
  late String pictureOnIcon;

  InfoAtDayPage({
    super.key,
    required this.cityName,
    required this.infoAboutName,
    required this.visibleMainInfo,
    required this.visibleWind,
    required this.visibleInfoAtDay,
    required this.visibleForecast,
    required this.visibleWeatherAtHour,
    required this.visibleWindowAtHour,
    required this.visibleWeatherAtDay,
    required this.visibleInfoVirus,
    required this.visibleInfoAir,
    required this.visibleInfoDirtyAir,
    required this.backGroundColor,
    required this.pictureOnIcon,
  });

  @override
  State<InfoAtDayPage> createState() => _InfoAtDayPageState();
}

/*MapController controller = MapController(
  initPosition: GeoPoint(latitude: 59.939099, longitude: 30.315877),
);*/

class _InfoAtDayPageState extends State<InfoAtDayPage> {
  @override
  void initState() {
/*    MapController controller = MapController(
      initPosition: GeoPoint(latitude: 59.939099, longitude: 30.315877),
    );*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        appBar: CustomAppBar(
            height: getVerticalSize(48),
            leadingWidth: 43,
            leading: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            centerTitle: true,
            title: AppbarTitle(text: "Природные явления"),
            styleType: Style.bgFillBlue60001),
        body: Align(
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  padding: getPadding(top: 12, bottom: 12),
                  decoration: AppDecoration.white,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(alignment: Alignment.center, children: [
                          CustomImageView(
                              svgPath: widget.backGroundColor,
                              height: getSize(79),
                              width: getSize(79),
                              margin: getMargin(top: 5, left: 10, right: 10)),
                          CustomImageView(
                            svgPath: widget.pictureOnIcon,
                          ),
                        ]),
                        Padding(
                            padding: getPadding(top: 2),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(widget.infoAboutName,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtMontserratRomanSemiBold18Bluegray800)),
                                  Padding(
                                      padding: getPadding(top: 1),
                                      child: Text(widget.cityName,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtMontserratMedium15Blue600)),
                                  CustomButton(
                                      height: getVerticalSize(38),
                                      width: getHorizontalSize(139),
                                      text: "Аномально",
                                      margin: getMargin(top: 8),
                                      variant: ButtonVariant.FillYellowA40001,
                                      padding: ButtonPadding.PaddingAll9,
                                      fontStyle: ButtonFontStyle
                                          .MontserratRomanMedium18Lime900)
                                ]))
                      ])),
              Expanded(
                  child: ListView(children: [
                Visibility(
                  visible: widget.visibleMainInfo,
                  child: MainInfo(),
                ),
                //Visibility(visible: widget.visibleWind, child: WindSpeed()),
                Visibility(
                  visible: widget.visibleInfoAtDay,
                  child: InfoAtDay(
                    date: '02.01.2023',
                    infoText:
                        "На сегодня МЧС рекомендует не ездить по дорогом рядом с каменистой месностью. Высока вероятность камнепада ",
                  ),
                ),
                Visibility(
                  visible: widget.visibleForecast,
                  child: Container(
                    margin: getMargin(bottom: 8, top: 8, left: 16, right: 16),
                    width: MediaQuery.of(context).size.width - 40,
                    child: Text("Прогноз",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtH1),
                  ),
                ),
                Visibility(
                  visible: widget.visibleWeatherAtHour,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      margin: getMargin(bottom: 8, top: 8, left: 16, right: 16),
                      padding: getPadding(bottom: 16),
                      decoration: AppDecoration.outlineGray3004,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WheatherAtHour(
                              hours: "16:00",
                              temperature: "+25.7" "°",
                            ),
                            WheatherAtHour(
                              hours: "17:00",
                              temperature: "+24.6" "°",
                            ),
                            WheatherAtHour(
                              hours: "18:00",
                              temperature: "+23.7" "°",
                            ),
                            WheatherAtHour(
                              hours: "19:00",
                              temperature: "+22.7" "°",
                            ),
                            WheatherAtHour(
                              hours: "20:00",
                              temperature: "+21.7" "°",
                            ),
                          ])),
                ),
                Visibility(
                  visible: widget.visibleWindowAtHour,
                  child: Container(
                    margin: getMargin(top: 8, left: 16, right: 16),
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      children: [
                        SizedBox(
                            height: 64,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 26);
                                },
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return const Row(); /* WindowAtHour(
                                      windDirection: "с-в",
                                      windPower: "0.99",
                                    ); */
                                })),
                        Padding(
                            padding: getPadding(top: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Скорость ветра м/c",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtMontserratMedium12),
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "максимум сегодня ",
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.blueGray800,
                                                fontSize: getFontSize(12),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500)),
                                        TextSpan(
                                            text: "0.99 м/c ",
                                            style: TextStyle(
                                                color:
                                                    ColorConstant.blueGray800,
                                                fontSize: getFontSize(12),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600))
                                      ]),
                                      textAlign: TextAlign.left)
                                ])),
                        const Divider(
                          thickness: 1,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.visibleWeatherAtDay,
                  child: Container(
                      margin: getMargin(bottom: 8, top: 8, left: 16, right: 16),
                      width: MediaQuery.of(context).size.width - 40,
                      height: 75,
                      child: ListView.separated(
                          padding: getPadding(left: 1, bottom: 7),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: getVerticalSize(20));
                          },
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return WheatherAtDay(
                                isToday: true,
                                day: "вт",
                                minTemperature: "+25.7",
                                maxTemperature: "+30.9");
                          })),
                ),
                Visibility(
                  visible: widget.visibleInfoVirus,
                  child: const InfoAboutVirus(),
                )
              ])),
              Visibility(
                  visible: widget.visibleInfoAir,
                  child: Column(children: [
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
                                          builder: (context) =>
                                              const DirtyMapScreen()));
                                },
                                child: Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    margin: getMargin(
                                      bottom: 8,
                                    ),
                                    padding: getPadding(
                                        left: 12,
                                        top: 19,
                                        right: 12,
                                        bottom: 19),
                                    decoration: AppDecoration.outlineBlack9003f3
                                        .copyWith(
                                            borderRadius: BorderRadiusStyle
                                                .roundedBorder10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text("Радиус нанесения удара",
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtMontserratMedium15Bluegray800),
                                                Text("Москва",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtMontserratSemiBold18)
                                              ]),
                                          Text("30 км",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtMontserratRomanSemiBold32)
                                        ]))))),
                  ])),
              Visibility(
                  visible: widget.visibleInfoDirtyAir,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding:
                          getPadding(left: 12, top: 19, right: 12, bottom: 19),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: Text("Прогноз",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtH1),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      padding: getPadding(bottom: 16, top: 12),
                                      decoration: AppDecoration.outlineGray3004,
                                      child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [])),
                                  Padding(
                                      padding: getPadding(top: 16, bottom: 8),
                                      child: Text("Характеристики",
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: ColorConstant.blueGray800,
                                            fontSize: getFontSize(
                                              18,
                                            ),
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                          ))),
                                  Padding(
                                      padding: getPadding(
                                          top: 10,
                                          left: 7,
                                          right: 7,
                                          bottom: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Загрязнитель',
                                              style: TextStyle(
                                                color:
                                                    ColorConstant.blueGray800,
                                                fontSize: getFontSize(
                                                  12,
                                                ),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text('Концентрация',
                                              style: TextStyle(
                                                color:
                                                    ColorConstant.blueGray800,
                                                fontSize: getFontSize(
                                                  12,
                                                ),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text('%',
                                              style: TextStyle(
                                                color:
                                                    ColorConstant.blueGray800,
                                                fontSize: getFontSize(
                                                  12,
                                                ),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500,
                                              ))
                                        ],
                                      )),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _dirty(0.2, 'Название', '44 рр');
                                      }),
                                ]),
                          ])))
            ])),
      ),
    );
  }

  Widget _dirty(double value, String elementName, String elementValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: getPadding(left: 7, top: 5, bottom: 8),
          child: SizedBox(
              // height: getVerticalSize(40),
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius:
                          BorderRadius.circular(getHorizontalSize(20)),
                      child: LinearProgressIndicator(
                          minHeight: 9.0,
                          value: value,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorConstant.blueGray800))),
                  Padding(
                      padding: getPadding(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(elementName,
                              style: TextStyle(
                                color: ColorConstant.blueGray800,
                                fontSize: getFontSize(
                                  14,
                                ),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                              )),
                          Text(elementValue,
                              style: TextStyle(
                                color: ColorConstant.gray50001,
                                fontSize: getFontSize(
                                  14,
                                ),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ))
                        ],
                      ))
                ],
              )),
        ),
        Padding(
            padding: getPadding(left: 7, top: 1, right: 2),
            child: Container(
                padding: getPadding(all: 6),
                decoration: BoxDecoration(
                    color: ColorConstant.gray400,
                    borderRadius: BorderRadius.circular(getHorizontalSize(10))),
                child: Text("${value * 100}%",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstant.black900,
                      fontSize: getFontSize(
                        15,
                      ),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ))))
      ],
    );
  }

  onTapArrowleft64(BuildContext context) {
    Navigator.pop(context);
  }
}
