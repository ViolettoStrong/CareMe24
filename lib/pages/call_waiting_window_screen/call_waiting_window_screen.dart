import 'package:careme24/app_container.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/features/chat/presentation/chat_rooms_page.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class CallWaitingWindowScreen extends StatelessWidget {
  final String id;
  const CallWaitingWindowScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 48,
                color: ColorConstant.blue60001,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomImageView(
                          margin: getMargin(left: 16, right: 15),
                          svgPath: ImageConstant.imgArrowleft,
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    ),
                    Expanded(
                        child: Text("Ожидайте",
                            textAlign: TextAlign.center,
                            style: AppStyle.txtMontserratBold20.copyWith(
                              color: ColorConstant.whiteA700,
                            )))
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: getVerticalSize(294),
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: AppDecoration.outlineBlack9003f2.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: getPadding(top: 24),
                              child: Text(
                                WhoCall.callName,
                                style: AppStyle.txtMontserratSemiBold25Blue,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Text(
                              "Время ожидания",
                              style: AppStyle.txtMontserratRomanSemiBold18Gray,
                            ),
                            Padding(
                              padding: getPadding(top: 24),
                              child: Text(
                                "10 МИН",
                                style: AppStyle.txtMontserratSemiBold36Black,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Отследить на карте",
                                style: AppStyle.txtMontserratSemiBold18,
                              ),
                            ),
                          ],
                        )),
                    Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            print(WhoCall.callName.toString());
                            if ((WhoCall.callName
                                    .toString()
                                    .contains('МЧС ВЫЗВАН')) ||
                                (WhoCall.callName
                                    .toString()
                                    .contains('ПОЛИЦИЯ ВЫЗВАНА'))) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AppContainer(0)));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoomsPage(
                                    id: id,
                                    institution_type: "",
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                              margin: getMargin(top: 56),
                              width: MediaQuery.of(context).size.width - 40,
                              height: 56,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      ColorConstant.indigoA400,
                                      ColorConstant.bluegradient,
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                (WhoCall.callName
                                            .toString()
                                            .contains('МЧС ВЫЗВАН') ||
                                        (WhoCall.callName
                                            .toString()
                                            .contains('ПОЛИЦИЯ ВЫЗВАНА')))
                                    ? 'На главную'
                                    : "Написать врачу",
                                style:
                                    AppStyle.txtMontserratSemiBold18WhiteA700,
                              ))),
                        ))
                  ],
                ),
              ),
            ])));
  }
}
