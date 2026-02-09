import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class PoliceMESInfoCard extends StatelessWidget {
  late String policeMESName;
  late String addres;
  late String meters;
  late String minutes;
  late String estimation;
  late String imagePath;
  late String reasonText;
  late Color cardColor;
  late String whereCall;

  PoliceMESInfoCard({
    super.key,
    required this.policeMESName,
    required this.addres,
    required this.meters,
    required this.minutes,
    required this.estimation,
    required this.imagePath,
    required this.reasonText,
    required this.cardColor,
    required this.whereCall,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            /*  print(whereCall);
        if (whereCall == "police") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlotsPoliceScreen(reasonText)));
        } else if(whereCall == "MES") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MESInfiScreen(reasonText)));
        } else if(whereCall == "MES_about") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AboutMES()));
        } else if(whereCall == "Police_about") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPolice()));
        } */
          },
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(253, 253, 253, 100),
              ),
              width: MediaQuery.of(context).size.width - 46,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          width: 67,
                          height: 78,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(30)),
                          ),
                          child: Stack(alignment: Alignment.center, children: [
                            CustomImageView(
                              svgPath: imagePath,
                            ),
                          ])),
                      Padding(
                        padding: getPadding(left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(policeMESName,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  style:
                                      AppStyle.txtMontserratSemiBold15Blue600),
                            ),
                            Padding(
                              padding: getPadding(top: 3),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(addres,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyle
                                        .txtMontserratMedium12Gray50001),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                    indent: 0,
                    height: 1,
                    thickness: 1,
                    color: ColorConstant.gray50002,
                  ),
                  Padding(
                      padding: getPadding(left: 14, top: 12),
                      child: Row(children: [
                        Text(meters,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtMontserratMedium16),
                        Padding(
                            padding: getPadding(left: 17),
                            child: Text(minutes,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtMontserratMedium16)),
                        Padding(
                            padding: getPadding(left: 16),
                            child: Text(estimation,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtMontserratMedium16)),
                        CustomImageView(
                            svgPath: ImageConstant.imgStarGold,
                            height: getSize(14),
                            width: getSize(14),
                            margin: getMargin(left: 3, top: 2, bottom: 3))
                      ])),
                  Padding(
                    padding: getPadding(left: 14, top: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: ColorConstant.blue30001,
                            // border color
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            // border width
                            child: Container(
                              // or ClipRRect if you need to clip the content
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white // inner circle color
                                  ),
                              child: Container(), // inner content
                            ),
                          ),
                        ),
                        Padding(
                          padding: getPadding(left: 4),
                          child: Text(
                            "Оставить по умолчанию",
                            style: AppStyle.txtMontserratMedium10Blue,
                          ),
                        ),
                        Padding(
                          padding: getPadding(left: 144),
                          child: CustomImageView(
                              svgPath: ImageConstant.imgVector87,
                              height: getVerticalSize(9),
                              width: getHorizontalSize(5),
                              margin: getMargin(top: 1, bottom: 2)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
