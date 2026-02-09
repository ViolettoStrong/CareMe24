// ignore_for_file: non_constant_identifier_names

import 'package:careme24/constants.dart';
import 'package:careme24/features/chat/presentation/chat_page.dart';
import 'package:careme24/features/chat/presentation/chat_rooms_page.dart';
import 'package:careme24/models/service_model.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../../theme/app_style.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';

class RecordFinalScreen extends StatelessWidget {
  final String id;
  final String institution_type;
  final ServiceModel? service;
  const RecordFinalScreen({
    required this.id,
    required this.institution_type,
    this.service,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
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
          title: AppbarTitle(text: 'Завершение'),
          styleType: Style.bgFillBlue60001,
        ),
        body: Container(
          width: double.maxFinite,
          padding: getPadding(left: 22, top: 178, right: 22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomImageView(
                  svgPath: ImageConstant.imgUserBlue600,
                  height: getSize(75),
                  width: getSize(75)),
              Padding(
                padding: getPadding(top: 31),
                child: Text(
                  "Запись успешно осуществлена!",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtMontserratMedium15Blue600,
                ),
              ),
              Padding(
                padding: getPadding(top: 8),
                child: Text(
                  TipyHelp.helpName,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: AppStyle.txtMontserratBold18Blue,
                ),
              ),
              Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (service != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              // service: service,
                              serviceId: service!.id,
                              serviceName: service!.name,
                              serviceSpecialization: service!.specialization,
                              servicePhoto: service!.photo,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomsPage(
                              id: id,
                              institution_type: institution_type,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Перейти",
                          style: AppStyle.txtMontserratSemiBold18WhiteA700,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  onTapArrowleft34(BuildContext context) {
    Navigator.pop(context);
  }
}
