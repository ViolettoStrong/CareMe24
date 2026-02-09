import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class DirtyMapScreen extends StatefulWidget {
  const DirtyMapScreen({super.key});

  @override
  State<DirtyMapScreen> createState() => _DirtyMapScreenState();
}

class _DirtyMapScreenState extends State<DirtyMapScreen> {
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
                title: AppbarTitle(text: "Карта загрязнения"),
                styleType: Style.bgFillBlue60001),
            body: SizedBox(
                height: getVerticalSize(727),
                width: double.maxFinite,
                child: Stack(children: [
                  /*  OSMFlutter(
                    controller: controller,
                    //markerOption: MarkerOption(defaultMarker: MarkerIcon(icon: ,)),

                    onMapIsReady: (_ready) async {
                      await controller.drawCircle(CircleOSM(
                          key: "airWarning",
                          centerPoint: GeoPoint(
                              latitude: 59.939099, longitude: 30.315877),
                          radius: 1000,
                          color: Colors.red,
                          strokeWidth: 0.3));
                    },
                    osmOption: OSMOption(),
                  ),*/
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: getPadding(all: 8),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                getHorizontalSize(
                                  15,
                                ),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: getPadding(
                                    top: 8, bottom: 8, right: 8, left: 8),
                                child: const Text('Зона поражения'),
                              ),
                              Container(
                                height: 3.0,
                                width: 20.0,
                                color: Colors.red,
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                              )
                            ],
                          ),
                        )),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                          height: getVerticalSize(56),
                          text: "Подробнее на сайте",
                          margin: getMargin(left: 20, right: 23, bottom: 44),
                          variant: ButtonVariant.OutlineBlue600_1,
                          shape: ButtonShape.RoundedBorder15))
                ]))));
  }

  onTapArrowleft16(BuildContext context) {
    Navigator.pop(context);
  }
}
