import 'package:careme24/pages/police/police_recomendation_read_page.dart';
import 'package:careme24/pages/police/self_help_read_screen.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_style.dart';
import '../../../widgets/custom_image_view.dart';

class SelfhelpItemWidget extends StatelessWidget {
  late String imagepath;
  late String wherecall;
  late String textproblem;
  SelfhelpItemWidget({
    super.key,
    required this.imagepath,
    required this.textproblem,
    required this.wherecall,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (wherecall == "Скорая") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelfHelpReadScreen()));
            } else if (wherecall == "Полиция") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PoliceRecomendationReadPage()));
            } else if (wherecall == "МЧС") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PoliceRecomendationReadPage()));
            }
          },
          child: Card(
            clipBehavior: Clip.hardEdge,
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImageView(
                    imagePath: imagepath,
                    height: getVerticalSize(
                      126,
                    ),
                    width: getHorizontalSize(
                      99,
                    ),
                    alignment: Alignment.center,
                  ),
                  Padding(
                    padding: getPadding(
                      top: 8,
                      right: 9,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgEye,
                              height: getVerticalSize(
                                8,
                              ),
                              width: getHorizontalSize(
                                20,
                              ),
                              margin: getMargin(
                                top: 4,
                                bottom: 5,
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 7,
                              ),
                              child: Text(
                                "45 607",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtMontserratMedium14Gray,
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 91,
                              ),
                              child: Text(
                                "4.7",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtMontserratMedium14Gray,
                              ),
                            ),
                            CustomImageView(
                              svgPath: ImageConstant.imgStarGold,
                              height: getSize(
                                13,
                              ),
                              width: getSize(
                                13,
                              ),
                              margin: getMargin(
                                left: 3,
                                top: 1,
                                bottom: 3,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: getHorizontalSize(
                            202,
                          ),
                          margin: getMargin(
                            top: 8,
                          ),
                          child: Text(
                            textproblem,
                            maxLines: null,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtMontserratRomanMedium14,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 22,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "22.03.2022",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtMontserratMedium12Gray50001,
                              ),
                              CustomImageView(
                                svgPath: ImageConstant.imgArrowright,
                                height: getVerticalSize(
                                  10,
                                ),
                                width: getHorizontalSize(
                                  5,
                                ),
                                margin: getMargin(
                                  left: 137,
                                  top: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
