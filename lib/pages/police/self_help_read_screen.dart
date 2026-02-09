import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_image_view.dart';

class SelfHelpReadScreen extends StatelessWidget {
  const SelfHelpReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: SizedBox(
                width: double.maxFinite,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 48,
                              color: ColorConstant.blue60001,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomImageView(
                                        margin: getMargin(left: 16),
                                        svgPath: ImageConstant.imgArrowleft,
                                        onTap: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text("Самопомощь",
                                          style: AppStyle.txtMontserratBold20
                                              .copyWith(
                                            color: ColorConstant.whiteA700,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                width: getHorizontalSize(214),
                                margin: getMargin(left: 23, top: 18),
                                child: Text("Боль в ухе. Причины \nи лечение",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtMontserratSemiBold20)),
                            Align(
                                alignment: Alignment.center,
                                child: Container(
                                    width: getHorizontalSize(327),
                                    margin:
                                        getMargin(left: 23, top: 17, right: 24),
                                    child: Text(
                                        "Прогулка в ветреный день, неосторожное купание, когда в ухо попала вода, ОРВИ – все это может вызвать резкую боль в ухе. Не всегда есть возможность попасть к врачу сразу, \nа терпеть ушную боль сложно – она мешает заниматься привычными делами, спать. Узнаем с помощью отоларингологов ЛДЦ «Кутузовский» почему может болеть ухо, и какую первую помощь можно оказать \nв домашних условиях.",
                                        maxLines: null,
                                        textAlign: TextAlign.left,
                                        style:
                                            AppStyle.txtMontserratRegular15))),
                            Padding(
                                padding: getPadding(left: 23, top: 14),
                                child: Text("Ухо и его особенности",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtH1)),
                            Container(
                                width: getHorizontalSize(312),
                                margin: getMargin(left: 23, top: 13, right: 39),
                                child: Text(
                                    "Человеческое ухо – сложный \nи функциональный орган. Оно не только позволяет нам слышать звуки, речь, \nа и помогает ориентироваться \nв пространстве, сохранять координацию движений, определить, откуда идет звук, активизирует кору головного мозга \nи мозговые центры в нем. Слух – важное чувство для коммуникации, но чаще мы осознаем это, только тогда, когда \nон ухудшается или теряется вовсе.",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    style: AppStyle
                                        .txtMontserratMedium15Bluegray800)),
                            Container(
                                width: getHorizontalSize(277),
                                margin: getMargin(left: 23, top: 14, right: 74),
                                child: Text(
                                    "В человеческом ухе три основных отдела:",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    style: AppStyle
                                        .txtMontserratSemiBold15Bluegray800)),
                            Padding(
                                padding:
                                    getPadding(left: 23, top: 11, right: 38),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: getSize(9),
                                          width: getSize(9),
                                          margin: getMargin(top: 6, bottom: 42),
                                          decoration: BoxDecoration(
                                              color: ColorConstant.blue60001,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      getHorizontalSize(4)))),
                                      Expanded(
                                          child: Container(
                                              width: getHorizontalSize(286),
                                              margin: getMargin(left: 18),
                                              child: Text(
                                                  "Ушной раковины, которая собирает звуки и направляет их в наружный слуховой проход.",
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtMontserratMedium15Bluegray800)))
                                    ])),
                            Padding(
                                padding:
                                    getPadding(left: 23, top: 12, right: 36),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: getSize(9),
                                          width: getSize(9),
                                          margin: getMargin(top: 5, bottom: 38),
                                          decoration: BoxDecoration(
                                              color: ColorConstant.blue60001,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      getHorizontalSize(4)))),
                                      Expanded(
                                          child: Container(
                                              width: getHorizontalSize(288),
                                              margin: getMargin(left: 17),
                                              child: Text(
                                                  "Наружного слухового прохода, который предназначен для проведения звуковых колебаний от ушной раковины в барабанную полость среднего уха. Его длина у взрослых примерно 2,6 см. Так же поверхность наружного слухового прохода содержит сальные железы, которые выделяют ушную серу, защищающую ухо от микробов и бактерий.",
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtMontserratMedium15Bluegray800)))
                                    ])),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding:
                                        getPadding(left: 33, top: 12, right: 9),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: getSize(9),
                                              width: getSize(9),
                                              margin:
                                                  getMargin(top: 5, bottom: 40),
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorConstant.blue60001,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getHorizontalSize(
                                                              4)))),
                                          Expanded(
                                              child: Container(
                                                  width: getHorizontalSize(316),
                                                  margin: getMargin(
                                                      left: 8, bottom: 12),
                                                  child: Text(
                                                      "если вы находитесь в лесу, где возник пожар, то определите направление ветра и распространения огня;",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtMontserratMedium15Bluegray800)))
                                        ])))
                          ])))
                    ]))));
  }
}
