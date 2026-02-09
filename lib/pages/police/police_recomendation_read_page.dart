import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../theme/app_style.dart';
import '../../widgets/custom_image_view.dart';

class PoliceRecomendationReadPage extends StatelessWidget {
  const PoliceRecomendationReadPage({super.key});

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
                                      child: Text("Рекомендации",
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
                                width: MediaQuery.of(context).size.width - 40,
                                margin: getMargin(left: 23, top: 18),
                                child: Text(
                                    "Как себя вести при ограблении в магазине или в офисе",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.clip,
                                    style: AppStyle.txtMontserratSemiBold20)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: Padding(
                                  padding: getPadding(left: 23, top: 14),
                                  child: Text(
                                      "Что делать если вы оказались в зоне лесного пожара:",
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtH1)),
                            ),
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
                                                  "если вы находитесь в лесу, где возник пожар, то определите направление ветра и распространения огня;.",
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
                                                  "выходите из опасной зоны только вдоль распространения пожара;",
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
                                                      "бегите вдоль фронта огня; не обгоняйте лесной пожар; для преодоления нехватки кислорода пригнитесь к земле;",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtMontserratMedium15Bluegray800)))
                                        ]))),
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
                                                      "дышите через мокрый платок или смоченную одежду;",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtMontserratMedium15Bluegray800)))
                                        ]))),
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
                                                      "если невозможно уйти от пожара, войдите в водоем или накройтесь мокрой одеждой, окунитесь в ближайший водоем.",
                                                      maxLines: null,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtMontserratMedium15Bluegray800))),
                                        ]))),
                            Container(
                                width: getHorizontalSize(312),
                                margin: getMargin(left: 23, top: 13, right: 39),
                                child: Text(
                                    "После выхода из зоны пожара сообщите о месте, размерах и характере пожара в пожарную охрану по телефону 01, лесничество или по телефону 112.",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    style: AppStyle
                                        .txtMontserratMedium15Bluegray800)),
                          ])))
                    ]))));
  }
}
