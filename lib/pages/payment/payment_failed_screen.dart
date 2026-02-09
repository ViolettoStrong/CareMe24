import 'package:careme24/router/app_router.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_button.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/widgets/outline_gradient_button.dart';
import 'package:flutter/material.dart';

import '../../utils/size_utils.dart';

class PaymentFailedScreen extends StatelessWidget {
  const PaymentFailedScreen({super.key});

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
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                centerTitle: true,
                title: AppbarTitle(text: 'Оплата'),
                styleType: Style.bgFillBlue60001),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 23, top: 154, right: 23),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImageView(
                          svgPath: ImageConstant.imgWarningPink60001,
                          height: getSize(39),
                          width: getSize(39)),
                      Padding(
                          padding: getPadding(top: 21),
                          child: Text("Не удалось опалтить счет",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtMontserratBold20Bluegray800)),
                      Padding(
                          padding: getPadding(top: 10),
                          child: Text("Попробуйте еще раз позже",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style:
                                  AppStyle.txtMontserratMedium15Bluegray800)),
                      CustomButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: "Повторить попытку",
                          margin: getMargin(top: 44),
                          variant: ButtonVariant.OutlineIndigo20049_1,
                          fontStyle: ButtonFontStyle.MontserratRomanSemiBold18),
                      Padding(
                          padding: getPadding(top: 14, bottom: 5),
                          child: OutlineGradientButton(
                              padding: EdgeInsets.only(
                                  left: getHorizontalSize(1),
                                  top: getVerticalSize(1),
                                  right: getHorizontalSize(1),
                                  bottom: getVerticalSize(1)),
                              strokeWidth: getHorizontalSize(1),
                              gradient: LinearGradient(
                                  begin: const Alignment(1.05, 0.11),
                                  end: const Alignment(-0.02, 0.83),
                                  colors: [
                                    ColorConstant.blue60001,
                                    ColorConstant.indigoA400
                                  ]),
                              corners: const Corners(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              child: CustomButton(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRouter.appContainer);
                                  },
                                  height: getVerticalSize(56),
                                  text: "Вернуться на главную",
                                  variant: ButtonVariant.Outline_1)))
                    ]))));
  }

  onTapArrowleft51(BuildContext context) {
    Navigator.pop(context);
  }
}
